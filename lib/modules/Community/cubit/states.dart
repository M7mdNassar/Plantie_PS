import 'dart:io';

import '../../../models/post/post_model.dart';

abstract class CommunityStates {}

class CommunityInitialState extends CommunityStates {}

class CommunityLoadingState extends CommunityStates {}

class CommunityPostsLoadedState extends CommunityStates {
  final List<PostModel> posts;
  CommunityPostsLoadedState(this.posts);
}

class CommunityErrorState extends CommunityStates {
  final String error;
  CommunityErrorState(this.error);
}

class CreatePostLoadingState extends CommunityStates {}

class CreatePostSuccessState extends CommunityStates {}

class PostImagesPickedState extends CommunityStates {
  final List<File> images;
  PostImagesPickedState(this.images);
}

class CommunitySearchResultsState extends CommunityStates{
  final  List<PostModel> results;
  CommunitySearchResultsState(this.results);
}