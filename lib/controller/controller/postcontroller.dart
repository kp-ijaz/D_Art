import 'dart:developer';
import 'dart:io';
import 'package:d_art/view/models/post_model.dart';
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
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  void setSelectedMedia(List<XFile> media) {
    selectedMedia.value = media;
  }

  Future<void> postDetails() async {
    List<String> mediaUrls = await _uploadMedia();

    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(userId)
        .get();

    String userName = userDoc['name'];
    String userImageUrl = userDoc['imageUrl'];

    Post newPost = Post(
      mediaUrls: mediaUrls,
      description: description.value,
      location: location.value,
      workType: workType.value,
      clientContact: clientContact.value,
      userName: userName,
      userImageUrl: userImageUrl,
    );

    try {
      await postCollection.add({
        'media': newPost.mediaUrls,
        'description': newPost.description,
        'location': newPost.location,
        'workType': newPost.workType,
        'clientContact': newPost.clientContact,
        'userName': userName,
        'userImageUrl': userImageUrl,
        'timestamp': Timestamp.now(),
      });

      // Clear the form fields
      description.value = '';
      location.value = '';
      workType.value = '';
      clientContact.value = '';
      selectedMedia.clear();

      // Fetch the updated list of posts
      await fetchPosts();

      Get.back();
    } catch (e) {
      log('Error adding post: $e');
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

  Future<void> fetchPosts() async {
    try {
      QuerySnapshot snapshot =
          await postCollection.orderBy('timestamp', descending: true).get();
      posts.value = snapshot.docs.map((doc) {
        return Post(
          mediaUrls: List<String>.from(doc['media']),
          description: doc['description'],
          location: doc['location'],
          workType: doc['workType'],
          clientContact: doc['clientContact'],
          userName: doc['userName'],
          userImageUrl: doc['userImageUrl'],
        );
      }).toList();
      log('Fetched ${posts.length} posts');
      update();
    } catch (e) {
      log('Error fetching posts: $e');
    }
  }
}
