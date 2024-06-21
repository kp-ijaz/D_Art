// // import 'dart:io';

// import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ServiceHome extends StatelessWidget {
//   const ServiceHome({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {},
//           icon: const Icon(
//             Icons.menu,
//             size: 30,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.notifications,
//               size: 30,
//             ),
//           ),
//           IconButton(
//             onPressed: () {},
//             icon: const Icon(
//               Icons.near_me_outlined,
//               size: 30,
//             ),
//           ),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(left: 10),
//         child: Column(
//           children: [
//             SizedBox(
//               height: 60,
//               child: ListView(
//                 padding: const EdgeInsets.only(bottom: 10),
//                 scrollDirection: Axis.horizontal,
//                 physics: const BouncingScrollPhysics(),
//                 children: const [
//                   ChoiceChip(
//                     label: Text('Full house'),
//                     selected: false,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                     ),
//                     backgroundColor: Colors.amber,
//                   ),
//                   SizedBox(width: 10),
//                   ChoiceChip(
//                     label: Text('Bedroom'),
//                     selected: false,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                     ),
//                     backgroundColor: Colors.amber,
//                   ),
//                   SizedBox(width: 10),
//                   ChoiceChip(
//                     label: Text('Kitchen'),
//                     selected: false,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                     ),
//                     backgroundColor: Colors.amber,
//                   ),
//                   SizedBox(width: 10),
//                   ChoiceChip(
//                     label: Text('Staircase'),
//                     selected: false,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                     ),
//                     backgroundColor: Colors.amber,
//                   ),
//                   SizedBox(width: 10),
//                   ChoiceChip(
//                     label: Text('Sit out'),
//                     selected: false,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(20)),
//                     ),
//                     backgroundColor: Colors.amber,
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream:
//                     FirebaseFirestore.instance.collection('posts').snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   }

//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }

//                   List<DocumentSnapshot> documents = snapshot.data!.docs;
//                   return ListView.builder(
//                     itemCount: documents.length,
//                     itemBuilder: (context, index) {
//                       var post = documents[index];
//                       return Card(
//                         margin: const EdgeInsets.symmetric(
//                             vertical: 10, horizontal: 15),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   const CircleAvatar(
//                                     child: Icon(Icons.person),
//                                   ),
//                                   const SizedBox(width: 10),
//                                   const Text(
//                                     'User Name', // Replace with actual username logic
//                                     style:
//                                         TextStyle(fontWeight: FontWeight.bold),
//                                   ),
//                                   const Spacer(),
//                                   IconButton(
//                                     icon: const Icon(Icons.more_vert),
//                                     onPressed: () {},
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 10),
//                               SizedBox(
//                                 height: 200,
//                                 child: ListView.builder(
//                                   scrollDirection: Axis.horizontal,
//                                   itemCount: post['media'].length,
//                                   itemBuilder: (context, mediaIndex) {
//                                     return Padding(
//                                       padding:
//                                           const EdgeInsets.only(right: 8.0),
//                                       child: Image.network(
//                                         post['media'][mediaIndex],
//                                         width: 200,
//                                         fit: BoxFit.cover,
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
//                               const SizedBox(height: 10),
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     icon: const Icon(Icons.favorite_border),
//                                     onPressed: () {},
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.mode_comment),
//                                     onPressed: () {},
//                                   ),
//                                   IconButton(
//                                     icon: const Icon(Icons.share),
//                                     onPressed: () {},
//                                   ),
//                                   const Spacer(),
//                                   IconButton(
//                                     icon: const Icon(Icons.bookmark_border),
//                                     onPressed: () {},
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 10),
//                               Text(
//                                 '${post['location']} - ${post['workType']}',
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.bold),
//                               ),
//                               const SizedBox(height: 5),
//                               Text(post['clientContact']),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
