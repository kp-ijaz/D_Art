import 'dart:developer';

import 'package:d_art/view/Homeowner/mediaselection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MediaSelectionController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var selectedMedia = <XFile>[].obs;

  Future<void> pickMedia(BuildContext ctx) async {
    try {
      final pickedMedia = await _picker.pickMultiImage();
      selectedMedia.value = pickedMedia;
      navigateToDetailsScreen(ctx);
    } catch (e) {
      log('$e');
    }
  }

  void navigateToDetailsScreen(BuildContext ctx) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MediaDetailsScreen(selectedMedia: selectedMedia),
      ),
    );
  }
}
