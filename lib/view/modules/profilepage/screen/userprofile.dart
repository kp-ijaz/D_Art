import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_art/models/post_model.dart';
import 'package:d_art/view/modules/addpost_page/controller/postcontroller.dart';
import 'package:d_art/view/modules/creatingprofile_page/controller/profile_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProfilePage extends StatelessWidget {
  final String userId;
  final ProfileController profileController = Get.find<ProfileController>();
  final PostDetailsController postController =
      Get.find<PostDetailsController>();
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

  UserProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    postController.fetchPostsByUserId(userId);
    profileController.updateScrollPosition(ScrollController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('profiles')
              .doc(userId)
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
            bool isServiceProvider = data['isServiceProvider'] ?? false;
            List<dynamic> followers = data['followers'] ?? [];
            List<dynamic> following = data['following'] ?? [];
            bool isFollowing = followers.contains(currentUserId);

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
                            height: 310,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  bottom: Radius.circular(30)),
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                bottom: Radius.circular(30),
                              ),
                              child: imageUrl.isNotEmpty
                                  ? FadeInImage.assetNetwork(
                                      placeholder:
                                          'assets/images/placeholder.png',
                                      image: imageUrl,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      'assets/home_image_2.png',
                                      fit: BoxFit.cover,
                                    ),
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
                        Obx(() => Text(
                              profileController.bio.value.trim(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.normal),
                            )),
                        const SizedBox(height: 26),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(following.length.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const Text("Following"),
                              ],
                            ),
                            Column(
                              children: [
                                Text(followers.length.toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                                const Text("Followers"),
                              ],
                            ),
                            if (isServiceProvider)
                              Column(
                                children: [
                                  Obx(() => Text(
                                        "${postController.userprofileposts.length}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      )),
                                  const Text("Posts"),
                                ],
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Obx(() => ElevatedButton.icon(
                              onPressed: () => toggleFollow(
                                  profileController.isFollowing.value),
                              label: Text(profileController.isFollowing.value
                                  ? 'Unfollow'
                                  : 'Follow'),
                              icon: Icon(profileController.isFollowing.value
                                  ? Icons.remove
                                  : Icons.add),
                            )),
                      ],
                    ),
                  ),
                  const Divider(height: 0),
                  Expanded(
                    child: Obx(() {
                      if (postController.userprofileposts.isEmpty) {
                        return const Center(child: Text('No posts found.'));
                      }

                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                        ),
                        itemCount: postController.userprofileposts.length,
                        itemBuilder: (context, index) {
                          var post = postController.userprofileposts[index];
                          String imageUrl = post.mediaUrls.isNotEmpty
                              ? post.mediaUrls[0]
                              : '';

                          return GestureDetector(
                            onTap: () =>
                                showImageDetails(context, post, post.id),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/placeholder.png',
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
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> toggleFollow(bool isFollowing) async {
    DocumentReference userProfileRef =
        FirebaseFirestore.instance.collection('profiles').doc(userId);
    DocumentReference currentUserProfileRef =
        FirebaseFirestore.instance.collection('profiles').doc(currentUserId);

    if (isFollowing) {
      await userProfileRef.update({
        'followers': FieldValue.arrayRemove([currentUserId])
      });
      await currentUserProfileRef.update({
        'following': FieldValue.arrayRemove([userId])
      });
      profileController.updateFollowStatus(false); // Update follow state
    } else {
      await userProfileRef.update({
        'followers': FieldValue.arrayUnion([currentUserId])
      });
      await currentUserProfileRef.update({
        'following': FieldValue.arrayUnion([userId])
      });
      profileController.updateFollowStatus(true); // Update follow state
    }
    await profileController.fetchFollowingCount();
  }

  void showImageDetails(BuildContext context, Post post, String postId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.network(post.mediaUrls.isNotEmpty
                  ? post.mediaUrls[0]
                  : 'assets/home_image_2.png'),
              const SizedBox(height: 15),
              Text(post.description, textAlign: TextAlign.center),
            ],
          ),
        );
      },
    );
  }
}
