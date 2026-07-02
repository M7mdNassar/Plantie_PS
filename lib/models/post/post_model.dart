import '../user/user_model.dart';

class PostModel {
  final String postId;
  final String uId;
  final String? text;
  final List<String>? postImage;
  final DateTime dateTime;
  final UserModel? author;
  int commentCount;
  int likeCount;
  bool userLiked;
  final int? offlineActionId; // field for offline queue ID

  PostModel({
    required this.postId,
    required this.uId,
    this.text,
    this.postImage,
    required this.dateTime,
    this.author,
    this.commentCount = 0,
    this.likeCount = 0,
    this.userLiked = false,
    this.offlineActionId, // ✅ optional
  });

  Map<String, dynamic> toJson() => {
    'id': postId,
    'user_id': uId,
    'text': text,
    'post_images': postImage,
    'created_at': dateTime.toIso8601String(),
    'comment_count': commentCount,
    'like_count': likeCount,
    'users': author?.toJson(),
  };

  factory PostModel.fromJson(Map<String, dynamic> json) {
    UserModel? author;
    if (json['users'] != null) {
      author = UserModel.fromJson(json['users']);
    }

    return PostModel(
      postId: json['id'] as String,
      uId: json['user_id'] as String,
      text: json['text'] as String?,
      dateTime: DateTime.parse(json['created_at'] as String),
      postImage: (json['post_images'] as List<dynamic>?)
          ?.map((e) => e['image_url'] as String)
          .toList() ??
          [],
      author: author,
      commentCount: (json['comment_count'] ?? 0) as int,
      likeCount: (json['like_count'] ?? 0) as int,
      userLiked: false,
    );
  }

  PostModel copyWith({
    String? postId,
    String? uId,
    String? text,
    List<String>? postImage,
    DateTime? dateTime,
    UserModel? author,
    int? commentCount,
    int? likeCount,
    bool? userLiked,
    int? offlineActionId,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      uId: uId ?? this.uId,
      text: text ?? this.text,
      postImage: postImage ?? this.postImage,
      dateTime: dateTime ?? this.dateTime,
      author: author ?? this.author,
      commentCount: commentCount ?? this.commentCount,
      likeCount: likeCount ?? this.likeCount,
      userLiked: userLiked ?? this.userLiked,
      offlineActionId: offlineActionId ?? this.offlineActionId,
    );
  }
}


class CommentModel {
  final String commentId;
  final String userId;
  String userName; // Fetched from users table
  String? userImage; // Fetched from users table
  final String text;
  final DateTime timestamp;

  CommentModel({
    required this.commentId,
    required this.userId,
    required this.userName,
    this.userImage,
    required this.text,
    required this.timestamp,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final rawTs = json['created_at'] ?? json['timestamp'];
    return CommentModel(
      // Supabase uses `id` as primary key; keep compatibility with `commentId`.
      commentId: (json['id'] ?? json['commentId'] ?? '') as String,
      // Supabase uses snake_case.
      userId: (json['user_id'] ?? json['userId']) as String,
      // userName and userImage are fetched from users table separately
      userName: (json['user_name'] ?? json['userName'] ?? 'User') as String,
      userImage: json['user_image'] ?? json['userImage'],
      text: json['text'],
      timestamp: rawTs is String ? DateTime.parse(rawTs) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // Only send columns that exist in comments table
      'user_id': userId,
      'text': text,
      'created_at': timestamp.toIso8601String(),
    };
  }
}
