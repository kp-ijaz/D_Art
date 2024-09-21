import 'package:d_art/view/modules/creatingprofile_page/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

class PrivacyPolicyView extends StatelessWidget {
  const PrivacyPolicyView({super.key});
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProfileController>();

    controller.fetchPrivacyPolicy();

    return Scaffold(
      appBar: AppBar(
        title: const Text('privacypolicy'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GetBuilder<ProfileController>(
          builder: (controller) {
            if (controller.privacyPolicy.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: HtmlWidget(
                controller.privacyPolicy,
              ),
            );
          },
        ),
      ),
    );
  }
}
