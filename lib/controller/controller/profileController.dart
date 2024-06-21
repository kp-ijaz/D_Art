import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class ProfileController extends GetxController {
  var name = ''.obs;
  var phone = ''.obs;
  var location = ''.obs;
  var bio = ''.obs;
  var imagePath = ''.obs;
  var imageError = ''.obs;

  var isLoading = false.obs;
  var isScrolled = false.obs;

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
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String email = FirebaseAuth.instance.currentUser!.email ?? '';
      await FirebaseFirestore.instance.collection('profiles').doc(userId).set({
        'name': name.value,
        'phone': phone.value,
        'location': location.value,
        'bio': bio.value,
        'imagePath': imagePath.value,
        'email': email,
        'profileCompleted': true, // Add this line
      });
      isLoading.value = false;
      Get.snackbar('Success', 'Profile created successfully');
    } catch (e) {
      isLoading.value = false;
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
      String userId = FirebaseAuth.instance.currentUser!.uid;
      String email = FirebaseAuth.instance.currentUser!.email ?? '';
      await FirebaseFirestore.instance
          .collection('profiles')
          .doc(userId)
          .update({
        'name': name.value,
        'phone': phone.value,
        'location': location.value,
        'bio': bio.value,
        'imagePath': imagePath.value,
        'email': email,
        'profileCompleted': true, // Add this line
      });
      isLoading.value = false;
      Get.snackbar('Success', 'Profile updated successfully');
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to update profile: $e');
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
