// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:d_art/models/post_model.dart';
// import 'package:d_art/models/userprofile_model.dart';
// import 'package:get/get.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';

// class UserProfileController extends GetxController {
//   var isLoading = true.obs;
//   var userProfile = Rxn<UserProfile>();
//   var userPosts = <Post>[].obs;

//   Future<void> fetchUserProfile(String userId) async {
//     try {
//       isLoading.value = true;

//       // Fetch user profile data
//       DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .get();
//       userProfile.value = UserProfile.fromSnapshot(userSnapshot);

//       // Fetch user's posts
//       QuerySnapshot postSnapshot = await FirebaseFirestore.instance
//           .collection('posts')
//           .where('userId', isEqualTo: userId)
//           .get();
//       userPosts.value = postSnapshot.docs.map((doc) {
//         return Post(
//           id: doc.id,
//           mediaUrls: List<String>.from(doc['media']),
//           description: doc['description'],
//           location: doc['location'],
//           workType: doc['workType'],
//           clientContact: doc['clientContact'],
//           userName: doc['userName'],
//           userImageUrl: doc['userImageUrl'],
//           userId: doc['userId'],
//           likes: List<String>.from(doc['likes'] ?? []),
//         );
//       }).toList();
//     } catch (e) {
//       log('Error fetching user profile: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
