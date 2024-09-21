import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer';

Future<void> createPrivacyPolicy() async {
  final firestore = FirebaseFirestore.instance;

  final privacyPolicyData = {
    'privacyPolicy': """
      <h1>Privacy Policy</h1>
      <p>Welcome to D_Art, a social media platform dedicated to showcasing artistic works and fostering connections between creators and admirers. At D_Art, we are committed to safeguarding your privacy and ensuring the security of your personal information. This Privacy Policy outlines how we collect, use, disclose, and manage your information when you use our mobile application. By accessing or using D_Art, you agree to the terms and practices described in this Privacy Policy.</p>
      
      <h3>Information We Collect</h3>
      <p>When you sign up for D_Art, we may collect the following information:</p>
      <ul>
        <li><strong>Personal Information:</strong> This includes your name, email address, profile picture, username, and any other details you provide.</li>
        <li><strong>User Interactions:</strong> Your activities within the app, such as posting or showcasing your work, commenting, liking, or sharing others' work, and messaging other users, may be collected and associated with your account.</li>
      </ul>
      
      <h3>How We Use Your Information</h3>
      <p>We use the information collected to:</p>
      <ul>
        <li>Provide and improve the D_Art app’s features, functionality, and overall user experience.</li>
        <li>Personalize content and recommend works based on your interests and interactions.</li>
        <li>Communicate with you about your account, updates, promotions, and other relevant information.</li>
        <li>Analyze usage patterns to enhance the app’s performance and optimize our services.</li>
        <li>Detect, prevent, and address technical issues, security breaches, and fraudulent activities within the app.</li>
      </ul>
      
      <h3>Data Security</h3>
      <p>D_Art implements reasonable security measures to protect your information from unauthorized access, disclosure, alteration, or destruction. However, no method of transmission over the internet or electronic storage is 100% secure, and we cannot guarantee absolute security.</p>
    """
  };

  try {
    await firestore
        .collection('app_info')
        .doc('privacy_policy')
        .set(privacyPolicyData);
    log('Privacy Policy added successfully');
  } catch (e) {
    log('Error adding Privacy Policy: $e');
  }
}
