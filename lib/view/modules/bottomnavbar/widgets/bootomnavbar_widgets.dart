import 'package:d_art/view/modules/bottomnavbar/controller/bottomnavbarcontroller.dart';
import 'package:d_art/view/modules/addpost_page/controller/postselectioncontroller.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final BottomNavBarController controller = Get.put(BottomNavBarController());
final BottomNavBaruserController usercontroller =
    Get.put(BottomNavBaruserController());
final MediaSelectionController mediacontroller =
    Get.put(MediaSelectionController());

Widget bottomNavBarForUsers(BuildContext context) {
  final BottomNavBaruserController usercontroller = Get.find();

  return DotNavigationBar(
    backgroundColor: Colors.grey,
    marginR: const EdgeInsets.only(left: 17, right: 17, top: 25),
    paddingR: const EdgeInsets.only(top: 7, bottom: 7, left: 3, right: 3),
    currentIndex:
        SelectedTab1.values.indexOf(usercontroller.selectedTabs.value),
    dotIndicatorColor: const Color.fromARGB(255, 160, 241, 8),
    unselectedItemColor: Colors.black,
    splashBorderRadius: 50,
    onTap: (index) {
      usercontroller.changeTab(index);
    },
    items: [
      DotNavigationBarItem(
          icon: const Icon(Icons.home, size: 24), selectedColor: Colors.purple),
      DotNavigationBarItem(
          icon: const Icon(Icons.search, size: 24),
          selectedColor: Colors.purple),
      DotNavigationBarItem(
          icon: const Icon(Icons.receipt_long_rounded, size: 24),
          selectedColor: Colors.purple),
      DotNavigationBarItem(
          icon: const Icon(Icons.person, size: 24),
          selectedColor: Colors.purple),
    ],
  );
}

Widget bottomNavBarForServiceProviders(BuildContext context) {
  final BottomNavBarController controller = Get.find();
  final MediaSelectionController mediacontroller = Get.find();

  return DotNavigationBar(
    backgroundColor: Colors.grey,
    marginR: const EdgeInsets.only(left: 17, right: 17, top: 25),
    paddingR: const EdgeInsets.only(top: 7, bottom: 7, left: 3, right: 3),
    currentIndex: SelectedTab.values.indexOf(controller.selectedTab.value),
    dotIndicatorColor: const Color.fromARGB(255, 160, 241, 8),
    unselectedItemColor: Colors.black,
    splashBorderRadius: 50,
    onTap: (index) {
      if (index == 2) {
        mediacontroller.pickMedia(context);
      } else {
        controller.changeTab(index);
      }
    },
    items: [
      DotNavigationBarItem(
          icon: const Icon(Icons.home, size: 24), selectedColor: Colors.purple),
      DotNavigationBarItem(
          icon: const Icon(Icons.search, size: 24),
          selectedColor: Colors.purple),
      DotNavigationBarItem(
          icon: const Icon(Icons.add_a_photo, size: 24),
          selectedColor: Colors.purple),
      DotNavigationBarItem(
          icon: const Icon(Icons.receipt_long_rounded, size: 24),
          selectedColor: Colors.purple),
      DotNavigationBarItem(
          icon: const Icon(Icons.person, size: 24),
          selectedColor: Colors.purple),
    ],
  );
}
