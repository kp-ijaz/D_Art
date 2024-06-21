import 'dart:developer';
import 'dart:io';

import 'package:d_art/controller/controller/profileController.dart';
import 'package:d_art/view/bottomnav/bottomnav_bar.dart';
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
        title: const Text('Complete your Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
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
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(17))),
                ),
                onChanged: (value) => controller.name.value = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(17))),
                ),
                onChanged: (value) => controller.phone.value = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () => controller.fetchLocation(),
                child: AbsorbPointer(
                  child: Obx(() {
                    return TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Enable your location',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(17)),
                        ),
                        prefixIcon: Icon(Icons.location_on, color: Colors.red),
                      ),
                      validator: (value) {
                        if (controller.location.value.isEmpty) {
                          return 'Please enable your location';
                        }
                        return null;
                      },
                      controller: TextEditingController(
                        text: controller.location.value,
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Bio',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(17))),
                ),
                onChanged: (value) => controller.bio.value = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your bio';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
// TextFormField(
// decoration: const InputDecoration(
// labelText: 'Job',
// border: OutlineInputBorder(
// borderRadius: BorderRadius.all(Radius.circular(17))),
// ),
// readOnly: true,
// controller: TextEditingController(
// text: controller.job.value,
// ),
// onTap: () {
// // Navigator.of(context).push(MaterialPageRoute(
// // builder: (context) => ServiceSelectionPage()));
// },
// ),
// const SizedBox(height: 20),
// TextFormField(
// keyboardType: TextInputType.number,
// decoration: const InputDecoration(
// labelText: 'Experience',
// border: OutlineInputBorder(
// borderRadius: BorderRadius.all(Radius.circular(17))),
// ),
// onChanged: (value) => controller.experience.value = value,
// validator: (value) {
// if (value == null || value.isEmpty) {
// return 'Please enter your experience';
// }
// return null;
// },
// ),
              const SizedBox(height: 20),
              controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : Row(
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
                                await controller.saveProfile();
                                _showProfile(context);
                                log('it is completed...........');
                              }
                            }
                          },
                          child: const Text('Complete'),
                        ),
                      ],
                    ),
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
