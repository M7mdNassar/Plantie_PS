import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String postId;
  final String name;
  final String uId;
  final String? image;
  final DateTime dateTime;
  final String? text;
  final List<String>? postImage;
  final List<String>? likes;
  int commentCount = 0;

  PostModel({
    required this.postId,
    required this.name,
    required this.uId,
    this.image,
    required this.dateTime,
    this.text,
    this.postImage,
    this.likes,
  });

  factory PostModel.fromJson(Map<String, dynamic> json, {required String id}) {
    return PostModel(
      postId: id,
      name: json['name'],
      uId: json['uId'],
      image: json['image'],
      dateTime: (json['dateTime'] as Timestamp).toDate(),
      text: json['text'],
      postImage: List<String>.from(json['postImage'] ?? []),
      likes: List<String>.from(json['likes'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uId': uId,
      'image': image,
      'dateTime': Timestamp.fromDate(dateTime),
      'text': text,
      'postImage': postImage,
      'likes': likes,
    };
  }

  PostModel copyWith({
    String? postId,
    String? name,
    String? uId,
    String? image,
    DateTime? dateTime,
    String? text,
    List<String>? postImage,
    List<String>? likes,
  }) {
    return PostModel(
      postId: postId ?? this.postId,
      name: name ?? this.name,
      uId: uId ?? this.uId,
      image: image ?? this.image,
      dateTime: dateTime ?? this.dateTime,
      text: text ?? this.text,
      postImage: postImage ?? this.postImage,
      likes: likes ?? this.likes,
    );
  }

}


class CommentModel {
  final String commentId;
  final String userId;
  final String userName;
  final String? userImage;
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
    return CommentModel(
      commentId: json['commentId'],
      userId: json['userId'],
      userName: json['userName'],
      userImage: json['userImage'],
      text: json['text'],
      timestamp: (json['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'commentId': commentId,
      'userId': userId,
      'userName': userName,
      'userImage': userImage,
      'text': text,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}