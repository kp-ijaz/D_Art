import 'package:d_art/view/modules/bottomnavbar/controller/bottomnavbarcontroller.dart';
import 'package:d_art/view/modules/loginpage/controller/logincontroller.dart';
import 'package:d_art/view/modules/addpost_page/controller/postselectioncontroller.dart';
import 'package:d_art/view/modules/chatscreen/screen/chatscreen.dart';
import 'package:d_art/view/modules/addpost_page/screen/mediaselection.dart';
import 'package:d_art/view/modules/profilepage/screen/profilescreen.dart';
import 'package:d_art/view/modules/requestpage/screen/requestpage.dart';
import 'package:d_art/view/modules/searchscreen/screen/searchscreen.dart';
import 'package:d_art/view/modules/homescreen/screen/service_home.dart';
import 'package:d_art/view/modules/bottomnavbar/widgets/bootomnavbar_widgets.dart';
import 'package:d_art/view/modules/drawer/screen/drawer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BottomNavBar extends StatelessWidget {
  final BottomNavBarController controller = Get.put(BottomNavBarController());
  final BottomNavBaruserController usercontroller =
      Get.put(BottomNavBaruserController());
  final MediaSelectionController mediacontroller =
      Get.put(MediaSelectionController());
  final LoginController loginController = Get.find<LoginController>();

  BottomNavBar({super.key});

  List<Widget> getUserScreens() {
    return [
      ServiceHome(),
      SearchScreen(),
      RequestPage(),
      ProfilePage(),
    ];
  }

  List<Widget> getServiceProviderScreens() {
    return [
      ServiceHome(),
      SearchScreen(),
      MediaDetailsScreen(selectedMedia: const []),
      RequestPage(),
      ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => SafeArea(
          child: Scaffold(
            appBar: controller.selectedTab.value == SelectedTab.home &&
                    usercontroller.selectedTabs.value == SelectedTab1.home
                ? AppBar(
                    title: Text("D_ART",
                        style: GoogleFonts.pacifico(
                          textStyle: const TextStyle(
                              fontSize: 25,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.bold),
                        )),
                    centerTitle: true,
                    actions: [
                      IconButton(
                        onPressed: () {
                          Get.to(() => const HomeScreen());
                        },
                        icon: const Icon(
                          Icons.near_me_outlined,
                          size: 30,
                        ),
                      ),
                    ],
                  )
                : null,
            drawer: controller.selectedTab.value == SelectedTab.home &&
                    usercontroller.selectedTabs.value == SelectedTab1.home
                ? MyDrawer()
                : null,
            extendBody: true,
            body: loginController.isServiceProvider.value
                ? Obx(() => getServiceProviderScreens()[
                    SelectedTab.values.indexOf(controller.selectedTab.value)])
                : Obx(() => getUserScreens()[SelectedTab1.values
                    .indexOf(usercontroller.selectedTabs.value)]),
            bottomNavigationBar: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 125,
              child: loginController.isServiceProvider.value
                  ? bottomNavBarForServiceProviders(context)
                  : bottomNavBarForUsers(context),
            ),
          ),
        ));
  }
}
