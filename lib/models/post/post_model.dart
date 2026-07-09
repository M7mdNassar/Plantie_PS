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
  final int? offlineActionId;

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
    this.offlineActionId,
  });

  // ---- Safe parsing helpers ----
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return [];
    if (value is List) {
      if (value.isEmpty) return [];
      final first = value.first;
      // If the list contains Maps (e.g., [{"image_url": "..."}]) → extract urls
      if (first is Map) {
        return value.map((e) => e['image_url']?.toString() ?? '').where((s) => s.isNotEmpty).toList();
      }
      // If the list contains Strings → return as is
      if (first is String) {
        return value.map((e) => e as String).toList();
      }
    }
    return [];
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (_) {
        return DateTime.now();
      }
    }
    return DateTime.now();
  }

  // ---- fromJson ----
  factory PostModel.fromJson(Map<String, dynamic> json) {
    UserModel? author;
    if (json['users'] != null) {
      author = UserModel.fromJson(json['users']);
    }

    return PostModel(
      postId: json['id']?.toString() ?? '',
      uId: json['user_id']?.toString() ?? '',
      text: json['text'] as String?,
      dateTime: _parseDateTime(json['created_at']),
      postImage: _parseStringList(json['post_images']),
      author: author,
      commentCount: _parseInt(json['comment_count']),
      likeCount: _parseInt(json['like_count']),
      userLiked: json['userLiked'] ?? false,
      offlineActionId: json['offlineActionId'] != null ? _parseInt(json['offlineActionId']) : null,
    );
  }

  // ---- toJson ----
  Map<String, dynamic> toJson() => {
    'id': postId,
    'user_id': uId,
    'text': text,
    'post_images': postImage,
    'created_at': dateTime.toIso8601String(),
    'comment_count': commentCount,
    'like_count': likeCount,
    'users': author?.toJson(),
    'userLiked': userLiked,
    'offlineActionId': offlineActionId,
  };

  // ---- copyWith ----
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

// ---- CommentModel ----
class CommentModel {
  final String commentId;
  final String userId;
  String userName;
  String? userImage;
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
      commentId: json['id']?.toString() ?? json['commentId']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? json['userId']?.toString() ?? '',
      userName: json['user_name']?.toString() ?? json['userName']?.toString() ?? 'User',
      userImage: json['user_image']?.toString() ?? json['userImage']?.toString(),
      text: json['text']?.toString() ?? '',
      timestamp: rawTs is String ? DateTime.parse(rawTs) : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'text': text,
      'created_at': timestamp.toIso8601String(),
    };
  }
}