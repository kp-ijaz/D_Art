import 'package:get/get.dart';

enum SelectedTab { home, search, add, person }

class BottomNavBarController extends GetxController {
  var selectedTab = SelectedTab.home.obs;

  void changeTab(int index) {
    selectedTab.value = SelectedTab.values[index];
  }
}
