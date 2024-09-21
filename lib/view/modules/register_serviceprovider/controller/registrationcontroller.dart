import 'dart:io';
import 'package:d_art/view/modules/creatingprofile_page/controller/profile_controller.dart';
// import 'package:d_art/view/bottomnav/bottomnav_bar.dart';
import 'package:d_art/view/modules/loginpage/screen/loginpage.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerificationController extends GetxController {
  final TextEditingController shopNameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController experienceController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final ImagePicker picker = ImagePicker();
  Rx<XFile?> selectedImage = Rx<XFile?>(null);
  RxBool isTermsAccepted = false.obs;
  RxBool isTermsRead = false.obs;
  RxBool isLoading = false.obs;

  final ProfileController profileController = Get.put(ProfileController());

  Future<void> submitServiceProviderDetails() async {
    if (validateFields()) {
      isLoading.value = true;

      try {
        File file = File(selectedImage.value!.path);
        String fileName = file.path.split('/').last;
        String userId = FirebaseAuth.instance.currentUser!.uid;
        Reference storageRef =
            FirebaseStorage.instance.ref().child('service_providers/$fileName');
        UploadTask uploadTask = storageRef.putFile(file);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('profiles')
            .doc(userId)
            .set({
          'shopName': shopNameController.text,
          'shoplocation': locationController.text,
          'profession': professionController.text,
          'experience': experienceController.text,
          'phone': phoneController.text,
          'aadharimageUrl': downloadUrl,
          'isServiceProvider': true,
        }, SetOptions(merge: true));

        await profileController.fetchServiceProviders();

        isLoading.value = false;

        Get.dialog(
          AlertDialog(
            title: const Text('Registration Successful'),
            content:
                const Text('You need to logout from the app and re-login.'),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();

                  Get.offAll(() => LoginPage());
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        Get.snackbar('Error', 'Failed to create profile: $e');
        isLoading.value = false;
      }
    }
  }

  bool validateFields() {
    if (shopNameController.text.isEmpty ||
        locationController.text.isEmpty ||
        professionController.text.isEmpty ||
        experienceController.text.isEmpty ||
        phoneController.text.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return false;
    }

    if (selectedImage.value == null) {
      Get.snackbar('Error', 'Please select an image');
      return false;
    }

    if (!isTermsAccepted.value) {
      Get.snackbar('Error', 'You must accept the terms and conditions');
      return false;
    }

    return true;
  }
}
