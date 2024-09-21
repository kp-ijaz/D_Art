import 'package:d_art/models/post_model.dart';

class ServiceProvider {
  final String name;
  final String shopname;
  final String shoplocation;
  final String imageUrl;
  final List<Post> userPosts;

  ServiceProvider({
    required this.name,
    required this.shopname,
    required this.shoplocation,
    required this.imageUrl,
    required this.userPosts,
  });
}
