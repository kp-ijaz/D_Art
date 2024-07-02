import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_art/controller/controller/postcontroller.dart';
import 'package:d_art/controller/controller/profile_controller.dart';
import 'package:d_art/models/post_model.dart';
import 'package:d_art/view/Homeowner/edit_profile.dart';
import 'package:d_art/view/Homeowner/editpost/editpost.dart';
import 'package:d_art/view/widgets/Loginpage/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:readmore/readmore.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController profileController = Get.find<ProfileController>();
  final PostDetailsController postController =
      Get.find<PostDetailsController>();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    profileController.updateScrollPosition(ScrollController());

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('profiles')
            .doc(FirebaseAuth.instance.currentUser?.uid)
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
          String imageUrl = data['imageUrl'] ?? '';

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 280,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(30),
                        ),
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(30),
                        ),
                        child: imageUrl.isNotEmpty
                            ? Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/home_image_2.png',
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 20,
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
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'Edit Profile',
                            child: Text('Edit Profile'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Logout',
                            child: Text('Logout'),
                          ),
                        ],
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                      ),
                    ),
                  ],
                ),
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
                      Obx(() => Text(
                            profileController.bio.value.trim(),
                            textAlign: TextAlign.center,
                          )),
                      const SizedBox(height: 8),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Column(
                            children: [
                              Text("0",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("Following"),
                            ],
                          ),
                          const Column(
                            children: [
                              Text("0",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("Followers"),
                            ],
                          ),
                          Column(
                            children: [
                              Obx(() => Text(
                                    "${postController.userPosts.length}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  )),
                              const Text("Posts"),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: MediaQuery.of(context).size.height - 500,
                        child: DefaultTabController(
                          length: 3,
                          child: Column(
                            children: [
                              const TabBar(
                                indicatorColor: Colors.amber,
                                tabs: [
                                  Tab(text: 'Posts'),
                                  Tab(text: 'Requests'),
                                  Tab(text: 'Saved'),
                                ],
                              ),
                              Expanded(
                                child: TabBarView(
                                  children: [
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
                                        itemCount:
                                            postController.userPosts.length,
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
                                            child: Image.network(imageUrl,
                                                fit: BoxFit.cover),
                                          );
                                        },
                                      );
                                    }),
                                    const Center(
                                        child: Text('Requests Content')),
                                    const Center(child: Text('Saved Content')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

void showImageDetails(BuildContext context, Post post, String postId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    post.mediaUrls.isNotEmpty ? post.mediaUrls[0] : '',
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(height: 8),
                  ReadMoreText(
                    post.description,
                    trimMode: TrimMode.Line,
                    trimLines: 2,
                    trimCollapsedText: 'Read more',
                    trimExpandedText: 'Show less',
                    isCollapsed: ValueNotifier(true),
                    moreStyle: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                    lessStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text(
                        'Location:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const Icon(
                        Icons.location_on,
                        color: Colors.red,
                      ),
                      Text(
                        post.location,
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            color: Color.fromARGB(255, 38, 0, 255),
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Work Type : ${post.workType}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Client Contact : ${post.clientContact}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.centerRight,
                    child: PopupMenuButton<String>(
                      onSelected: (String result) {
                        if (result == 'Edit') {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  EditPostPage(postId: postId)));
                        } else if (result == 'Delete') {
                          deletePost(postId);
                          Navigator.of(context).pop();
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'Edit',
                          child: Text('Edit'),
                        ),
                        const PopupMenuItem<String>(
                          value: 'Delete',
                          child: Text('Delete'),
                        ),
                      ],
                      icon: const Icon(Icons.more_vert),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

void deletePost(String postId) async {
  await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
  Get.find<PostDetailsController>().fetchUserPosts();
}

Future<void> logout() async {
  try {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => LoginPage());
  } on FirebaseAuthException catch (e) {
    throw e.message!;
  } catch (e) {
    throw 'Unable to logout. Try again.';
  }
}
