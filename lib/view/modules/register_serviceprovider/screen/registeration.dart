import 'dart:io';
import 'package:d_art/view/modules/register_serviceprovider/controller/registrationcontroller.dart';
import 'package:d_art/view/modules/bottomnavbar/screen/bottomnav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class VerificationScreen extends StatelessWidget {
  VerificationScreen({super.key});

  final VerificationController controller = Get.put(VerificationController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () => Get.offAll(() => BottomNavBar()),
              icon: const Icon(Icons.arrow_back_outlined)),
          title: const Text('Register Service Provider'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                _buildTextField(controller.shopNameController,
                    'Name of the Shop', Icons.store),
                const SizedBox(height: 15),
                _buildTextField(controller.locationController,
                    'Location of the Shop', Icons.location_on),
                const SizedBox(height: 15),
                _buildTextField(
                    controller.professionController, 'Profession', Icons.work),
                const SizedBox(height: 15),
                _buildTextField(controller.experienceController,
                    'Years of Experience', Icons.timeline,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                _buildTextField(controller.phoneController, 'Phone Number',
                    Icons.phone_android_outlined,
                    keyboardType: TextInputType.number),
                const SizedBox(height: 20),
                Obx(
                  () => controller.selectedImage.value != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            File(controller.selectedImage.value!.path),
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.person,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    final pickedFile = await controller.picker
                        .pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      controller.selectedImage.value = pickedFile;
                    }
                  },
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Upload Government ID'),
                  style: ElevatedButton.styleFrom(
                    side: const BorderSide(color: Colors.black12),
                    backgroundColor: const Color.fromARGB(255, 251, 250, 252),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: controller.isTermsAccepted.value,
                        onChanged: (bool? value) {
                          controller.isTermsAccepted.value = value ?? false;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        controller.isTermsAccepted.value =
                            !controller.isTermsAccepted.value;
                      },
                      child: const Text(
                        'I agree to the ',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showTermsDialog(context, controller),
                      child: const Text(
                        'terms and conditions',
                        style: TextStyle(
                          decoration: TextDecoration.none,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 50,
                      ),
                      ElevatedButton(
                        onPressed: controller.isTermsAccepted.value
                            ? controller.submitServiceProviderDetails
                            : null,
                        style: ElevatedButton.styleFrom(
                          side: const BorderSide(color: Colors.black12),
                          backgroundColor:
                              const Color.fromARGB(255, 255, 255, 255),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : const Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        labelStyle: const TextStyle(color: Colors.deepPurple),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.deepPurple),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  void _showTermsDialog(
      BuildContext context, VerificationController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Terms and Conditions'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'If we verify you are a fraud, you will be removed from the app and punished accordingly.'),
                SizedBox(height: 10),
                Text(
                    'Please make sure all the provided information is correct and valid.'),
                SizedBox(height: 10),
                Text(
                    'By agreeing to these terms, you acknowledge that any false information may result in penalties.'),
              ],
            ),
          ),
        );
      },
    ).then((_) {
      controller.isTermsRead.value = true;
    });
  }
}
