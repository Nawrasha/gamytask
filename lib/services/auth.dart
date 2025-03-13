import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign In with improved error handling
  Future<Map<String, dynamic>> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userData = await _firestore
            .collection('users')
            .doc(user.uid)
            .get();
        
        if (!userData.exists) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'not-found',
            message: 'User data not found in database. Please contact support.',
          );
        }

        final data = userData.data() as Map<String, dynamic>;
        if (!data.containsKey('role')) {
          throw FirebaseException(
            plugin: 'cloud_firestore',
            code: 'invalid-data',
            message: 'User role not found. Please contact support.',
          );
        }

        return {
          'user': user,
          'userData': data,
        };
      }
      
      throw FirebaseAuthException(
        code: 'user-not-found',
        message: 'No user found for that email.',
      );
    } on FirebaseAuthException catch (e) {
      print('Authentication Error: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected Error: $e');
      rethrow;
    }
  }

  // Sign Up
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
          'role': role,
          'teamID': teamID,
          'createdAt': FieldValue.serverTimestamp(),
        });
        
        return user;
      }
    } on FirebaseAuthException catch (e) {
      print('Authentication Error: ${e.message}');
      rethrow;
    } catch (e) {
      print('Error signing up: $e');
      rethrow;
    }
    return null;
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
