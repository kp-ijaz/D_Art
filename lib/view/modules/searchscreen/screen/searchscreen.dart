import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:d_art/models/post_model.dart';
import 'package:d_art/view/modules/searchscreen/controller/searchcontroller.dart';

class SearchScreen extends StatelessWidget {
  final SearchbarController _searchController = Get.put(SearchbarController());

  SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _searchController.listenToPostChanges();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by user name...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              onChanged: (value) {
                _searchController.searchQuery.value = value;
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_searchController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (_searchController.searchResults.isEmpty) {
                return const Center(child: Text('No results found.'));
              }

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                ),
                itemCount: _searchController.searchResults.length,
                itemBuilder: (context, index) {
                  Post post = _searchController.searchResults[index];
                  return GestureDetector(
                    onTap: () {
                      _showPostDetailsDialog(context, post);
                    },
                    child: GridTile(
                      child: Container(
                        color: Colors.grey[300],
                        child: post.mediaUrls.isNotEmpty
                            ? FadeInImage.assetNetwork(
                                placeholder: 'assets/images/placeholder.png',
                                image: post.mediaUrls[0],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              )
                            : const Icon(Icons.image, color: Colors.grey),
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
  }

  void _showPostDetailsDialog(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Post Details'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (post.mediaUrls.isNotEmpty)
                  Container(
                    width: double.infinity,
                    height: 300,
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/images/placeholder.png',
                      image: post.mediaUrls[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 8),
                Text(
                  post.description,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Posted by: ${post.userName}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Location: ${post.location}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
