import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:d_art/view/modules/addpost_page/controller/postcontroller.dart';
import 'package:d_art/view/modules/addpost_page/screen/elevatedbtn.dart';
import 'package:d_art/view/modules/addpost_page/screen/fields.dart';
import 'package:d_art/view/modules/bottomnavbar/screen/bottomnav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MediaDetailsScreen extends StatelessWidget {
  final List<XFile> selectedMedia;
  final PostDetailsController controller = Get.put(PostDetailsController());

  MediaDetailsScreen({super.key, required this.selectedMedia}) {
    controller.setSelectedMedia(selectedMedia);
  }

  void _showSelectedMedia(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            width: double.infinity,
            height: 400,
            child: GridView.builder(
              itemCount: selectedMedia.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: selectedMedia[index].path,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAll(() => BottomNavBar()),
        ),
      ),
      body: Obx(() {
        return controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.grey.shade200,
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Textformfieldfordetails(
                                      controller: controller),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16.0),
                            GestureDetector(
                              onTap: () => _showSelectedMedia(context),
                              child: Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.0),
                                  image: DecorationImage(
                                    image:
                                        FileImage(File(selectedMedia[0].path)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'Add more details',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Reach more clients by adding location & work',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 16.0),
                      Textfieldforlocation(controller: controller),
                      const SizedBox(height: 16.0),
                      Dropdownfortpe_of_work(controller: controller),
                      const SizedBox(height: 16.0),
                      Textfieldforclient_contact(controller: controller),
                      const SizedBox(height: 24.0),
                      Elevatedbtn(controller: controller),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
