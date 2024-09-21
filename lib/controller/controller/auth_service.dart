import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> createUserWithEmailAndPass(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      if (cred.user != null) {
        await _saveEmailToFirestore(cred.user!.uid, email);
      }
      return cred.user;
    } catch (e) {
      log('Something went wrong during sign up: $e');
    }
    return null;
  }

  Future<User?> loginUserWithEmailAndPass(String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      log('Something went wrong during login: $e');
    }
    return null;
  }

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user != null) {
        await _saveEmailToFirestore(user.uid, user.email!);
      }
      return user;
    } catch (e) {
      log('Error during Google sign in: $e');
    }
    return null;
  }

  Future<void> _saveEmailToFirestore(String uid, String email) async {
    try {
      await _firestore.collection('profiles').doc(uid).set({
        'email': email,
      }, SetOptions(merge: true));
    } catch (e) {
      log('Error saving email to Firestore: $e');
    }
  }

  Future<bool> checkEmailExists(String email) async {
    final snapshot = await _firestore
        .collection('profiles')
        .where('email', isEqualTo: email)
        .get();
    return snapshot.docs.isNotEmpty;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      log('ERROR ON SIGN OUT >> : $e');
    }
  }
}
