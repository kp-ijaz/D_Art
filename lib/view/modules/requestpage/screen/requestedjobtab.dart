import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_art/view/modules/chatscreen/screen/insidechatscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RequestedjobtabBar extends StatelessWidget {
  const RequestedjobtabBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('requests')
          .where('serviceProviderId',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No requested jobs.'));
        } else {
          var docs = snapshot.data!.docs;

          List<Future<DocumentSnapshot>> profileFutures = docs.map((doc) {
            var userId = doc['userId'];
            return FirebaseFirestore.instance
                .collection('profiles')
                .doc(userId)
                .get();
          }).toList();

          return FutureBuilder(
            future: Future.wait(profileFutures),
            builder: (context, profilesSnapshot) {
              if (profilesSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!profilesSnapshot.hasData) {
                return const Center(child: Text('Error loading profiles.'));
              } else {
                List<DocumentSnapshot> profileDocs =
                    profilesSnapshot.data as List<DocumentSnapshot>;

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var doc = docs[index];
                    var requestId = doc.id;
                    var requestStatus = doc['status'] ?? 'pending';

                    var profileDoc = profileDocs[index];
                    var requesterData =
                        profileDoc.data() as Map<String, dynamic>?;

                    if (requesterData == null) {
                      return const ListTile(
                        title: Text('Requester details not found.'),
                      );
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: CircleAvatar(
                                backgroundImage: requesterData
                                        .containsKey('imageUrl')
                                    ? NetworkImage(requesterData['imageUrl'])
                                    : null,
                                child: requesterData.containsKey('imageUrl')
                                    ? null
                                    : const Icon(Icons.person),
                              ),
                              title: Text(requesterData.containsKey('name')
                                  ? requesterData['name']
                                  : 'Unknown'),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(requesterData.containsKey('email')
                                      ? requesterData['email']
                                      : 'Unknown Email'),
                                  const Text(
                                    "Requested for a job",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 25, 1, 134)),
                                  ),
                                ],
                              ),
                            ),
                            OverflowBar(
                              children: [
                                if (requestStatus == 'pending') ...[
                                  ElevatedButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('requests')
                                          .doc(requestId)
                                          .update({'status': 'accepted'})
                                          .then((value) {})
                                          .catchError((error) {
                                            log('Failed to accept request: $error');
                                          });
                                    },
                                    child: const Text('Accept'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('requests')
                                          .doc(requestId)
                                          .delete()
                                          .then((value) {})
                                          .catchError((error) {
                                        log('Failed to decline request: $error');
                                      });
                                    },
                                    child: const Text('Decline'),
                                  ),
                                ] else if (requestStatus == 'accepted') ...[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            name: requesterData['name'],
                                            otherUserId: doc['userId'],
                                            profilePicture:
                                                requesterData['imageUrl'] ?? '',
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('Message'),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            },
          );
        }
      },
    );
  }
}
