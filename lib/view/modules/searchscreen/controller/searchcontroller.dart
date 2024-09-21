import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_art/models/post_model.dart';

class SearchbarController extends GetxController {
  var searchQuery = ''.obs;
  var searchResults = <Post>[].obs;
  var isLoading = false.obs;

  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  @override
  void onInit() {
    super.onInit();
    debounceSearch();
    listenToPostChanges();
  }

  void debounceSearch() {
    searchQuery.listen((query) {
      if (query.isEmpty) {
        listenToPostChanges();
      } else {
        searchPosts(query);
      }
    });
  }

  void listenToPostChanges() {
    postCollection.orderBy('timestamp', descending: true).snapshots().listen(
      (snapshot) {
        searchResults.value = snapshot.docs.map((doc) {
          return Post(
            id: doc.id,
            mediaUrls: List<String>.from(doc['media']),
            description: doc['description'],
            location: doc['location'],
            workType: doc['workType'],
            clientContact: doc['clientContact'],
            userName: doc['userName'],
            userImageUrl: doc['userImageUrl'],
            userId: doc['userId'],
            likes: List<String>.from(doc['likes'] ?? []),
          );
        }).toList();
        isLoading.value = false;
      },
    );
  }

  Future<void> searchPosts(String query) async {
    isLoading.value = true;

    try {
      QuerySnapshot snapshot = await postCollection
          .where('userName', isGreaterThanOrEqualTo: query)
          .where('userName', isLessThanOrEqualTo: '$query\uf8ff')
          .get();

      searchResults.value = snapshot.docs.map((doc) {
        return Post(
          id: doc.id,
          mediaUrls: List<String>.from(doc['media']),
          description: doc['description'],
          location: doc['location'],
          workType: doc['workType'],
          clientContact: doc['clientContact'],
          userName: doc['userName'],
          userImageUrl: doc['userImageUrl'],
          userId: doc['userId'],
          likes: List<String>.from(doc['likes'] ?? []),
        );
      }).toList();
    } catch (e) {
      print('Error searching posts: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
