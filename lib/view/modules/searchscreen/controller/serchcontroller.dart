// import 'package:d_art/models/post_model.dart';
// import 'package:get/get.dart';

// class SearchbarController extends GetxController {
//   var searchQuery = ''.obs;
//   var selectedPlace = ''.obs;
//   var selectedJob = ''.obs;
//   var isLoading = false.obs;
//   var searchResults = <Post>[].obs;

//   List<String> places = [
//     'All',
//     'New York',
//     'Los Angeles',
//     'Chicago'
//   ]; // Example places
//   List<String> jobs = [
//     'All',
//     'Artist',
//     'Photographer',
//     'Designer'
//   ]; // Example jobs

//   void listenToPostChanges() {
//     // Your logic to listen to post changes (Firebase or API)
//   }

//   void searchPosts() async {
//     isLoading.value = true;
//     // Your search logic including filtering
//     List<Post> filteredResults =
//         []; // Filter posts by searchQuery, selectedPlace, and selectedJob

//     // Apply filters
//     filteredResults = allPosts.where((post) {
//       bool matchesQuery = post.userName.contains(searchQuery.value);
//       bool matchesPlace =
//           selectedPlace.value == 'All' || post.location == selectedPlace.value;
//       bool matchesJob =
//           selectedJob.value == 'All' || post.job == selectedJob.value;

//       return matchesQuery && matchesPlace && matchesJob;
//     }).toList();

//     searchResults.value = filteredResults;
//     isLoading.value = false;
//   }
// }
