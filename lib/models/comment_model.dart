import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String userId;
  final String userName;
  final String commentText;
  final DateTime timestamp;

  Comment({
    required this.userId,
    required this.userName,
    required this.commentText,
    required this.timestamp,
  });
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'userName': userName,
      'commentText': commentText,
      'createdAt': timestamp,
    };
  }

  static Comment fromJson(Map<String, dynamic> json) {
    return Comment(
      userId: json['userId'],
      userName: json['userName'],
      commentText: json['commentText'],
      timestamp: (json['createdAt'] as Timestamp).toDate(),
    );
  }
}
