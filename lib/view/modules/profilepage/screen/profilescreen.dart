import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_art/view/modules/addpost_page/controller/postcontroller.dart';
import 'package:d_art/view/modules/creatingprofile_page/controller/profile_controller.dart';
import 'package:d_art/models/post_model.dart';
import 'package:d_art/view/modules/editprofile_page/screen/edit_profile.dart';
import 'package:d_art/view/modules/editpost_page/screen/editpost.dart';
import 'package:d_art/view/modules/loginpage/screen/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController profileController = Get.put(ProfileController());
  final PostDetailsController postController =
      Get.find<PostDetailsController>();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    profileController.updateScrollPosition(ScrollController());
    profileController.updateRequestCount();

    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('profiles')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Profile not found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          profileController.name.value = data['name'] ?? '';
          profileController.phone.value = data['phone'] ?? '';
          profileController.location.value = data['location'] ?? '';
          profileController.bio.value = data['bio'] ?? '';
          profileController.imagePath.value = data['imagePath'] ?? '';
          profileController.followersCount.value = (data['followers'] != null)
              ? (data['followers'] as List).length
              : 0;
          profileController.followingCount.value = (data['following'] != null)
              ? (data['following'] as List).length
              : 0;
          String imageUrl = data['imageUrl'] ?? '';
          bool isServiceProvider = data['isServiceProvider'] ?? false;
          log("${profileController.followingCount.value}hhhhhhhhhhhhhhhhhhhhhllllllllllllllllllllloooooooooooooooo");
          log("${profileController.followersCount.value}hiiiiiiiiiiiiiiiiiiiiiiiiiiiihhh");

          return NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 280.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 280,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(30)),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(30)),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/placeholder.png',
                              image: imageUrl.isNotEmpty
                                  ? imageUrl
                                  : 'assets/home_image_2.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          right: 10,
                          child: PopupMenuButton<String>(
                            onSelected: (String result) {
                              if (result == 'Edit Profile') {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditProfilePage(),
                                ));
                              } else if (result == 'Logout') {
                                logout();
                              }
                            },
                            itemBuilder: (BuildContext context) => [
                              const PopupMenuItem<String>(
                                value: 'Edit Profile',
                                child: Text('Edit Profile'),
                              ),
                              const PopupMenuItem<String>(
                                value: 'Logout',
                                child: Text('Logout'),
                              ),
                            ],
                            icon: const Icon(Icons.more_vert,
                                color: Colors.white, size: 30),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Obx(() => Text(
                            profileController.name.value,
                            maxLines: 2,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          )),
                      Obx(() => TextButton.icon(
                            onPressed: () {},
                            label: Text(
                              profileController.location.value,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            icon: const Icon(Icons.location_on),
                          )),
                      Obx(() => Text(profileController.bio.value.trim(),
                          textAlign: TextAlign.center)),
                      const SizedBox(height: 16),
                      isServiceProvider
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Obx(
                                  () => Column(
                                    children: [
                                      Text(
                                        "${profileController.followingCount.value}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Text("Following"),
                                    ],
                                  ),
                                ),
                                Obx(() => Column(
                                      children: [
                                        Text(
                                          "${profileController.followersCount.value}",
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const Text("Followers"),
                                      ],
                                    )),
                                Column(
                                  children: [
                                    Obx(() => Text(
                                        "${postController.userPosts.length}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold))),
                                    const Text("Posts"),
                                  ],
                                ),
                              ],
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Obx(() => Column(
                                      children: [
                                        Text(
                                            "${profileController.followingCount.value}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        const Text("Following"),
                                      ],
                                    )),
                                Obx(() => Column(
                                      children: [
                                        Text(
                                            "${profileController.requestsCount.value}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold)),
                                        const Text("My Requests"),
                                      ],
                                    )),
                              ],
                            ),
                    ],
                  ),
                ),
                Expanded(
                  child: DefaultTabController(
                    length: isServiceProvider ? 3 : 2,
                    child: Column(
                      children: [
                        TabBar(
                          indicatorColor: Colors.amber,
                          tabs: [
                            if (isServiceProvider) const Tab(text: 'Posts'),
                            const Tab(text: 'My Requests'),
                            const Tab(text: 'Saved'),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              if (isServiceProvider)
                                Obx(() {
                                  if (postController.userPosts.isEmpty) {
                                    return const Center(
                                        child: Text('No posts found.'));
                                  }

                                  return GridView.builder(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      childAspectRatio: 1,
                                      crossAxisSpacing: 4,
                                      mainAxisSpacing: 4,
                                    ),
                                    itemCount: postController.userPosts.length,
                                    itemBuilder: (context, index) {
                                      var post =
                                          postController.userPosts[index];
                                      String imageUrl =
                                          post.mediaUrls.isNotEmpty
                                              ? post.mediaUrls[0]
                                              : '';

                                      return GestureDetector(
                                        onTap: () => showImageDetails(
                                            context, post, post.id),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: FadeInImage.assetNetwork(
                                            placeholder:
                                                'assets/images/placeholder.png',
                                            image: imageUrl.isNotEmpty
                                                ? imageUrl
                                                : 'assets/home_image_2.png',
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                              _buildRequestsTab(),
                              buildTabContent(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRequestsTab() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('requests')
          .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text('No requested jobs.'),
          );
        } else {
          var docs = snapshot.data!.docs;
          List<String> serviceProviderIds =
              docs.map((doc) => doc['serviceProviderId'] as String).toList();

          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('profiles')
                .where(FieldPath.documentId, whereIn: serviceProviderIds)
                .get(),
            builder: (context, serviceProviderSnapshot) {
              if (serviceProviderSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (!serviceProviderSnapshot.hasData ||
                  serviceProviderSnapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text('Service provider details not found.'),
                );
              } else {
                Map<String, DocumentSnapshot> serviceProviderMap = {
                  for (var doc in serviceProviderSnapshot.data!.docs)
                    doc.id: doc
                };

                return ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var doc = docs[index];
                    var serviceProviderId = doc['serviceProviderId'];
                    var requestStatus = doc['status'] ?? 'pending';
                    var serviceProviderDoc =
                        serviceProviderMap[serviceProviderId];

                    if (serviceProviderDoc == null) {
                      return const Center(
                        child: Text('Service provider details not found.'),
                      );
                    }

                    var serviceProviderData =
                        serviceProviderDoc.data() as Map<String, dynamic>;
                    var serviceProviderName =
                        serviceProviderData['name'] ?? 'Unknown';
                    var serviceProviderLocation =
                        serviceProviderData['location'] ??
                            'Location not provided';
                    var serviceProviderBio =
                        serviceProviderData['bio'] ?? 'Bio not provided';
                    var serviceProviderImageUrl =
                        serviceProviderData['imageUrl'] ?? '';

                    String buttonText;
                    Color buttonColor;
                    VoidCallback? onPressed;

                    switch (requestStatus) {
                      case 'accepted':
                        buttonText = 'Accepted';
                        buttonColor = Colors.green;
                        onPressed = null;
                        break;
                      case 'declined':
                        buttonText = 'Declined';
                        buttonColor = Colors.red;
                        onPressed = null;
                        break;
                      case 'pending':
                      default:
                        buttonText = 'Pending';
                        buttonColor = Colors.orange;
                        onPressed = () {};
                        break;
                    }

                    return ListTile(
                      title: Text(
                        '$serviceProviderName',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$serviceProviderLocation'),
                          Text('$serviceProviderBio'),
                        ],
                      ),
                      leading: serviceProviderImageUrl.isNotEmpty
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(serviceProviderImageUrl),
                            )
                          : const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                      trailing: ElevatedButton(
                        onPressed: onPressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25.0, vertical: 15.0),
                          minimumSize: const Size(15, 15),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(buttonText),
                            SizedBox(width: Get.width * 0.02),
                            Icon(
                              requestStatus == 'pending'
                                  ? Icons.hourglass_empty
                                  : requestStatus == 'accepted'
                                      ? Icons.check
                                      : Icons.close,
                              size: 16.0,
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

  Widget buildTabContent() {
    postController.fetchSavedPosts();

    return Obx(() {
      if (postController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (postController.savedPosts.isEmpty) {
        return const Center(child: Text('No saved posts available.'));
      } else {
        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: postController.savedPosts.length,
          itemBuilder: (context, index) {
            final post = postController.savedPosts[index];
            return Image.network(
              post.mediaUrls.isNotEmpty
                  ? post.mediaUrls[0]
                  : 'assets/images/placeholder.png',
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return Center(
                    child: Image.asset('assets/images/placeholder.png'),
                  );
                }
              },
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Image.asset('assets/images/placeholder.png'),
                );
              },
            );
          },
        );
      }
    });
  }

  void showImageDetails(BuildContext context, Post post, String postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(post.mediaUrls[0]),
              Text(post.description),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => EditPostPage(postId: postId),
                      ));
                    },
                    child: const Text('Edit'),
                  ),
                  TextButton(
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('posts')
                          .doc(postId)
                          .delete();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Get.offAll(LoginPage());
  }
}
