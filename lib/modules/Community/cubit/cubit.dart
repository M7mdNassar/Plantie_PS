import 'dart:async';
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
import '../../../shared/services/supabase_auth_service.dart';

class CommunityCubit extends Cubit<CommunityStates> {
  static CommunityCubit get(context) => BlocProvider.of(context);

  CommunityCubit() : super(CommunityInitialState()) {
    // Initialize real-time after first load
  }

  final ImagePicker _picker = ImagePicker();
  final List<File> _postImages = [];
  static const int _maxPostImages = 4;
  int _currentPage = 0;
  final int _pageSize = 15;
  bool _hasMore = true;
  bool isFetchingMore = false;
  final Set<String> _likesInFlight = {};
  bool _realtimeSubscribed = false;
  bool _realtimeInitiated = false; // to avoid multiple calls
  RealtimeChannel? _postsChannel;
  RealtimeChannel? _postImagesChannel;
  RealtimeChannel? _commentsChannel;
  RealtimeChannel? _likesChannel;

  bool isLoading = false;
  bool isCreatingPost = false;

  Timer? _searchTimer;
  bool isSearching = false;
  List<PostModel> filteredPosts = [];
  final TextEditingController searchController = TextEditingController();

  String _feedSort = 'latest';
  String get feedSort => _feedSort;

  final List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  List<File> get postImages => _postImages;

  bool hasMore() => _hasMore;

  Future<void> setSortFilter(String sortType) async {
    if (_feedSort == sortType) return;

    // Quick offline check
    final authService = SupabaseAuthService();
    final hasInternet = await authService.isConnectedFast();
    if (!hasInternet) {
      emit(CommunityErrorState('offline_filter'));
      return;
    }

    _feedSort = sortType;
    debugPrint('📊 Feed sort changed to: $sortType');
    _currentPage = 0;
    _hasMore = true;
    await getPosts(refresh: true);
  }

  // --------------------------------------------------------------------------
  // REAL-TIME SUBSCRIPTIONS (call once after first posts load)
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
    )
        .subscribe();

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
    )
        .subscribe();

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
    )
        .subscribe();

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
    )
        .subscribe();
  }

  Future<void> _handleRealtimePost(Map<String, dynamic>? record) async {
    if (record == null) return;
    final postId = record['id']?.toString();
    if (postId == null || postId.isEmpty) return;

    debugPrint('🔔 Real-time post event: $postId');

    // Since we have foreign keys, we can fetch the full post with users and images
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
    // Already handled via real-time, but we can also refresh that specific post
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
        // Preserve userLiked flag from current state
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
  // POST FETCHING WITH SORTING (foreign keys enabled)
  // --------------------------------------------------------------------------
  Future<void> getPosts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
    }
    if (isFetchingMore || (!_hasMore && !refresh)) return;

    try {
      isFetchingMore = true;
      // Only emit "loading more" for pagination (not for refresh)
      if (!refresh && _posts.isNotEmpty) {
        emit(CommunityLoadingMoreState());
      }

      // Build query with sorting
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

      final List<dynamic> data = response;
      final newPosts = data.map((json) => PostModel.fromJson(json)).toList();

      // Replace posts list atomically – UI never sees an empty list
      if (refresh) {
        _posts.clear();
        _posts.addAll(newPosts);
      } else {
        _posts.addAll(newPosts);
      }

      await _fetchCurrentUserLikes(_posts);
      _hasMore = newPosts.length == _pageSize;
      _currentPage++;
      emit(CommunityPostsLoadedState(List.from(_posts)));

      // Start real‑time subscriptions after first successful fetch
      if (!_realtimeInitiated && _posts.isNotEmpty) {
        _initRealtimeSubscriptions();
      }
    } catch (e) {
      debugPrint('❌ getPosts error: $e');
      final errorStr = e.toString().toLowerCase();
      if (errorStr.contains('socketexception') ||
          errorStr.contains('failed host lookup') ||
          errorStr.contains('network is unreachable') ||
          errorStr.contains('connection failed') ||
          errorStr.contains('timeout')) {
        emit(CommunityOfflineState());
      } else {
        emit(CommunityErrorState(e.toString()));
      }
    } finally {
      isFetchingMore = false;
    }
  }

  Future<void> loadMorePosts() async {
    if (isLoading || isFetchingMore || !_hasMore) return;

    try {
      isFetchingMore = true;
      await getPosts(); // getPosts already handles network errors, but we want to avoid changing state to Offline if we already have posts
    } catch (e) {
      // If there are already posts, we don't want to show the full offline screen.
      // Just emit an error that can be shown as a SnackBar.
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
      isFetchingMore = false;
    }
  }

  Future<void> _fetchCurrentUserLikes(List<PostModel> posts) async {
    try {
      final currentUserId = CurrentUser.user.id;
      if (currentUserId.isEmpty) return;
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

  // --------------------------------------------------------------------------
  // LIKE TOGGLE (OPTIMISTIC)
  // --------------------------------------------------------------------------
  Future<void> toggleLike(String postId) async {
    final userId = CurrentUser.user.id;
    if (userId.isEmpty) return;

    // Quick offline check before optimistic update
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
    // Quick offline check
    final authService = SupabaseAuthService();
    final hasInternet = await authService.isConnectedFast();
    if (!hasInternet) {
      emit(CommunityErrorState('offline_comment'));
      return;
    }

    final online = await authService.syncUserIfNeeded(userId);
    if (!online) {
      emit(CommunityErrorState('offline_comment'));
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
      // Rollback optimistic count
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
  // POST CREATION (OPTIMISTIC WITH IMAGE UPLOADS)
  // --------------------------------------------------------------------------
  Future<void> createPost({required String text}) async {
    final user = CurrentUser.user;
    if (user.id.isEmpty) {
      emit(CommunityErrorState("User not authenticated"));
      return;
    }

    // Show loading immediately
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
    );

    _posts.insert(0, pendingPost);
    emit(CommunityPostsLoadedState(List.from(_posts)));

    final authService = SupabaseAuthService();
    final hasInternet = await authService.isConnectedFast();
    if (!hasInternet) {
      // Rollback and show offline dialog
      _posts.removeWhere((p) => p.postId == pendingId);
      emit(CommunityPostsLoadedState(List.from(_posts)));
      emit(CommunityErrorState('offline_post_create'));
      isCreatingPost = false;
      return;
    }

    final online = await authService.syncUserIfNeeded(user.id);
    if (!online) {
      _posts.removeWhere((p) => p.postId == pendingId);
      emit(CommunityPostsLoadedState(List.from(_posts)));
      emit(CommunityErrorState('offline_post_create'));
      isCreatingPost = false;
      return;
    }

    try {
      List<String> uploadedUrls = [];
      if (_postImages.isNotEmpty) {
        uploadedUrls = await _uploadPostImages(pendingId);
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


  Future<List<String>> _uploadPostImages(String tempId) async {
    final bucket = supabaseService.client.storage.from('post-images');
    final futures = _postImages.asMap().entries.map((entry) async {
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
  // IMAGE PICKING & MANAGEMENT
  // --------------------------------------------------------------------------
  Future<void> pickPostImages() async {
    try {
      if (_postImages.length >= _maxPostImages) return;
      emit(PostImagesLoadingState());
      final pickedFiles = await _picker.pickMultiImage();
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
      // Remove from local list
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