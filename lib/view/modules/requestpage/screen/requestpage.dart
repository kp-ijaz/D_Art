import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:d_art/view/modules/chatscreen/screen/insidechatscreen.dart';
import 'package:d_art/view/modules/creatingprofile_page/controller/profile_controller.dart';
import 'package:d_art/view/modules/requestpage/screen/requestedjobtab.dart';
import 'package:d_art/view/modules/requestpage/screen/serviveprovidertab.dart';
// import 'package:d_art/models/post_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RequestPage extends StatelessWidget {
  final ProfileController profileController = Get.find<ProfileController>();

  RequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('profiles')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text('User data not found.')),
          );
        }

        var data = snapshot.data!.data() as Map<String, dynamic>?;

        bool isServiceProvider = data?['isServiceProvider'] ?? false;

        return DefaultTabController(
          length: isServiceProvider ? 2 : 1,
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Service Providers'),
              centerTitle: true,
              bottom: isServiceProvider
                  ? const TabBar(
                      tabs: [
                        Tab(text: 'Service Providers'),
                        Tab(text: 'Job Requests'),
                      ],
                    )
                  : null,
            ),
            body: isServiceProvider
                ? TabBarView(
                    children: [
                      _buildAllServiceProvidersTab(),
                      const RequestedjobtabBar(),
                    ],
                  )
                : _buildAllServiceProvidersTab(),
          ),
        );
      },
    );
  }

  Widget _buildAllServiceProvidersTab() {
    return FutureBuilder(
      future: _fetchServiceProvidersWithPosts(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text('No service providers available.'),
          );
        } else {
          var serviceProviders = snapshot.data!;
          return ListView.builder(
            itemCount: serviceProviders.length,
            itemBuilder: (context, index) {
              var providerData = serviceProviders[index];
              var doc = providerData['profile'];
              var posts = providerData['posts'];
              var userId = doc.id;

              if (userId == FirebaseAuth.instance.currentUser!.uid) {
                return const SizedBox.shrink();
              }

              return Serviceprovidertab(
                  doc: doc,
                  userId: userId,
                  hasPosts: posts.isNotEmpty,
                  posts: posts);
            },
          );
        }
      },
    );
  }

  Future<List<Map<String, dynamic>>> _fetchServiceProvidersWithPosts() async {
    List<Map<String, dynamic>> serviceProviders = [];

    try {
      var profilesSnapshot = await FirebaseFirestore.instance
          .collection('profiles')
          .where('isServiceProvider', isEqualTo: true)
          .get();

      for (var doc in profilesSnapshot.docs) {
        var userId = doc.id;
        var posts = await profileController.fetchUserPosts(userId);
        serviceProviders.add({
          'profile': doc,
          'posts': posts,
        });
      }
    } catch (e) {
      log('Error fetching service providers with posts: $e');
    }

    return serviceProviders;
  }
}
