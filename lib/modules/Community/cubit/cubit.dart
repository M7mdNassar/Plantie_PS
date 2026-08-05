import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:plantie/modules/Community/cubit/states.dart';
import 'package:plantie/shared/network/remote/supabase_service.dart';
import '../../../models/post/post_model.dart';
import '../../../models/user/user_model.dart';
import '../../../shared/network/local/history_db.dart';
import '../../../shared/network/local/image_storage_helper.dart';
import '../../../shared/network/local/social_upload_service.dart';
import '../../../shared/network/remote/supabase_auth_service.dart';
import '../../../shared/components/components.dart';

class CommunityCubit extends Cubit<CommunityStates> {
  static CommunityCubit get(context) => BlocProvider.of(context);

  CommunityCubit() : super(CommunityInitialState());

  final ImagePicker _picker = ImagePicker();
  final List<File> _postImages = [];
  static const int _maxPostImages = 4;
  int _currentPage = 0;
  final int _pageSize = 15;
  bool _hasMore = true;
  bool isFetchingMore = false;
  final Set<String> _likesInFlight = {};
  bool _realtimeInitiated = false;
  RealtimeChannel? _postsChannel;
  RealtimeChannel? _postImagesChannel;
  RealtimeChannel? _commentsChannel;
  RealtimeChannel? _likesChannel;

  bool isCreatingPost = false;

  Timer? _searchTimer;
  bool isSearching = false;
  List<PostModel> filteredPosts = [];
  final TextEditingController searchController = TextEditingController();

  String _feedSort = 'latest';
  String get feedSort => _feedSort;

  late List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  List<File> get postImages => _postImages;

  bool hasMore() => _hasMore;

  final HistoryDBHelper _historyDb = HistoryDBHelper();

  int _requestId = 0;

  // ✅ Track if posts were already loaded to prevent refetching on tab switch
  bool _postsLoaded = false;

  // ✅ Config fetch cooldown (10 minutes)
  static DateTime? _lastConfigFetch;

  // ✅ Pending post count
  int get pendingPostCount => _posts.where((p) => p.postId.startsWith('pending_')).length;

  bool get hasPendingPost => pendingPostCount > 0;

  // ✅ Force refresh – clears loaded flag and fetches fresh
  Future<void> forceRefresh() async {
    _postsLoaded = false;
    _currentPage = 0;
    _hasMore = true;
    await getPosts(refresh: true);
  }

  Future<void> setSortFilter(String sortType) async {
    if (_feedSort == sortType) return;

    final previousSort = _feedSort;
    _feedSort = sortType;
    debugPrint('📊 Feed sort changed to: $sortType');

    final authService = SupabaseAuthService();
    final hasInternet = await authService.isConnectedFast();
    if (!hasInternet) {
      _feedSort = previousSort;
      emit(CommunityOfflineState());
      return;
    }

    _currentPage = 0;
    _hasMore = true;
    _postsLoaded = false;
    await getPosts(refresh: true);
  }

  // --------------------------------------------------------------------------
  // REAL-TIME SUBSCRIPTIONS
  // --------------------------------------------------------------------------
  void _initRealtimeSubscriptions() {
    if (_realtimeInitiated) return;
    _realtimeInitiated = true;

    _postsChannel = supabaseService.client
        .channel('public:community-posts')
        .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'posts',
      callback: (payload) async {
        final eventType = payload.eventType.toString().toUpperCase();
        if (eventType.contains('INSERT')) {
          await _handleRealtimePost(payload.newRecord);
        } else if (eventType.contains('UPDATE')) {
          await _handleRealtimePost(payload.newRecord);
        } else if (eventType.contains('DELETE')) {
          _removeRealtimePost(payload.oldRecord);
        }
      },
    ).subscribe();

    _postImagesChannel = supabaseService.client
        .channel('public:community-post-images')
        .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'post_images',
      callback: (payload) async {
        final isDelete = payload.eventType.toString().toUpperCase().contains('DELETE');
        final record = isDelete ? payload.oldRecord : payload.newRecord;
        final postId = record['post_id']?.toString();
        if (postId == null || postId.isEmpty) return;
        await _syncPostImages(postId);
      },
    ).subscribe();

    _commentsChannel = supabaseService.client
        .channel('public:community-comments')
        .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'comments',
      callback: (payload) async {
        final isDelete = payload.eventType.toString().toUpperCase().contains('DELETE');
        final record = isDelete ? payload.oldRecord : payload.newRecord;
        final postId = record['post_id']?.toString();
        if (postId == null || postId.isEmpty) return;
        await _syncComment(postId);
      },
    ).subscribe();

    _likesChannel = supabaseService.client
        .channel('public:community-likes')
        .onPostgresChanges(
      event: PostgresChangeEvent.all,
      schema: 'public',
      table: 'post_likes',
      callback: (payload) async {
        final isDelete = payload.eventType.toString().toUpperCase().contains('DELETE');
        final record = isDelete ? payload.oldRecord : payload.newRecord;
        final postId = record['post_id']?.toString();
        if (postId == null || postId.isEmpty) return;
        await _syncLike(postId);
      },
    ).subscribe();
  }

  Future<void> _handleRealtimePost(Map<String, dynamic>? record) async {
    if (record == null) return;
    final postId = record['id']?.toString();
    if (postId == null || postId.isEmpty) return;

    debugPrint('🔔 Real-time post event: $postId');

    try {
      final response = await supabaseService.client
          .from('posts')
          .select('*, users(*), post_images(*)')
          .eq('id', postId)
          .single();
      final newPost = PostModel.fromJson(response);

      final index = _posts.indexWhere((p) => p.postId == postId);
      if (index == -1) {
        _posts.insert(0, newPost);
      } else {
        _posts[index] = newPost;
      }
      emit(CommunityPostsLoadedState(List.from(_posts)));
    } catch (e) {
      debugPrint('❌ Error fetching real-time post: $e');
    }
  }

  void _removeRealtimePost(Map<String, dynamic>? record) {
    if (record == null) return;
    final postId = record['id']?.toString();
    if (postId == null || postId.isEmpty) return;

    _posts.removeWhere((p) => p.postId == postId);
    filteredPosts.removeWhere((p) => p.postId == postId);

    if (isSearching) {
      emit(CommunitySearchResultsState(filteredPosts));
    } else if (_posts.isEmpty) {
      emit(CommunityEmptyState());
    } else {
      emit(CommunityPostsLoadedState(_posts));
    }
  }

  Future<void> _syncPostImages(String postId) async {
    await _refreshSinglePost(postId);
  }

  Future<void> _syncComment(String postId) async {
    await _refreshSinglePost(postId);
  }

  Future<void> _syncLike(String postId) async {
    if (_likesInFlight.contains(postId)) return;
    await _refreshSinglePost(postId);
  }

  Future<void> _refreshSinglePost(String postId) async {
    try {
      final response = await supabaseService.client
          .from('posts')
          .select('*, users(*), post_images(*)')
          .eq('id', postId)
          .single();
      final updatedPost = PostModel.fromJson(response);
      final index = _posts.indexWhere((p) => p.postId == postId);
      if (index != -1) {
        final currentLiked = _posts[index].userLiked;
        final finalPost = updatedPost.copyWith(userLiked: currentLiked);
        _posts[index] = finalPost;
        if (isSearching) {
          final fIndex = filteredPosts.indexWhere((p) => p.postId == postId);
          if (fIndex != -1) filteredPosts[fIndex] = finalPost;
          emit(CommunitySearchResultsState(filteredPosts));
        } else {
          emit(CommunityPostsLoadedState(_posts));
        }
      }
    } catch (e) {
      debugPrint('❌ Error refreshing single post: $e');
    }
  }

  // --------------------------------------------------------------------------
  // POST FETCHING – ALWAYS SHOW CACHED POSTS FIRST
  // --------------------------------------------------------------------------
  Future<void> getPosts({bool refresh = false}) async {
    // ✅ If posts are already loaded and not refreshing, skip fetch
    if (_postsLoaded && !refresh) {
      debugPrint('📋 Posts already loaded, skipping fetch');
      return;
    }

    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
    }
    if (isFetchingMore || (!_hasMore && !refresh)) return;

    final currentRequestId = ++_requestId;

    final authService = SupabaseAuthService();
    final hasInternet = await authService.isConnectedFast();

    // ✅ ALWAYS load cached posts first (if available)
    final cached = await _loadCachedPosts();
    if (cached.isNotEmpty) {
      _posts = cached;
      _postsLoaded = true;
      if (currentRequestId == _requestId) {
        emit(CommunityPostsLoadedState(List.from(_posts)));
      }
    }

    // ✅ If offline or no internet, stop here (cached posts are already shown)
    if (!hasInternet) {
      if (cached.isEmpty && currentRequestId == _requestId) {
        emit(CommunityOfflineState());
      }
      return;
    }

    // ✅ Online – fetch fresh posts in background
    try {
      isFetchingMore = true;
      if (!refresh && _posts.isNotEmpty) {
        emit(CommunityLoadingMoreState());
      }

      PostgrestTransformBuilder<PostgrestList> query = supabaseService.client
          .from('posts')
          .select('*, users(*), post_images(*)');

      switch (_feedSort) {
        case 'latest':
          query = query.order('created_at', ascending: false);
          break;
        case 'popular':
          query = query.order('like_count', ascending: false);
          break;
        case 'trending':
          query = query.order('trending_score', ascending: false);
          break;
      }

      final response = await query
          .range(_currentPage * _pageSize, (_currentPage + 1) * _pageSize - 1);

      if (currentRequestId != _requestId) {
        debugPrint('⏳ Stale request $currentRequestId ignored');
        return;
      }

      final List<dynamic> data = response;
      final newPosts = data.map((json) => PostModel.fromJson(json)).toList();

      if (refresh) {
        _posts.clear();
        _posts.addAll(newPosts);
      } else {
        // Merge new posts with existing (avoid duplicates)
        final existingIds = _posts.map((p) => p.postId).toSet();
        for (final post in newPosts) {
          if (!existingIds.contains(post.postId)) {
            _posts.add(post);
          } else {
            // Update existing post
            final index = _posts.indexWhere((p) => p.postId == post.postId);
            if (index != -1) {
              _posts[index] = post;
            }
          }
        }
      }

      if (_posts.length > 100) {
        _posts.removeRange(100, _posts.length);
      }

      await _fetchCurrentUserLikes(_posts);
      _hasMore = newPosts.length == _pageSize;
      _currentPage++;
      _postsLoaded = true;

      if (currentRequestId == _requestId) {
        emit(CommunityPostsLoadedState(List.from(_posts)));
      }

      if (!_realtimeInitiated && _posts.isNotEmpty) {
        _initRealtimeSubscriptions();
      }

      _cachePosts(_posts);
    } catch (e) {
      if (currentRequestId != _requestId) {
        debugPrint('⏳ Stale request $currentRequestId error ignored');
        return;
      }

      debugPrint('❌ getPosts error: $e');
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('socketexception') ||
          errorStr.contains('failed host lookup') ||
          errorStr.contains('network is unreachable') ||
          errorStr.contains('connection failed') ||
          errorStr.contains('timeout')) {
        if (_posts.isEmpty && currentRequestId == _requestId) {
          emit(CommunityOfflineState());
        }
      } else {
        if (currentRequestId == _requestId) {
          emit(CommunityErrorState(e.toString()));
        }
      }
    } finally {
      isFetchingMore = false;
    }
  }

  Future<void> _cachePosts(List<PostModel> posts) async {
    try {
      final db = await _historyDb.database;
      await db.delete('cached_posts');
      for (final post in posts) {
        final json = post.toJson();
        await db.insert('cached_posts', {
          'post_id': post.postId,
          'post_data': jsonEncode(json),
          'cached_at': DateTime.now().toIso8601String(),
        });
      }
      debugPrint('✅ Cached ${posts.length} posts');
    } catch (e) {
      debugPrint('❌ Failed to cache posts: $e');
    }
  }

  Future<List<PostModel>> _loadCachedPosts() async {
    try {
      final db = await _historyDb.database;
      final result = await db.query('cached_posts');

      final posts = <PostModel>[];
      for (final row in result) {
        try {
          final json = jsonDecode(row['post_data'] as String);
          final post = PostModel.fromJson(json);
          posts.add(post);
        } catch (e) {
          debugPrint('⚠️ Failed to parse cached post: $e');
          // Skip this post and continue with others
        }
      }

      // ✅ Sort by actual post creation time (newest first)
      posts.sort((a, b) => b.dateTime.compareTo(a.dateTime));

      debugPrint('✅ Loaded ${posts.length} cached posts (sorted by dateTime)');
      return posts;
    } catch (e) {
      debugPrint('❌ Failed to load cached posts: $e');
      return [];
    }
  }

  Future<void> loadMorePosts() async {
    if (isFetchingMore || !_hasMore) return;

    try {
      await getPosts();
    } catch (e) {
      if (_posts.isNotEmpty) {
        final errorStr = e.toString().toLowerCase();
        if (errorStr.contains('socketexception') ||
            errorStr.contains('failed host lookup') ||
            errorStr.contains('network is unreachable')) {
          emit(CommunityErrorState('offline_load_more_error'));
        } else {
          emit(CommunityErrorState(e.toString()));
        }
      }
    }
  }

  // --------------------------------------------------------------------------
  // LIKES
  // --------------------------------------------------------------------------
  Future<void> _fetchCurrentUserLikes(List<PostModel> posts) async {
    final user = CurrentUser.user;
    if (user == null) {
      debugPrint('⚠️ CurrentUser is null, skipping likes fetch');
      return;
    }
    final currentUserId = user.id;
    if (currentUserId.isEmpty) return;

    try {
      final postIds = posts.map((p) => p.postId).toList();
      if (postIds.isEmpty) return;

      final likesResponse = await supabaseService.client
          .from('post_likes')
          .select('post_id')
          .eq('user_id', currentUserId)
          .inFilter('post_id', postIds);

      final likedPostIds = likesResponse.map((like) => like['post_id'] as String).toSet();

      for (int i = 0; i < posts.length; i++) {
        final isLiked = likedPostIds.contains(posts[i].postId);
        if (posts[i].userLiked != isLiked) {
          posts[i] = posts[i].copyWith(userLiked: isLiked);
        }
      }
    } catch (e) {
      debugPrint('❌ Error fetching user likes: $e');
    }
  }

  Future<void> toggleLike(String postId) async {
    final user = CurrentUser.user;
    if (user == null) {
      emit(CommunityErrorState("User not logged in"));
      return;
    }
    final userId = user.id;

    final authService = SupabaseAuthService();
    final hasInternet = await authService.isConnectedFast();
    if (!hasInternet) {
      emit(CommunityErrorState('offline_like'));
      return;
    }

    if (_likesInFlight.contains(postId)) return;
    _likesInFlight.add(postId);

    final index = _posts.indexWhere((post) => post.postId == postId);
    if (index == -1) {
      _likesInFlight.remove(postId);
      return;
    }

    final currentPost = _posts[index];
    final willLike = !currentPost.userLiked;
    final newLikeCount = currentPost.likeCount + (willLike ? 1 : -1);

    final updatedPost = currentPost.copyWith(
      userLiked: willLike,
      likeCount: newLikeCount,
    );
    _posts[index] = updatedPost;

    if (isSearching) {
      final fIndex = filteredPosts.indexWhere((p) => p.postId == postId);
      if (fIndex != -1) filteredPosts[fIndex] = updatedPost;
      emit(CommunitySearchResultsState(filteredPosts));
    } else {
      emit(CommunityPostsLoadedState(_posts));
    }

    try {
      if (willLike) {
        await supabaseService.client
            .from('post_likes')
            .insert({'post_id': postId, 'user_id': userId});
      } else {
        await supabaseService.client
            .from('post_likes')
            .delete()
            .eq('post_id', postId)
            .eq('user_id', userId);
      }
    } catch (e) {
      final rollbackPost = currentPost.copyWith(
        userLiked: !willLike,
        likeCount: currentPost.likeCount,
      );
      _posts[index] = rollbackPost;
      if (isSearching) {
        final fIndex = filteredPosts.indexWhere((p) => p.postId == postId);
        if (fIndex != -1) filteredPosts[fIndex] = rollbackPost;
        emit(CommunitySearchResultsState(filteredPosts));
      } else {
        emit(CommunityPostsLoadedState(_posts));
      }
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('socketexception') ||
          errorStr.contains('failed host lookup') ||
          errorStr.contains('network is unreachable')) {
        emit(CommunityErrorState('offline_like'));
      } else {
        emit(CommunityErrorState(e.toString()));
      }
    } finally {
      _likesInFlight.remove(postId);
    }
  }

  // --------------------------------------------------------------------------
  // COMMENTS
  // --------------------------------------------------------------------------
  Future<void> addComment({
    required String postId,
    required String text,
    required String userId,
    required String userName,
    required String? userImage,
  }) async {
    // ✅ Block comments on pending posts
    if (postId.startsWith('pending_')) {
      emit(CommunityErrorState('comments_not_allowed_on_pending'));
      return;
    }

    final user = CurrentUser.user;
    if (user == null) {
      emit(CommunityErrorState("User not logged in"));
      return;
    }

    final authService = SupabaseAuthService();
    final hasInternet = await authService.isConnectedFast();
    if (!hasInternet) {
      await socialUploadService.addOfflineAction(
        type: 'comment',
        userId: userId,
        data: {
          'post_id': postId,
          'user_id': userId,
          'text': text,
        },
      );
      emit(CommunityErrorState('offline_queued'));
      return;
    }

    final online = await authService.syncUserIfNeeded(userId);
    if (!online) {
      await socialUploadService.addOfflineAction(
        type: 'comment',
        userId: userId,
        data: {
          'post_id': postId,
          'user_id': userId,
          'text': text,
        },
      );
      emit(CommunityErrorState('offline_queued'));
      return;
    }

    // Optimistically increment comment count
    final postIndex = _posts.indexWhere((p) => p.postId == postId);
    if (postIndex != -1) {
      final updatedPost = _posts[postIndex].copyWith(
        commentCount: _posts[postIndex].commentCount + 1,
      );
      _posts[postIndex] = updatedPost;
      if (isSearching) {
        final fIndex = filteredPosts.indexWhere((p) => p.postId == postId);
        if (fIndex != -1) filteredPosts[fIndex] = updatedPost;
        emit(CommunitySearchResultsState(filteredPosts));
      } else {
        emit(CommunityPostsLoadedState(_posts));
      }
    }

    try {
      final commentData = {
        'post_id': postId,
        'user_id': userId,
        'text': text.trim(),
        'created_at': DateTime.now().toIso8601String(),
      };
      final response = await supabaseService.client
          .from('comments')
          .insert(commentData)
          .select();
      if (response.isEmpty) throw Exception('Insert succeeded but no response');
    } catch (e) {
      if (postIndex != -1) {
        final rolledBack = _posts[postIndex].copyWith(
          commentCount: _posts[postIndex].commentCount - 1,
        );
        _posts[postIndex] = rolledBack;
        if (isSearching) {
          final fIndex = filteredPosts.indexWhere((p) => p.postId == postId);
          if (fIndex != -1) filteredPosts[fIndex] = rolledBack;
          emit(CommunitySearchResultsState(filteredPosts));
        } else {
          emit(CommunityPostsLoadedState(_posts));
        }
      }
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('socketexception') ||
          errorStr.contains('failed host lookup') ||
          errorStr.contains('network is unreachable')) {
        emit(CommunityErrorState('offline_comment'));
      } else {
        emit(CommunityErrorState("Failed to post comment: ${e.toString()}"));
      }
      rethrow;
    }
  }

  // --------------------------------------------------------------------------
  // POST CREATION
  // --------------------------------------------------------------------------
  Future<void> createPost({required String text}) async {
    final user = CurrentUser.user;
    if (user == null || user.id.isEmpty) {
      emit(CommunityErrorState("User not authenticated"));
      return;
    }

    if (hasPendingPost) {
      emit(CommunityErrorState('pending_post_exists'));
      return;
    }

    isCreatingPost = true;
    emit(CreatePostLoadingState());

    final pendingId = 'pending_${DateTime.now().millisecondsSinceEpoch}';
    final pendingPost = PostModel(
      postId: pendingId,
      uId: user.id,
      text: text.trim().isEmpty ? null : text.trim(),
      dateTime: DateTime.now(),
      author: user,
      commentCount: 0,
      likeCount: 0,
      userLiked: false,
      postImage: null,
      offlineActionId: null,
    );

    _posts.insert(0, pendingPost);
    emit(CommunityPostsLoadedState(List.from(_posts)));

    final authService = SupabaseAuthService();
    final hasInternet = await authService.isConnectedFast();
    if (!hasInternet) {
      List<String> imagePaths = [];
      for (final file in _postImages) {
        final saved = await ImageStorageHelper.saveImagePermanently(file);
        imagePaths.add(saved.path);
      }

      final actionId = await socialUploadService.addOfflineAction(
        type: 'post',
        userId: user.id,
        data: {
          'user_id': user.id,
          'text': text,
          'images': imagePaths,
          'pending_id': pendingId,
        },
      );

      final index = _posts.indexWhere((p) => p.postId == pendingId);
      if (index != -1) {
        _posts[index] = _posts[index].copyWith(offlineActionId: actionId);
      }

      _postImages.clear();
      emit(CreatePostSuccessState());
      emit(CommunityPostsLoadedState(List.from(_posts)));
      isCreatingPost = false;
      return;
    }

    // Online path
    try {
      List<String> uploadedUrls = [];
      if (_postImages.isNotEmpty) {
        final permanentImages = await Future.wait(
            _postImages.map((f) => ImageStorageHelper.saveImagePermanently(f)));
        uploadedUrls = await _uploadPostImagesFromFiles(permanentImages, pendingId);
      }

      final postResponse = await supabaseService.client
          .from('posts')
          .insert({'user_id': user.id, 'text': text.trim()})
          .select('*, users(*)')
          .single();

      final realPost = PostModel.fromJson(postResponse);

      if (uploadedUrls.isNotEmpty) {
        final imageInserts = uploadedUrls.map((url) => {
          'post_id': realPost.postId,
          'image_url': url,
          'created_at': DateTime.now().toIso8601String(),
        }).toList();
        await supabaseService.client.from('post_images').insert(imageInserts);
      }

      final index = _posts.indexWhere((p) => p.postId == pendingId);
      final finalPost = realPost.copyWith(postImage: uploadedUrls);
      if (index != -1) {
        _posts[index] = finalPost;
      } else {
        _posts.insert(0, finalPost);
      }

      _postImages.clear();
      emit(CreatePostSuccessState());
      emit(CommunityPostsLoadedState(List.from(_posts)));
    } catch (e, stack) {
      debugPrint('❌ Create post error: $e\n$stack');
      _posts.removeWhere((p) => p.postId == pendingId);
      emit(CommunityErrorState(e.toString()));
      emit(CommunityPostsLoadedState(List.from(_posts)));
    } finally {
      isCreatingPost = false;
    }
  }

  Future<List<String>> _uploadPostImagesFromFiles(List<File> images, String tempId) async {
    final bucket = supabaseService.client.storage.from('post-images');
    final futures = images.asMap().entries.map((entry) async {
      final idx = entry.key;
      final file = entry.value;
      final ext = path.extension(file.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${tempId}_$idx$ext';
      final filePath = 'posts/$fileName';
      await bucket.upload(filePath, file);
      return bucket.getPublicUrl(filePath);
    });
    return await Future.wait(futures);
  }

  // --------------------------------------------------------------------------
  // IMAGE PICKING
  // --------------------------------------------------------------------------
  Future<void> pickPostImages() async {
    try {
      if (_postImages.length >= _maxPostImages) return;
      emit(PostImagesLoadingState());
      final pickedFiles = await _picker.pickMultiImage(
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );
      if (pickedFiles.isNotEmpty) {
        final existingPaths = _postImages.map((f) => f.path).toSet();
        final remainingSlots = _maxPostImages - _postImages.length;
        final newFiles = pickedFiles
            .where((f) => existingPaths.add(f.path))
            .take(remainingSlots)
            .map((f) => File(f.path))
            .toList();
        if (newFiles.isNotEmpty) _postImages.addAll(newFiles);
        emit(PostImagesPickedState(_postImages));
      } else {
        emit(PostImagesPickedCancelState());
      }
    } catch (e) {
      debugPrint('❌ Error picking images: $e');
      emit(CommunityErrorState(e.toString()));
    }
  }

  void removePostImage(int index) {
    if (index >= 0 && index < _postImages.length) {
      _postImages.removeAt(index);
      emit(PostImagesPickedState(_postImages));
    }
  }

  void clearPostDraft() {
    _postImages.clear();
    isCreatingPost = false;
    emit(PostImagesPickedState(_postImages));
  }

  // --------------------------------------------------------------------------
  // SEARCH
  // --------------------------------------------------------------------------
  void searchPosts(String query) {
    _searchTimer?.cancel();
    if (query.trim().isEmpty) {
      clearSearch();
      return;
    }
    isSearching = true;
    final lowerQuery = query.trim().toLowerCase();
    _searchTimer = Timer(const Duration(milliseconds: 300), () {
      filteredPosts = _posts
          .where((post) =>
      (post.text?.toLowerCase().contains(lowerQuery) ?? false) ||
          (post.author?.name.toLowerCase().contains(lowerQuery) ?? false))
          .take(50)
          .toList();
      emit(CommunitySearchResultsState(filteredPosts));
    });
  }

  void clearSearch() {
    _searchTimer?.cancel();
    searchController.clear();
    isSearching = false;
    filteredPosts = _posts;
    if (_posts.isNotEmpty) {
      emit(CommunityPostsLoadedState(_posts));
    } else {
      emit(CommunityEmptyState());
    }
  }

  // --------------------------------------------------------------------------
  // DELETE POST
  // --------------------------------------------------------------------------
  Future<void> deletePost(PostModel post) async {
    // ✅ Clean up _likesInFlight
    _likesInFlight.remove(post.postId);

    if (post.postId.startsWith('pending_') && post.offlineActionId != null) {
      _posts.removeWhere((p) => p.postId == post.postId);
      filteredPosts.removeWhere((p) => p.postId == post.postId);
      emit(CommunityPostsLoadedState(List.from(_posts)));

      await socialUploadService.deleteOfflineAction(post.offlineActionId!);
      showToast(
        text: 'Pending post removed.',
        state: ToastStates.success,
      );
      return;
    }

    final authService = SupabaseAuthService();
    final hasInternet = await authService.isConnectedFast();
    if (!hasInternet) {
      emit(CommunityErrorState('offline_delete'));
      return;
    }

    try {
      if (post.postImage != null && post.postImage!.isNotEmpty) {
        final Map<String, List<String>> bucketToPaths = {};
        for (final url in post.postImage!) {
          try {
            final uri = Uri.parse(url);
            final segments = uri.pathSegments;
            final publicIndex = segments.indexOf('public');
            if (publicIndex != -1 && publicIndex + 2 < segments.length) {
              final bucketName = segments[publicIndex + 1];
              final filePath = segments.sublist(publicIndex + 2).join('/');
              bucketToPaths.putIfAbsent(bucketName, () => []).add(filePath);
            }
          } catch (e) {
            debugPrint('⚠️ Error parsing URL: $e');
          }
        }
        for (final entry in bucketToPaths.entries) {
          if (entry.value.isNotEmpty) {
            await supabaseService.client.storage.from(entry.key).remove(entry.value);
          }
        }
      }
      await supabaseService.client.from('posts').delete().eq('id', post.postId);
      _posts.removeWhere((p) => p.postId == post.postId);
      filteredPosts.removeWhere((p) => p.postId == post.postId);
      emit(CommunityPostsLoadedState(List.from(_posts)));
    } catch (e) {
      debugPrint('❌ Delete error: $e');
      emit(CommunityErrorState(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    _searchTimer?.cancel();
    searchController.dispose();
    await Future.wait([
      if (_postsChannel != null) supabaseService.client.removeChannel(_postsChannel!),
      if (_postImagesChannel != null) supabaseService.client.removeChannel(_postImagesChannel!),
      if (_commentsChannel != null) supabaseService.client.removeChannel(_commentsChannel!),
      if (_likesChannel != null) supabaseService.client.removeChannel(_likesChannel!),
    ]);
    super.close();
  }
}