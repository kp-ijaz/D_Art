// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserProfile {
//   String id;
//   String name;
//   String bio;
//   String imagePath;
//   String location;
//   String phone;
//   bool isServiceProvider;

//   UserProfile({
//     required this.id,
//     required this.name,
//     required this.bio,
//     required this.imagePath,
//     required this.location,
//     required this.phone,
//     required this.isServiceProvider,
//   });

//   factory UserProfile.fromSnapshot(DocumentSnapshot snapshot) {
//     Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//     return UserProfile(
//       id: snapshot.id,
//       name: data['name'] ?? '',
//       bio: data['bio'] ?? '',
//       imagePath: data['imagePath'] ?? '',
//       location: data['location'] ?? '',
//       phone: data['phone'] ?? '',
//       isServiceProvider: data['isServiceProvider'] ?? false,
//     );
//   }
// }
