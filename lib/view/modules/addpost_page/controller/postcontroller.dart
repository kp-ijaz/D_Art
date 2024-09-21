import 'dart:developer';
import 'dart:io';
import 'package:d_art/models/post_model.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostDetailsController extends GetxController {
  var description = ''.obs;
  var location = ''.obs;
  var workType = ''.obs;
  var clientContact = ''.obs;
  var selectedMedia = <XFile>[].obs;
  var savedPosts = <Post>[].obs;
  var posts = <Post>[].obs;
  var userprofileposts = <Post>[].obs;
  var userPosts = <Post>[].obs;
  var isLoading = false.obs;
  var isPosting = false.obs;

  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
    fetchAllPosts();
    fetchUserPosts();
    fetchPosts();
  }

  void setSelectedMedia(List<XFile> media) {
    selectedMedia.value = media;
  }

  Future<void> postDetails() async {
    isLoading.value = true;

    List<String> mediaUrls = await _uploadMedia();

    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .get();

    String userName = userDoc['name'];
    String userImageUrl = userDoc['imageUrl'];

    Post newPost = Post(
      id: '',
      mediaUrls: mediaUrls,
      description: description.value,
      location: location.value,
      workType: workType.value,
      clientContact: clientContact.value,
      userName: userName,
      userImageUrl: userImageUrl,
      userId: userId,
      likes: [],
    );

    try {
      DocumentReference docRef = await postCollection.add({
        'media': newPost.mediaUrls,
        'description': newPost.description,
        'location': newPost.location,
        'workType': newPost.workType,
        'clientContact': newPost.clientContact,
        'userName': userName,
        'userImageUrl': userImageUrl,
        'userId': userId,
        'timestamp': Timestamp.now(),
        'likes': newPost.likes,
      });

      newPost.id = docRef.id;

      description.value = '';
      location.value = '';
      workType.value = '';
      clientContact.value = '';
      selectedMedia.clear();

      posts.insert(0, newPost);
      userPosts.insert(0, newPost);

      Get.back();
    } catch (e) {
      log('Error adding post: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addComment(
      String postId, String commentText, String userId, String userName) async {
    try {
      final comment = {
        'commentText': commentText,
        'userId': userId,
        'userName': userName,
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Add comment to the Firestore under the specific post
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add(comment);

      // Optionally, update comment count
      DocumentReference postRef =
          FirebaseFirestore.instance.collection('posts').doc(postId);
      postRef.update({
        'commentCount': FieldValue.increment(1),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to add comment: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchComments(String postId) async {
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();
  }
  // Future<void> savePost(String postId) async {
  //   try {
  //     String userId = FirebaseAuth.instance.currentUser!.uid;
  //     DocumentReference postRef =
  //         FirebaseFirestore.instance.collection('posts').doc(postId);

  //     Post? post = posts.firstWhereOrNull((p) => p.id == postId);
  //     if (post == null) return;

  //     if (post.saved) {
  //       await postRef.update({
  //         'savedBy': FieldValue.arrayRemove([userId]),
  //       });
  //     } else {
  //       await postRef.update({
  //         'savedBy': FieldValue.arrayUnion([userId]),
  //       });
  //     }

  //     post.saved = !post.saved;
  //     posts.refresh();
  //   } catch (e) {
  //     log('Error saving post: $e');
  //   }
  // }

  Future<void> savePost(String postId) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      DocumentReference userDocRef =
          FirebaseFirestore.instance.collection('profiles').doc(userId);
      DocumentSnapshot userDoc = await userDocRef.get();

      if (userDoc.exists) {
        List<String> savedPosts =
            List<String>.from(userDoc['savedPosts'] ?? []);

        if (savedPosts.contains(postId)) {
          savedPosts.remove(postId);
        } else {
          savedPosts.add(postId);
        }

        await userDocRef.update({
          'savedPosts': savedPosts,
        });
      }
    } catch (e) {
      print('Error saving post: $e');
    }
  }

  Future<void> fetchSavedPosts() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(userId)
          .get();

      if (userDoc.exists && userDoc['savedPosts'] != null) {
        List<String> savedPostIds = List<String>.from(userDoc['savedPosts']);
        if (savedPostIds.isNotEmpty) {
          List<Post> posts = [];
          for (String postId in savedPostIds) {
            DocumentSnapshot postDoc = await FirebaseFirestore.instance
                .collection('posts')
                .doc(postId)
                .get();
            if (postDoc.exists) {
              posts.add(Post(
                id: postDoc.id,
                mediaUrls: List<String>.from(postDoc['media']),
                description: postDoc['description'],
                location: postDoc['location'],
                workType: postDoc['workType'],
                clientContact: postDoc['clientContact'],
                userName: postDoc['userName'],
                userImageUrl: postDoc['userImageUrl'],
                userId: postDoc['userId'],
                likes: List<String>.from(postDoc['likes'] ?? []),
              ));
            }
          }
          savedPosts.assignAll(posts);
        }
      }
    } catch (e) {
      print('Error fetching saved posts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<String>> _uploadMedia() async {
    List<String> mediaUrls = [];
    try {
      for (var mediaFile in selectedMedia) {
        File file = File(mediaFile.path);
        String fileName = mediaFile.name;
        Reference storageRef = _storage.ref().child('posts/$fileName');
        UploadTask uploadTask = storageRef.putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        mediaUrls.add(downloadUrl);
        log('File uploaded successfully: $downloadUrl');
      }
    } catch (e) {
      log('Error uploading media: $e');
    }
    return mediaUrls;
  }

  void toggleLike(String postId) async {
    String userId = FirebaseAuth.instance.currentUser!.uid;

    DocumentReference postRef = postCollection.doc(postId);
    DocumentSnapshot postSnapshot = await postRef.get();

    List<String> likes = List<String>.from(postSnapshot['likes'] ?? []);

    if (likes.contains(userId)) {
      likes.remove(userId);
    } else {
      likes.add(userId);
    }

    await postRef.update({'likes': likes});

    int index = posts.indexWhere((post) => post.id == postId);
    if (index != -1) {
      posts[index].likes = likes;
      update();
    }
  }

  Future<void> fetchPosts() async {
    try {
      isLoading.value = true;

      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('posts').get();
      List<Post> loadedPosts = snapshot.docs.map((doc) {
        // String currentUserId = FirebaseAuth.instance.currentUser!.uid;
        // bool isSaved =
        //     (doc['savedBy'] as List<dynamic>).contains(currentUserId);
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
          // saved: isSaved,
        );
      }).toList();
      posts.value = loadedPosts;
    } catch (e) {
      log('Error fetching posts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void fetchAllPosts() {
    isLoading.value = true;
    postCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      posts.value = snapshot.docs.map((doc) {
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
      log('Fetched all posts ${posts.length} posts');
      isLoading.value = false;
      update();
    });
  }

  Future<void> fetchPostsByUserId(String userId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .get();
    userprofileposts.value = querySnapshot.docs.map((doc) {
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
  }

  void fetchUserPosts() {
    isLoading.value = true;
    String userId = FirebaseAuth.instance.currentUser!.uid;
    postCollection
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      userPosts.value = snapshot.docs.map((doc) {
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
      log('Fetched user posts ${userPosts.length} user posts');
      isLoading.value = false;
      update();
    });
  }

  void deletePost(String postId) async {
    await postCollection.doc(postId).delete();
    fetchUserPosts();
  }

  Future<void> editPost(String postId, Post editedPost) async {
    try {
      await postCollection.doc(postId).update({
        'media': editedPost.mediaUrls,
        'description': editedPost.description,
        'location': editedPost.location,
        'workType': editedPost.workType,
        'clientContact': editedPost.clientContact,
      });

      int index = userPosts.indexWhere((post) => post.id == postId);
      if (index != -1) {
        userPosts[index] = editedPost;
      }

      update();
      Get.back();
    } catch (e) {
      log('Error editing post: $e');
    }
  }
}
