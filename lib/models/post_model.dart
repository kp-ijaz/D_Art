import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String id;
  List<String> mediaUrls;
  String description;
  String location;
  String workType;
  String clientContact;
  String userName;
  String userImageUrl;
  String userId;
  List<String> likes;
  bool saved;
  int commentCount;

  Post({
    required this.id,
    required this.mediaUrls,
    required this.description,
    required this.location,
    required this.workType,
    required this.clientContact,
    required this.userName,
    required this.userImageUrl,
    required this.userId,
    required this.likes,
    this.saved = false,
    this.commentCount = 0,
  });

  factory Post.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Post(
      id: doc.id,
      mediaUrls: List<String>.from(data['mediaUrls'] ?? []),
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      workType: data['workType'] ?? '',
      clientContact: data['clientContact'] ?? '',
      userName: data['userName'] ?? '',
      userImageUrl: data['userImageUrl'] ?? '',
      userId: data['userId'] ?? '',
      likes: List<String>.from(data['likes'] ?? []),
      saved: data['saved'] ?? false,
      commentCount: data['commentCount'] ?? 0,
    );
  }
}
