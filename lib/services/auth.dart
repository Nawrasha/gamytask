import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign Up with additional fields: name, role, and teamID
  Future<User?> signUp(
    String name,
    String email,
    String password,
    String role,
    String teamID,
  ) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;
      if (user != null) {
        // Save user data to Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'role': role, // "employee" or "boss"
          'teamID': teamID, // Assign teamID directly
        });
        return user;
      }
    } catch (e) {
      print("Error signing up: $e");
      return null;
    }
    return null;
  }

  // Sign In (now only returns the User object)
  Future<User?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      return user; // Return the User object
    } catch (e) {
      print("Error signing in: $e");
      return null; // Return null if there's an error
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }
}
