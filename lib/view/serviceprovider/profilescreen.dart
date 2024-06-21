import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_art/controller/controller/profileController.dart';
import 'package:d_art/view/serviceprovider/edit_profile.dart';
import 'package:d_art/view/widgets/Loginpage/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';

class ProfilePage extends StatelessWidget {
  final ProfileController controller = Get.find<ProfileController>();

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    controller.updateScrollPosition(scrollController);

    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection('profiles')
            .doc(FirebaseAuth
                .instance.currentUser?.uid) // Using UID instead of email
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Profile not found'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          controller.name.value = data['name'] ?? '';
          controller.phone.value = data['phone'] ?? '';
          controller.location.value = data['location'] ?? '';
          controller.bio.value = data['bio'] ?? '';
          controller.imagePath.value = data['imagePath'] ?? '';

          return Obx(() => CustomScrollView(
                controller: scrollController,
                slivers: [
                  SliverAppBar(
                    expandedHeight: 300.0,
                    pinned: true,
                    actions: [
                      PopupMenuButton<String>(
                        onSelected: (String result) {
                          if (result == 'Edit Profile') {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditProfilePage(),
                            ));
                          }
                          if (result == 'Logout') {
                            logout();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => Loginpage()),
                              (Route<dynamic> route) => false,
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem<String>(
                            value: 'Edit Profile',
                            child: Text('Edit Profile'),
                          ),
                          const PopupMenuItem<String>(
                            value: 'Logout',
                            child: Text('Logout'),
                          ),
                        ],
                      ),
                    ],
                    flexibleSpace: FlexibleSpaceBar(
                      title: controller.isScrolled.value
                          ? Text(controller.name.value)
                          : const Text(""),
                      background: controller.imagePath.value.isNotEmpty
                          ? Image.file(
                              File(controller.imagePath.value),
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/profile-image.jpg',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30)),
                            color: Colors.white),
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            if (!controller.isScrolled.value) ...[
                              Text(
                                controller.name.value,
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              TextButton.icon(
                                onPressed: () {},
                                label: Text(
                                  controller.location.value,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                                icon: const Icon(Icons.location_on),
                              ),
                              Text(
                                controller.bio.value.trim(),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {},
                                style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.blue)),
                                child: TextButton.icon(
                                  onPressed: () {},
                                  label: const Text(
                                    "Follow",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  icon: const Icon(Icons.person_add_alt_1),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text("0",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("Following"),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text("0",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("Followers"),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text("8",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text("Posts"),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 60,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  children: const [
                                    ChoiceChip(
                                      label: Text('Posts'),
                                      selected: true,
                                      showCheckmark: false,
                                      selectedColor: Colors.amber,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      backgroundColor: Colors.amber,
                                    ),
                                    SizedBox(width: 63),
                                    ChoiceChip(
                                      label: Text('Requests'),
                                      selected: false,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      backgroundColor: Colors.amber,
                                    ),
                                    SizedBox(width: 63),
                                    ChoiceChip(
                                      label: Text('Chart'),
                                      selected: false,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      backgroundColor: Colors.amber,
                                    ),
                                    SizedBox(width: 10),
                                  ],
                                ),
                              ),
                            ],
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8),
                              itemCount: 8, // Adjust the item count as needed
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.grey[300],
                                    image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                        'assets/splashscreen.gif',
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ]),
                  ),
                ],
              ));
        },
      ),
    );
  }
}

Future<void> logout() async {
  try {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Get.offAll(() => Loginpage());
  } on FirebaseAuthException catch (e) {
    throw e.message!;
  } catch (e) {
    throw 'Unable to logout. Try again.';
  }
}
