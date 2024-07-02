import 'package:d_art/controller/controller/bottomnavbarcontroller.dart';
import 'package:d_art/controller/controller/postselectioncontroller.dart';
import 'package:d_art/view/Homeowner/chatscreen/screen/chatscreen.dart';
import 'package:d_art/view/Homeowner/mediaselection.dart';
import 'package:d_art/view/Homeowner/profilescreen.dart';
import 'package:d_art/view/Homeowner/searchscreen.dart';
import 'package:d_art/view/Homeowner/service_home.dart';
import 'package:d_art/view/drawer/drawer.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavBar extends StatelessWidget {
  final BottomNavBarController controller = Get.put(BottomNavBarController());
  final MediaSelectionController mediacontroller =
      Get.put(MediaSelectionController());

  BottomNavBar({super.key});

  final List<Widget> _screens = [
    ServiceHome(),
    const SearchScreen(),
    MediaDetailsScreen(selectedMedia: const []),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: controller.selectedTab.value == SelectedTab.home
              ? AppBar(
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.notifications,
                        size: 30,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.off(() => const ChatScreen());
                      },
                      icon: const Icon(
                        Icons.near_me_outlined,
                        size: 30,
                      ),
                    ),
                  ],
                )
              : null,
          drawer: controller.selectedTab.value == SelectedTab.home
              ? const MyDrawer()
              : null,
          extendBody: true,
          body: _screens[
              SelectedTab.values.indexOf(controller.selectedTab.value)],
          bottomNavigationBar: SizedBox(
            height: 125,
            child: DotNavigationBar(
              backgroundColor: Colors.grey,
              margin: const EdgeInsets.only(left: 10, right: 10),
              currentIndex:
                  SelectedTab.values.indexOf(controller.selectedTab.value),
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
                    icon: const Icon(Icons.home, size: 23),
                    selectedColor: Colors.purple),
                DotNavigationBarItem(
                    icon: const Icon(Icons.search, size: 23),
                    selectedColor: Colors.purple),
                DotNavigationBarItem(
                    icon: const Icon(Icons.add_a_photo, size: 23),
                    selectedColor: Colors.purple),
                DotNavigationBarItem(
                    icon: const Icon(Icons.person, size: 23),
                    selectedColor: Colors.purple),
              ],
            ),
          ),
        ));
  }
}
