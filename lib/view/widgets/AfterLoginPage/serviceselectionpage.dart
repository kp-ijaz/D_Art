// import 'package:d_art/controller/controller/servicecontroller.dart';
// import 'package:d_art/view/widgets/AfterLoginPage/profilecompletion.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class ServiceSelectionPage extends StatelessWidget {
//   final ServiceController controller = Get.put(ServiceController());

//   final List<Map<String, dynamic>> services = [
//     {'name': 'Carpenter', 'icon': Icons.construction},
//     {'name': 'Civil Engineer', 'icon': Icons.apartment},
//     {'name': 'Electric Works', 'icon': Icons.electrical_services},
//     {'name': 'Flooring', 'icon': Icons.layers},
//     {'name': 'Painting', 'icon': Icons.format_paint},
//     {'name': 'Interior Designer', 'icon': Icons.design_services},
//     {'name': 'Architect', 'icon': Icons.architecture},
//     {'name': 'Water Proofing', 'icon': Icons.water_damage},
//     {'name': 'Home Automation', 'icon': Icons.wifi_outlined},
//     {'name': 'Roofing', 'icon': Icons.roofing},
//     {'name': 'Plumber', 'icon': Icons.plumbing},
//     {'name': 'Gardening', 'icon': Icons.grass},
//     {'name': 'Others', 'icon': Icons.add},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         centerTitle: true,
//         title: const Text('What services do you provide?'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: services.length,
//                 itemBuilder: (context, index) {
//                   return GestureDetector(
//                     onTap: () {
//                       controller.selectService(services[index]['name']);
//                     },
//                     child: Obx(() {
//                       bool isSelected = controller.selectedService.value ==
//                           services[index]['name'];
//                       return Container(
//                         margin: const EdgeInsets.symmetric(vertical: 8),
//                         padding: const EdgeInsets.symmetric(
//                             vertical: 16, horizontal: 8),
//                         decoration: BoxDecoration(
//                           color: isSelected ? Colors.blue[100] : Colors.white,
//                           border: Border.all(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(services[index]['icon'], size: 40),
//                             const SizedBox(width: 16),
//                             Text(
//                               services[index]['name'],
//                               style: TextStyle(fontSize: 18),
//                             ),
//                           ],
//                         ),
//                       );
//                     }),
//                   );
//                 },
//               ),
//             ),
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
//                 onPressed: () {
//                   if (controller.selectedService.value.isEmpty) {
//                     Get.snackbar('Error', 'Please select a service',
//                         snackPosition: SnackPosition.BOTTOM);
//                   } else {
//                     Navigator.of(context).pushReplacement(MaterialPageRoute(
//                         builder: (builder) => ProfileCompletionPage(
                             
//                             )));
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
