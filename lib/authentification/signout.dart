import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signin.dart'; // Import the Sign-In Page

Future<void> signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();

  // Redirect to Sign-In Page after sign-out
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => SignInPage()),
  );
}
