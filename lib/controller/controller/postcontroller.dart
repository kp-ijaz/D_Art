import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostDetailsController extends GetxController {
  var location = ''.obs;
  var workType = ''.obs;
  var clientContact = ''.obs;
  var selectedMedia = <XFile>[].obs;

  var posts = <Post>[].obs;
  final CollectionReference postCollection =
      FirebaseFirestore.instance.collection('posts');

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  void setSelectedMedia(List<XFile> media) {
    selectedMedia.value = media;
  }

  Future<void> postDetails() async {
    Post newPost = Post(
      media: selectedMedia.map((file) => file.path).toList(),
      location: location.value,
      workType: workType.value,
      clientContact: clientContact.value,
    );

    try {
      await postCollection.add({
        'media': newPost.media,
        'location': newPost.location,
        'workType': newPost.workType,
        'clientContact': newPost.clientContact,
        'timestamp': Timestamp.now(),
      });

      // Clear fields after posting
      location.value = '';
      workType.value = '';
      clientContact.value = '';
      selectedMedia.clear();

      // Fetch the latest posts after adding a new post
      fetchPosts();

      Get.back(); // Navigate back after posting
    } catch (e) {
      print('Error adding post: $e');
    }
  }

  void fetchPosts() async {
    QuerySnapshot snapshot =
        await postCollection.orderBy('timestamp', descending: true).get();
    posts.value = snapshot.docs.map((doc) {
      return Post(
        media: List<String>.from(doc['media']),
        location: doc['location'],
        workType: doc['workType'],
        clientContact: doc['clientContact'],
      );
    }).toList();
  }
}

class Post {
  final List<String> media;
  final String location;
  final String workType;
  final String clientContact;

  Post({
    required this.media,
    required this.location,
    required this.workType,
    required this.clientContact,
  });
}
