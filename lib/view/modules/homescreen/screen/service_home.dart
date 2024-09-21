// import 'package:d_art/view/drawer/drawer.dart';
// import 'package:d_art/models/post_model.dart';
import 'package:d_art/view/modules/homescreen/screen/widgets.dart';
import 'package:d_art/view/modules/profilepage/screen/userprofile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:d_art/view/modules/addpost_page/controller/postcontroller.dart';
// import 'package:readmore/readmore.dart';
import 'package:share_plus/share_plus.dart';

class ServiceHome extends StatelessWidget {
  final PostDetailsController postController = Get.put(PostDetailsController());

  ServiceHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (postController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (postController.posts.isEmpty) {
          return const Center(
            child: Text('No posts available.'),
          );
        } else {
          return ListView.builder(
            itemCount: postController.posts.length,
            itemBuilder: (context, index) {
              final post = postController.posts[index];
              bool isLiked =
                  post.likes.contains(FirebaseAuth.instance.currentUser!.uid);
              bool isSaved = post.saved;
              return Card(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.to(
                                  () => UserProfilePage(userId: post.userId));
                            },
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(post.userImageUrl),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            post.userName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      PostedImage(post: post),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          LikeButton(
                              isLiked: isLiked,
                              postController: postController,
                              post: post),
                          Text(
                            "${post.likes.length} Likes",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          CommntBtn(post: post),
                          // Text(
                          //   "${post.commentCount} ",
                          //   style: const TextStyle(fontWeight: FontWeight.bold),
                          // ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              String imageUrl = post.mediaUrls.isNotEmpty
                                  ? post.mediaUrls[0]
                                  : '';
                              sharePost(post.description, imageUrl);
                            },
                          ),
                          const Spacer(),
                          SavedBtn(
                              isSaved: isSaved,
                              postController: postController,
                              post: post),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        '${post.location} - ${post.workType}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      CaptionText(post: post),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }

  void sharePost(String description, String imageUrl) {
    String content = description;

    if (imageUrl.isNotEmpty) {
      content += '\n$imageUrl';
    }

    Share.share(content, subject: 'Check out this post!');
  }
}
