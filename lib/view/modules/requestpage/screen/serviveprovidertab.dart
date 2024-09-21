import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_art/models/post_model.dart';
import 'package:d_art/view/modules/chatscreen/screen/insidechatscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Serviceprovidertab extends StatelessWidget {
  const Serviceprovidertab({
    super.key,
    required this.doc,
    required this.userId,
    required this.hasPosts,
    required this.posts,
  });

  final DocumentSnapshot<Object?> doc;
  final String userId;
  final bool hasPosts;
  final List<Post>? posts;

  @override
  Widget build(BuildContext context) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final String imageUrl =
        data.containsKey('imageUrl') ? data['imageUrl'] : '';
    final String name = data.containsKey('name') ? data['name'] : 'Unknown';
    final String shopName =
        data.containsKey('shopName') ? data['shopName'] : 'Unknown Shop';
    final String shopLocation = data.containsKey('shoplocation')
        ? data['shoplocation']
        : 'Unknown Location';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage:
                      imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
                  child: imageUrl.isEmpty ? const Icon(Icons.person) : null,
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(shopName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(shopLocation),
                  ],
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 10),
            hasPosts
                ? GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: posts!.length > 3 ? 3 : posts!.length,
                    itemBuilder: (context, mediaIndex) {
                      if (mediaIndex == 2 && posts!.length > 3) {
                        return Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              posts![mediaIndex].mediaUrls[0],
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: Image.asset(
                                        'assets/images/placeholder.png'),
                                  );
                                }
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Center(
                                  child: Image.asset(
                                      'assets/images/placeholder.png'),
                                );
                              },
                            ),
                            Container(
                              color: Colors.black54,
                              child: Center(
                                child: Text(
                                  '+${posts!.length - 3} more',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Image.network(
                          posts![mediaIndex].mediaUrls[0],
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return Center(
                                child: Image.asset(
                                    'assets/images/placeholder.png'),
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child:
                                  Image.asset('assets/images/placeholder.png'),
                            );
                          },
                        );
                      }
                    },
                  )
                : const Center(child: Text('No posts found')),
            const SizedBox(height: 10),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .where('userId',
                      isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                  .where('serviceProviderId', isEqualTo: userId)
                  .snapshots(),
              builder: (context, requestSnapshot) {
                if (requestSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (requestSnapshot.hasData &&
                    requestSnapshot.data!.docs.isNotEmpty) {
                  var requestData = requestSnapshot.data!.docs[0].data();
                  var status = requestData['status'];

                  if (status == 'pending') {
                    return ElevatedButton(
                      onPressed: () {
                        var requestId = requestSnapshot.data!.docs[0].id;
                        FirebaseFirestore.instance
                            .collection('requests')
                            .doc(requestId)
                            .delete()
                            .then((value) {})
                            .catchError((error) {
                          log('Failed to remove request: $error');
                        });
                      },
                      child: const Text('Requested (Pending)'),
                    );
                  } else if (status == 'accepted') {
                    return ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              otherUserId: userId,
                              profilePicture: doc['imageUrl'] ?? '',
                              name: doc['name'] ?? '',
                            ),
                          ),
                        );
                      },
                      child: const Text('Message'),
                    );
                  } else if (status == 'declined') {
                    return const Text(
                      'Request Declined',
                      style: TextStyle(color: Colors.red),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                } else {
                  return ElevatedButton(
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('requests')
                          .add({
                        'userId': FirebaseAuth.instance.currentUser!.uid,
                        'serviceProviderId': userId,
                        'status': 'pending',
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    },
                    child: const Text('Request for Job'),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
