import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:plantie/modules/Community/cubit/states.dart';

import '../../../models/post/post_model.dart';


class CommunityCubit extends Cubit<CommunityStates> {

  static CommunityCubit get(context) => BlocProvider.of(context);

  CommunityCubit() : super(CommunityInitialState()) {
    _init();
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();
  final List<File> _postImages = [];
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  bool isLoading = false;
  bool isCreatingPost = false;

  void _init() {
    getPosts();
  }

  bool hasMore(){
    return _hasMore;
  }

  final List<PostModel> _posts = [];
  List<PostModel> get posts => _posts;

  List<File> get postImages => _postImages;

  Future<void> getPosts({bool refresh = false}) async {
    try {
      if (refresh) {
        _posts.clear();
        _lastDocument = null;
        _hasMore = true;
      }

      if (!_hasMore || isLoading) return;

      isLoading = true;
      emit(CommunityLoadingState());

      Query query = _firestore.collection('posts')
          .orderBy('dateTime', descending: true)
          .limit(10);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final snapshot = await query.get();
      if (snapshot.docs.isEmpty) {
        _hasMore = false;
        emit(CommunityPostsLoadedState(_posts));
        return;
      }

      _lastDocument = snapshot.docs.last;
      List<PostModel> newPosts = await Future.wait(snapshot.docs.map((doc) async {
        final comments = await doc.reference.collection('comments').get();
        return PostModel.fromJson(doc.data() as Map<String, dynamic>, id: doc.id)
          ..commentCount = comments.size;
      }));

      _posts.addAll(newPosts);
      emit(CommunityPostsLoadedState(_posts));
    } catch (e) {
      emit(CommunityErrorState(e.toString()));
    }finally {
      isLoading = false;
    }
  }

  Future<void> toggleLike(String postId, String userId) async {
    try {
      final postRef = _firestore.collection('posts').doc(postId);
      await _firestore.runTransaction((transaction) async {
        final postDoc = await transaction.get(postRef);
        final List<String> likes = List<String>.from(postDoc['likes'] ?? []);

        if (likes.contains(userId)) {
          likes.remove(userId);
        } else {
          likes.add(userId);
        }

        transaction.update(postRef, {'likes': likes});

        // Update local posts list
        final index = _posts.indexWhere((post) => post.postId == postId);
        if (index != -1) {
          _posts[index] = _posts[index].copyWith(likes: likes);

          // Emit the correct state based on search mode
          if (isSearching) {
            // Update filteredPosts to reflect the like action
            final updatedFilteredPosts = filteredPosts.map((post) {
              return post.postId == postId ? _posts[index] : post;
            }).toList();

            filteredPosts = updatedFilteredPosts;
            emit(CommunitySearchResultsState(filteredPosts));
          } else {
            emit(CommunityPostsLoadedState(_posts));
          }
        }
      });
    } catch (e) {
      emit(CommunityErrorState(e.toString()));
    }
  }

  Future<void> addComment({
    required String postId,
    required String text,
    required String userId,
    required String userName,
    required String? userImage,
  }) async {
    try {
      final commentRef = _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .doc();

      final comment = CommentModel(
        commentId: commentRef.id,
        userId: userId,
        userName: userName,
        userImage: userImage,
        text: text,
        timestamp: DateTime.now(),
      );

      await commentRef.set(comment.toMap());
    } catch (e) {
      emit(CommunityErrorState(e.toString()));
    }
  }

  Future<void> pickPostImages() async {
    try {
      emit(PostImagesLoadingState());
      final pickedFiles = await _picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        _postImages.addAll(pickedFiles.map((file) => File(file.path)).toList());
        emit(PostImagesPickedState(_postImages));
      }
      else{
        emit(PostImagesPickedCancelState());
      }
    } catch (e) {
      emit(CommunityErrorState(e.toString()));
    }
  }

  Future<void> removePostImage(int index) async {
    _postImages.removeAt(index);
    emit(PostImagesPickedState(_postImages));
  }

  Future<void> createPost({
    required String text,
    required String userId,
    required String userName,
    required String? userImage,
  }) async {
    try {
      emit(CreatePostLoadingState());

      List<String> imageUrls = [];

      // Upload images as bytes
      for (var image in _postImages) {
        final bytes = await image.readAsBytes();
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final ref = _storage.ref('posts/${timestamp}_${path.basename(image.path)}');

        await ref.putData(bytes);
        imageUrls.add(await ref.getDownloadURL());
      }

      // Create post
      final postRef = _firestore.collection('posts').doc();
      final post = PostModel(
        postId: postRef.id,
        name: userName,
        uId: userId,
        image: userImage,
        dateTime: DateTime.now(),
        text: text,
        postImage: imageUrls,
        likes: [],
      );

      await postRef.set(post.toMap());

      // Add new post to the top
      _posts.insert(0, post);
      emit(CommunityPostsLoadedState(_posts));

      _postImages.clear();
      emit(CreatePostSuccessState());
    } catch (e) {
      emit(CommunityErrorState("Failed to create post: ${e.toString()}"));
    }
  }

  void loadMorePosts() {
    if (_hasMore) {
      getPosts();
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      emit(CommunityLoadingState());

      // Delete from Firestore
      await _firestore.collection('posts').doc(postId).delete();

      // Remove from local lists
      _posts.removeWhere((post) => post.postId == postId);
      filteredPosts.removeWhere((post) => post.postId == postId);

      // Emit the correct state based on search mode
      if (isSearching) {
        if (filteredPosts.isEmpty) {
          emit(CommunitySearchResultsState([])); // Emit empty results state
        } else {
          emit(CommunitySearchResultsState(filteredPosts));
        }
      } else {
        emit(CommunityPostsLoadedState(_posts));
      }
    } catch (e) {
      emit(CommunityErrorState("Failed to delete post: ${e.toString()}"));
    }
  }




  final TextEditingController searchController = TextEditingController();
  List<PostModel> filteredPosts = [];
  bool isSearching = false;
  Timer? _searchTimer;

  void searchPosts(String query) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 300), () {
      if (query.isEmpty) {
        isSearching = false; // Exit search mode
        filteredPosts = _posts;
      } else {
        isSearching = true; // Enter search mode
        final searchTerms = query.toLowerCase().split(' ');
        filteredPosts = _posts.where((post) {
          final postText = post.text?.toLowerCase() ?? '';
          return searchTerms.any((term) => postText.contains(term));
        }).toList();
      }
      emit(CommunitySearchResultsState(filteredPosts));
    });
  }

  void clearSearch() {
    searchController.clear();
    isSearching = false; // Exit search mode
    filteredPosts = _posts;
    emit(CommunityPostsLoadedState(_posts));
  }
}