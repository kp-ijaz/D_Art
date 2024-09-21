import 'package:flutter/material.dart';

class EditPostPage extends StatelessWidget {
  final String postId;
  const EditPostPage({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Post')),
      body: Center(
        child: Text('Edit Post Page for $postId'),
      ),
    );
  }
}
