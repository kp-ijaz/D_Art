import 'package:get/get.dart';

enum SelectedTab { home, search, addPhoto, requests, profile }

enum SelectedTab1 { home, search, requests, profile }

class BottomNavBarController extends GetxController {
  var selectedTab = SelectedTab.home.obs;

  void changeTab(int index) {
    selectedTab.value = SelectedTab.values[index];
  }
}

class BottomNavBaruserController extends GetxController {
  var selectedTabs = SelectedTab1.home.obs;

  void changeTab(int index) {
    selectedTabs.value = SelectedTab1.values[index];
  }
}
