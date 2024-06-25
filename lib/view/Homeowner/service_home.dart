import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:d_art/controller/controller/postcontroller.dart';
import 'package:readmore/readmore.dart';

class ServiceHome extends StatelessWidget {
  final PostDetailsController postController = Get.put(PostDetailsController());

  ServiceHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.menu,
            size: 30,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.notifications,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.near_me_outlined,
              size: 30,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Column(
          children: [
            SizedBox(
              height: 60,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 10),
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                children: const [
                  ChoiceChip(
                    label: Text('Full house'),
                    selected: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    backgroundColor: Colors.amber,
                  ),
                  SizedBox(width: 10),
                  ChoiceChip(
                    label: Text('Bedroom'),
                    selected: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    backgroundColor: Colors.amber,
                  ),
                  SizedBox(width: 10),
                  ChoiceChip(
                    label: Text('Kitchen'),
                    selected: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    backgroundColor: Colors.amber,
                  ),
                  SizedBox(width: 10),
                  ChoiceChip(
                    label: Text('Staircase'),
                    selected: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    backgroundColor: Colors.amber,
                  ),
                  SizedBox(width: 10),
                  ChoiceChip(
                    label: Text('Sit out'),
                    selected: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    backgroundColor: Colors.amber,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                if (postController.posts.isEmpty) {
                  return const Center(child: Text('No posts available.'));
                }

                return ListView.builder(
                  itemCount: postController.posts.length,
                  itemBuilder: (context, index) {
                    final post = postController.posts[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(post.userImageUrl),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  post.userName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.more_vert),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            SizedBox(
                              height: 200,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: post.mediaUrls.length,
                                itemBuilder: (context, mediaIndex) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: Image.network(
                                      post.mediaUrls[mediaIndex],
                                      width: 350,
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.favorite_border),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.mode_comment),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  icon: const Icon(Icons.share),
                                  onPressed: () {},
                                ),
                                const Spacer(),
                                IconButton(
                                  icon: const Icon(Icons.bookmark_border),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${post.location} - ${post.workType}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 5),
                            ReadMoreText(
                              post.description,
                              trimMode: TrimMode.Line,
                              trimLines: 2,
                              trimCollapsedText: 'Read more',
                              trimExpandedText: 'Show less',
                              isCollapsed: ValueNotifier(true),

                              // colorClickableText:
                              //     const Color.fromARGB(255, 247, 0, 0),
                              moreStyle: const TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold),
                              lessStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
