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

  var posts = <Post>[].obs;
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
  }

  void setSelectedMedia(List<XFile> media) {
    selectedMedia.value = media;
  }

  Future<void> postDetails() async {
    isPosting.value = true;
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
      });

      newPost.id = docRef.id;

      description.value = '';
      location.value = '';
      workType.value = '';
      clientContact.value = '';
      selectedMedia.clear();

      posts.insert(0, newPost);
      userPosts.insert(0, newPost);

      update();

      Get.back();
    } catch (e) {
      log('Error adding post: $e');
    } finally {
      isPosting.value = false;
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
        );
      }).toList();
      log('Fetched all posts ${posts.length} posts');
      isLoading.value = false;
      update();
    });
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
