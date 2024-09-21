import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_art/models/post_model.dart';
import 'package:d_art/models/service_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  var name = ''.obs;
  var phone = ''.obs;
  var location = ''.obs;
  var bio = ''.obs;
  var imagePath = ''.obs;
  var imageError = ''.obs;
  var isLoading = false.obs;
  var isScrolled = false.obs;
  var userPosts = <Post>[].obs;
  var serviceProviders = <ServiceProvider>[].obs;
  var savedPosts = <Post>[].obs;
  var isFollowing = false.obs;
  var followersCount = 0.obs;
  var followingCount = 0.obs;
  var requestsCount = 0.obs;
  String privacyPolicy = "";

  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void onInit() {
    super.onInit();
    var currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      fetchUserPosts(currentUser.uid);
      fetchServiceProviders();
      fetchFollowingCount();
      fetchOwnProfileData();
      fetchPrivacyPolicy();
    } else {
      log('No user is currently signed in.');
    }
  }

  Future<void> fetchServiceProviders() async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('profiles')
          .where('isServiceProvider', isEqualTo: true)
          .get();

      serviceProviders.value = await Future.wait(snapshot.docs.map((doc) async {
        var userId = doc.id;
        var userPosts = await fetchUserPosts(userId);
        return ServiceProvider(
          name: doc['name'],
          shopname: doc['shopName'],
          shoplocation: doc['shoplocation'],
          imageUrl: doc['imageUrl'],
          userPosts: userPosts,
        );
      }).toList());

      log('Fetched service providers: ${serviceProviders.length}');
    } catch (e) {
      log('Error fetching service providers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchPrivacyPolicy() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('app_info')
          .doc('privacy_policy')
          .get();

      if (doc.exists) {
        privacyPolicy =
            doc.data()?['privacyPolicy'] ?? 'No privacy policy available';
        update();
      } else {
        Get.snackbar("translation(Get.context!).privcypolicynotexist", '');
      }
    } catch (e) {
      log('Error fetching privacy policy: $e');
      Get.snackbar("translation(Get.context!).erroronprivacypolicy", '');
    }
  }

  void updateRequestCount() {
    FirebaseFirestore.instance
        .collection('requests')
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .listen((snapshot) {
      requestsCount.value = snapshot.docs.length;
    });
  }

  void updateFollowStatus(bool status) {
    isFollowing.value = status;
  }

  Future<void> followUser(String userId) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(currentUserId)
        .update({
      'following': FieldValue.arrayUnion([userId]),
    });

    await FirebaseFirestore.instance.collection('profiles').doc(userId).update({
      'followers': FieldValue.arrayUnion([currentUserId]),
    });

    isFollowing.value = true;

    fetchFollowingCount();
  }

  Future<void> unfollowUser(String userId) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('profiles')
        .doc(currentUserId)
        .update({
      'following': FieldValue.arrayRemove([userId]),
    });

    await FirebaseFirestore.instance.collection('profiles').doc(userId).update({
      'followers': FieldValue.arrayRemove([currentUserId]),
    });

    isFollowing.value = false;

    fetchFollowingCount();
  }

  Future<void> checkIfFollowing(String userId) async {
    String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    var currentUserDoc = await FirebaseFirestore.instance
        .collection('profiles')
        .doc(currentUserId)
        .get();
    List following = currentUserDoc['following'] ?? [];

    if (following.contains(userId)) {
      isFollowing.value = true;
    } else {
      isFollowing.value = false;
    }
  }

  fetchFollowingCount() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(currentUserId)
          .get();

      List following = userDoc['following'] ?? [];
      followingCount.value = following.length;
      log("${following.length}looooooooooooooooooooooooooooooooooooooooooooooooooooooooo");
      return followersCount.value;
    } catch (e) {
      log("Error fetching following count: $e");
    }
  }

  Future<void> fetchOwnProfileData() async {
    try {
      String currentUserId = FirebaseAuth.instance.currentUser!.uid;
      log("Fetching profile data for user ID: $currentUserId");

      // Fetch the current user's profile document from Firestore
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('profiles')
          .doc(currentUserId)
          .get();

      if (userDoc.exists) {
        log("User document found: ${userDoc.data()}");

        List followers = userDoc['followers'] ?? [];
        List following = userDoc['following'] ?? [];

        log("Followers: ${followers.length}");
        log("Following: ${following.length}");

        // Update the counts
        followersCount.value = followers.length;
        followingCount.value = following.length;
      } else {
        log("User document does not exist.");
      }
    } catch (e) {
      log("Error fetching own profile data: $e");
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
      log('Error fetching saved posts: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<Post>> fetchUserPosts(String userId) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .orderBy('timestamp', descending: true)
          .get();

      List<Post> posts = snapshot.docs.map((doc) {
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

      return posts;
    } catch (e) {
      log('Error fetching user posts: $e');
      return [];
    }
  }

  Future<void> fetchLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    isLoading.value = true;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      isLoading.value = false;
      await _enableLocation();
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        isLoading.value = false;
        _showLocationPermissionDeniedSnackbar();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      isLoading.value = false;
      _showLocationPermissionDeniedForeverSnackbar();
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = placemarks.first;
      location.value =
          '${place.locality}, ${place.administrativeArea}, ${place.country}';
    } catch (e) {
      _showLocationFetchErrorSnackbar();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveProfile() async {
    if (imagePath.value.isEmpty) {
      imageError.value = 'Please select an image';
      return;
    }

    imageError.value = '';
    try {
      isLoading.value = true;

      File file = File(imagePath.value);
      String fileName = file.path.split('/').last;
      Reference storageRef = _storage.ref().child('profiles/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;
        String email = currentUser.email ?? '';
        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(userId)
            .set({
          'name': name.value,
          'phone': phone.value,
          'location': location.value,
          'bio': bio.value,
          'imageUrl': downloadUrl,
          'email': email,
          'profileCompleted': true,
        });

        Get.snackbar('Success', 'Profile created successfully');
      } else {
        log('No user is currently signed in.');
        Get.snackbar('Error', 'No user is currently signed in.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    if (imagePath.value.isEmpty) {
      imageError.value = 'Please select an image';
      return;
    }

    imageError.value = '';
    try {
      isLoading.value = true;

      File file = File(imagePath.value);
      String fileName = file.path.split('/').last;
      Reference storageRef = _storage.ref().child('profiles/$fileName');
      UploadTask uploadTask = storageRef.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        String userId = currentUser.uid;
        String email = currentUser.email ?? '';
        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(userId)
            .update({
          'name': name.value,
          'phone': phone.value,
          'location': location.value,
          'bio': bio.value,
          'imageUrl': downloadUrl,
          'email': email,
          'profileCompleted': true,
        });

        Get.snackbar('Success', 'Profile updated successfully');
      } else {
        log('No user is currently signed in.');
        Get.snackbar('Error', 'No user is currently signed in.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _enableLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }
  }

  void _showLocationPermissionDeniedSnackbar() {
    Get.snackbar(
      'Location Permission Denied',
      'Please grant permission to access your location.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
    );
  }

  void _showLocationPermissionDeniedForeverSnackbar() {
    Get.snackbar(
      'Location Permission Denied Forever',
      'Please enable location permission in app settings.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
    );
  }

  void _showLocationFetchErrorSnackbar() {
    Get.snackbar(
      'Location Fetch Error',
      'Failed to fetch location. Please try again later.',
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
    );
  }

  void updateScrollPosition(ScrollController scrollController) {
    scrollController.addListener(() {
      if (scrollController.position.pixels > 0) {
        isScrolled.value = true;
      } else {
        isScrolled.value = false;
      }
    });
  }
}
