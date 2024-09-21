import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_art/models/post_model.dart';
import 'package:d_art/view/modules/addpost_page/controller/postcontroller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:timeago/timeago.dart' as timeago;

class CaptionText extends StatelessWidget {
  const CaptionText({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return ReadMoreText(
      post.description,
      trimMode: TrimMode.Line,
      trimLines: 2,
      trimCollapsedText: 'Read more',
      trimExpandedText: 'Show less',
      isCollapsed: ValueNotifier(true),
      moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      lessStyle: const TextStyle(
          fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
    );
  }
}

class SavedBtn extends StatelessWidget {
  const SavedBtn({
    super.key,
    required this.isSaved,
    required this.postController,
    required this.post,
  });

  final bool isSaved;
  final PostDetailsController postController;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isSaved ? Icons.bookmark : Icons.bookmark_border,
        color: isSaved ? Colors.black : null,
      ),
      onPressed: () {
        postController.savePost(post.id);
      },
    );
  }
}

class CommntBtn extends StatelessWidget {
  final Post post;

  const CommntBtn({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.mode_comment),
          onPressed: () {
            showModalBottomSheet(
              useSafeArea: true,
              context: context,
              isScrollControlled: true,
              builder: (context) => CommentSection(postId: post.id),
            );
          },
        ),
        // Text(
        //   "${post.commentCount} Comments",
        //   style: const TextStyle(fontWeight: FontWeight.bold),
        // ),
      ],
    );
  }
}

class CommentSection extends StatefulWidget {
  final String postId;

  const CommentSection({super.key, required this.postId});

  @override
  _CommentSectionState createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  final PostDetailsController postController =
      Get.find<PostDetailsController>();
  List<Map<String, dynamic>> comments = [];

  @override
  void initState() {
    super.initState();
    fetchComments();
  }

  Future<void> fetchComments() async {
    final fetchedComments = await postController.fetchComments(widget.postId);
    setState(() {
      comments = fetchedComments;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 20,
        right: 20,
        top: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Comments",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];

                final timestamp = comment['createdAt'] != null
                    ? (comment['createdAt'] as Timestamp).toDate()
                    : DateTime.now();

                return ListTile(
                  leading: CircleAvatar(
                    child: Text(comment['userName'][0]),
                  ),
                  title: Text(comment['userName']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(comment['commentText']),
                      const SizedBox(height: 4),
                      Text(
                        timeago.format(timestamp),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(bottom: 10, left: 4, right: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: "Add a comment...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (_commentController.text.isNotEmpty) {
                      String userId = FirebaseAuth.instance.currentUser!.uid;

                      DocumentSnapshot userSnapshot = await FirebaseFirestore
                          .instance
                          .collection('profiles')
                          .doc(userId)
                          .get();

                      String userName = userSnapshot['name'] ?? 'Anonymous';

                      await postController.addComment(
                        widget.postId,
                        _commentController.text,
                        userId,
                        userName,
                      );

                      _commentController.clear();
                      fetchComments();
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
    required this.isLiked,
    required this.postController,
    required this.post,
  });

  final bool isLiked;
  final PostDetailsController postController;
  final Post post;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : null,
      ),
      onPressed: () {
        postController.toggleLike(post.id);
      },
    );
  }
}

class PostedImage extends StatelessWidget {
  const PostedImage({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: post.mediaUrls.length,
        itemBuilder: (context, mediaIndex) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              children: [
                Image.asset(
                  'assets/images/placeholder.png',
                  width: 350,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                FadeInImage.assetNetwork(
                  placeholder: 'assets/images/placeholder.png',
                  image: post.mediaUrls[mediaIndex],
                  width: 350,
                  height: 200,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 200),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
