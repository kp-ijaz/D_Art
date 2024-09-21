import 'package:d_art/view/modules/addpost_page/controller/postcontroller.dart';
import 'package:d_art/view/modules/bottomnavbar/screen/bottomnav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Elevatedbtn extends StatelessWidget {
  const Elevatedbtn({
    super.key,
    required this.controller,
  });

  final PostDetailsController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          controller.postDetails();
          Get.offAll(() => BottomNavBar());
        },
        child: const Text('Post'),
      ),
    );
  }
}
