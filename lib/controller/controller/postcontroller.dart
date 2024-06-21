import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PostDetailsController extends GetxController {
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

    Post newPost = Post(
      mediaUrls: mediaUrls,
      location: location.value,
      workType: workType.value,
      clientContact: clientContact.value,
    );

    try {
      await postCollection.add({
        'media': newPost.mediaUrls,
        'location': newPost.location,
        'workType': newPost.workType,
        'clientContact': newPost.clientContact,
        'timestamp': Timestamp.now(),
      });

      location.value = '';
      workType.value = '';
      clientContact.value = '';
      selectedMedia.clear();

      fetchPosts();

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

  void fetchPosts() async {
    try {
      QuerySnapshot snapshot =
          await postCollection.orderBy('timestamp', descending: true).get();
      posts.value = snapshot.docs.map((doc) {
        return Post(
          mediaUrls: List<String>.from(doc['media']),
          location: doc['location'],
          workType: doc['workType'],
          clientContact: doc['clientContact'],
        );
      }).toList();
    } catch (e) {
      log('Error fetching posts: $e');
    }
  }
}

class Post {
  final List<String> mediaUrls;
  final String location;
  final String workType;
  final String clientContact;

  Post({
    required this.mediaUrls,
    required this.location,
    required this.workType,
    required this.clientContact,
  });
}
