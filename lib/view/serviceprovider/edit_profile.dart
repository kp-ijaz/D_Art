// import 'package:d_art/controller/controller/profileController.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class EditProfilePage extends StatelessWidget {
//   final ProfileController controller = Get.find<ProfileController>();

//   final _formKey = GlobalKey<FormState>();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Edit Profile'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.only(right: 25, left: 25, top: 20),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               GestureDetector(
//                 onTap: () => _pickImage(),
//                 child: Obx(() => CircleAvatar(
//                       radius: 50,
//                       backgroundImage: controller.imagePath.value.isNotEmpty
//                           ? FileImage(File(controller.imagePath.value))
//                           : null,
//                       child: controller.imagePath.value.isEmpty
//                           ? const Icon(Icons.add_a_photo, size: 50)
//                           : null,
//                     )),
//               ),
//               Obx(() {
//                 if (controller.imageError.value.isNotEmpty) {
//                   return Padding(
//                     padding: const EdgeInsets.only(top: 8.0),
//                     child: Text(
//                       controller.imageError.value,
//                       style: const TextStyle(color: Colors.red, fontSize: 12),
//                     ),
//                   );
//                 } else {
//                   return Container();
//                 }
//               }),
//               const SizedBox(height: 20),
//               TextFormField(
//                 initialValue: controller.name.value,
//                 decoration: const InputDecoration(
//                   labelText: 'Name',
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(17))),
//                 ),
//                 onChanged: (value) => controller.name.value = value,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please update your name';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 initialValue: controller.phone.value,
//                 keyboardType: TextInputType.number,
//                 decoration: const InputDecoration(
//                   labelText: 'Phone',
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(17))),
//                 ),
//                 onChanged: (value) => controller.phone.value = value,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please update your phone number';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               GestureDetector(
//                 onTap: () => controller.fetchLocation(),
//                 child: AbsorbPointer(
//                   child: Obx(() {
//                     return TextFormField(
//                       decoration: const InputDecoration(
//                         labelText: 'Enable your location',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(17)),
//                         ),
//                         prefixIcon: Icon(Icons.location_on, color: Colors.red),
//                       ),
//                       validator: (value) {
//                         if (controller.location.value.isEmpty) {
//                           return 'Please update your location';
//                         }
//                         return null;
//                       },
//                       controller: TextEditingController(
//                         text: controller.location.value,
//                       ),
//                     );
//                   }),
//                 ),
//               ),
//               const SizedBox(height: 20),
//               // TextFormField(
//               //   initialValue: controller.experience.value,
//               //   decoration: const InputDecoration(
//               //     labelText: 'Experiance',
//               //     border: OutlineInputBorder(
//               //         borderRadius: BorderRadius.all(Radius.circular(17))),
//               //   ),
//               //   onChanged: (value) => controller.experience.value = value,
//               //   validator: (value) {
//               //     if (value == null || value.isEmpty) {
//               //       return 'Please update your experiance';
//               //     }
//               //     return null;
//               //   },
//               // ),
//               const SizedBox(height: 20),
//               TextFormField(
//                 initialValue: controller.bio.value,
//                 maxLines: 3,
//                 decoration: const InputDecoration(
//                   labelText: 'Bio',
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(17))),
//                 ),
//                 onChanged: (value) => controller.bio.value = value,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please update your bio';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 20),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const SizedBox(),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.amber,
//                     ),
//                     onPressed: () {
//                       if (_formKey.currentState!.validate()) {
//                         if (controller.imagePath.value.isEmpty) {
//                           controller.imageError.value = 'Please update image';
//                         } else {
//                           controller.imageError.value = '';
//                           controller.updateProfile();
//                           Navigator.of(context).pop();
//                         }
//                       }
//                     },
//                     child: const Text('Update'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       controller.imagePath.value = pickedFile.path;
//       controller.imageError.value = '';
//     }
//   }
// }
