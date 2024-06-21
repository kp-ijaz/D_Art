import 'dart:io';

import 'package:d_art/controller/controller/postcontroller.dart';
import 'package:d_art/view/bottomnav/bottomnav_bar.dart';
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
                return Image.file(
                  File(selectedMedia[index].path),
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
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
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
                          TextFormField(
                            maxLines: 2,
                            decoration: const InputDecoration(
                              labelText:
                                  'Add details to get more views for your post',
                              hintStyle: TextStyle(fontSize: 16),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                            ),
                          ),
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
                            image: FileImage(File(selectedMedia[0].path)),
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Text(
                'Reach more clients by adding location & work',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 16.0),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Location of work',
                  prefixIcon: Icon(Icons.location_on),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  controller.location.value = value;
                },
              ),
              const SizedBox(height: 16.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Type of work',
                  border: OutlineInputBorder(),
                ),
                items: ['Plumbing', 'Electrical', 'Painting']
                    .map((workType) => DropdownMenuItem(
                          value: workType,
                          child: Text(workType),
                        ))
                    .toList(),
                onChanged: (value) {
                  controller.workType.value = value!;
                },
              ),
              const SizedBox(height: 16.0),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Select clients contact',
                  prefixIcon: Icon(Icons.contacts),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  controller.clientContact.value = value;
                },
              ),
              const SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
// Implement the logic to post the media along with additional details
                    controller.postDetails();
                    Get.offAll(() => BottomNavBar());
                  },
                  child: const Text('Post'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
