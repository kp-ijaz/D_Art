import 'dart:developer';
import 'dart:io';
import 'package:d_art/view/modules/creatingprofile_page/controller/profile_controller.dart';
import 'package:d_art/view/modules/bottomnavbar/screen/bottomnav_bar.dart';
import 'package:d_art/view/modules/creatingprofile_page/screen/textfields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileCompletionPage extends StatelessWidget {
  final ProfileController controller = Get.put(ProfileController());

  final _formKey = GlobalKey<FormState>();

  ProfileCompletionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(right: 25, left: 25, top: 20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _pickImage(),
                child: Obx(() => CircleAvatar(
                      radius: 50,
                      backgroundImage: controller.imagePath.value.isNotEmpty
                          ? FileImage(File(controller.imagePath.value))
                          : null,
                      child: controller.imagePath.value.isEmpty
                          ? const Icon(Icons.add_a_photo, size: 50)
                          : null,
                    )),
              ),
              Obx(() {
                if (controller.imageError.value.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      controller.imageError.value,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
                  );
                } else {
                  return Container();
                }
              }),
              const SizedBox(height: 20),
              NameTextField(controller: controller),
              const SizedBox(height: 20),
              PhoneTextField(controller: controller),
              const SizedBox(height: 20),
              LocationFetching(controller: controller),
              const SizedBox(height: 20),
              BioTextField(controller: controller),
              const SizedBox(height: 20),
              Obx(() {
                if (controller.isLoading.value) {
                  return const CircularProgressIndicator();
                } else {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (controller.imagePath.value.isEmpty) {
                              controller.imageError.value =
                                  'Please select an image';
                            } else {
                              controller.imageError.value = '';
                              await controller.updateProfile();
                              _showProfile(context);
                              log('it is completed...........');
                            }
                          }
                        },
                        child: const Text('Complete'),
                      ),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      controller.imagePath.value = pickedFile.path;
      controller.imageError.value = '';
    }
  }

  void _showProfile(BuildContext context) {
    log('profile completed');
    Get.offAll(() => BottomNavBar());
    log('profile fully completed');
  }
}
