import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_art/view/modules/chatscreen/models/chat_list_model.dart';
import 'package:d_art/view/modules/chatscreen/models/messages_model.dart';
// import 'package:d_art/view/modules/chatscreen/screen/chatscreen.dart';
// import 'package:d_art/view/modules/chatscreen/widgets/navigat.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class ApiServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Future<bool> getLogin({
  //   required String phone,
  //   required String password,
  //   required BuildContext context,
  // }) async {
  //   try {
  //     final userCredential = await _auth.signInWithEmailAndPassword(
  //       email: phone, // Assuming `phone` is the email here.
  //       password: password,
  //     );

  //     final user = userCredential.user;
  //     if (user != null) {
  //       final token = await user.getIdToken();
  //       final pref = await SharedPreferences.getInstance();
  //       pref.setString('token', token);
  //       pref.setString('id', user.uid);

  //       removeNavigate(context, const HomeScreen());
  //       return true;
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     log('Login Error: $e');
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(e.message ?? 'Failed to login.'),
  //     ));
  //   }
  //   return false;
  // }

  Future<ChatListModel?> getChatList() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final snapshot = await _firestore
            .collection('chat-list')
            .where('userId', isEqualTo: user.uid)
            .get();

        if (snapshot.docs.isNotEmpty) {
          // Assuming that chatListModelFromJson can handle the map conversion
          return chatListModelFromJson(snapshot.docs.toString());
        }
      }
    } catch (e) {
      log('Error fetching chat list: $e');
    }
    return null;
  }

  Future<MessagesModel?> getUserMessages({required String userID}) async {
    try {
      final snapshot = await _firestore
          .collection('messages')
          .where('to_user', isEqualTo: userID)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return messagesModelFromJson(snapshot.docs.toString());
      }
    } catch (e) {
      log('Error fetching user messages: $e');
    }
    return null;
  }

  Future<bool> sendMessage({
    required String userID,
    required String message,
  }) async {
    try {
      await _firestore.collection('messages').add({
        'to_user': userID,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
      });
      return true;
    } catch (e) {
      log('Error sending message: $e');
      return false;
    }
  }
}
