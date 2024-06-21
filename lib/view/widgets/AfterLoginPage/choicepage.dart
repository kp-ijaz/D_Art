// import 'package:d_art/controller/controller/choicecontroller.dart';
// import 'package:d_art/view/Home_Owner/homepage.dart';
// // import 'package:d_art/presentation/serviceprovider/serviceHome.dart';
// import 'package:d_art/view/widgets/AfterLoginPage/serviceselectionpage.dart';
// // import 'package:d_art/presentation/serviceprovider/home.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// class ChoicePage extends StatelessWidget {
//   final ChoiceController controller = Get.put(ChoiceController());

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           'Choice Page',
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const SizedBox(height: 20),
//             const Text(
//               'What best describes you',
//               style: TextStyle(fontSize: 24),
//             ),
//             const Spacer(),
//             GestureDetector(
//               onTap: controller.selectHomeOwner,
//               child: Obx(() => AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         width: .5,
//                         color: const Color.fromARGB(166, 172, 146, 69),
//                       ),
//                       color: controller.isHomeOwnerSelected.value
//                           ? Colors.blue[100]
//                           : Colors.white,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         if (controller.isHomeOwnerSelected.value)
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.5),
//                             spreadRadius: 5,
//                             blurRadius: 10,
//                             offset: const Offset(0, 3),
//                           ),
//                       ],
//                     ),
//                     padding: const EdgeInsets.all(60),
//                     child: const Column(
//                       children: [
//                         Icon(Icons.home, size: 40),
//                         SizedBox(height: 10),
//                         Text(
//                           'I\'m a home owner',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ],
//                     ),
//                   )),
//             ),
//             const Spacer(),
//             GestureDetector(
//               onTap: controller.selectServiceProvider,
//               child: Obx(() => AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         width: .5,
//                         color: const Color.fromARGB(166, 172, 146, 69),
//                       ),
//                       color: controller.isServiceProviderSelected.value
//                           ? Colors.blue[100]
//                           : Colors.white,
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         if (controller.isServiceProviderSelected.value)
//                           BoxShadow(
//                             color: Colors.blue.withOpacity(0.5),
//                             spreadRadius: 5,
//                             blurRadius: 10,
//                             offset: const Offset(0, 3),
//                           ),
//                       ],
//                     ),
//                     padding: const EdgeInsets.all(60),
//                     child: const Column(
//                       children: [
//                         Icon(Icons.build, size: 40),
//                         SizedBox(height: 10),
//                         Text(
//                           'I\'m a service provider',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ],
//                     ),
//                   )),
//             ),
//             const Spacer(),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                   minimumSize: const Size(double.infinity, 50),
//                 ),
//                 onPressed: () async {
//                   if (controller.isHomeOwnerSelected.value) {
//                     Navigator.of(context).pushReplacement(
//                         MaterialPageRoute(builder: (builder) => HomwOwner()));
//                   } else if (controller.isServiceProviderSelected.value) {
//                     Navigator.of(context).pushReplacement(MaterialPageRoute(
//                         builder: (builder) => ServiceSelectionPage()));
//                   } else {
//                     Get.snackbar(
//                       'Error',
//                       'Please select an option',
//                       snackPosition: SnackPosition.BOTTOM,
//                     );
//                   }
//                 },
//                 child: const Text(
//                   'Next',
//                   style: TextStyle(fontSize: 16, color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
