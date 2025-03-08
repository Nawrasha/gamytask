import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'authentification/signUp.dart';
import 'authentification/signin.dart';
import 'employe-screen/wrapper.dart';
import 'boss-screen/wrapper.dart';
import 'boss-screen/main_boss.dart';
import 'employe-screen/main_employe.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GamyTask',
      home: AuthWrapper(), // Handles user authentication and navigation
      routes: {
        '/signin': (context) => SignInPage(),
        '/signup': (context) => SignUpPage(),
        '/bossHome': (context) => BossScreen(), // Redirect to Boss home page
        '/employeeHome':
            (context) => MainScreen(), // Redirect to Employee home page
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          debugPrint("Error in AuthWrapper: ${snapshot.error}");
          return const Center(child: Text('Something went wrong.'));
        }

        if (snapshot.data == null) {
          debugPrint("No user found, showing SignInPage");
          return SignInPage();
        }

        User user = snapshot.data!;
        debugPrint("User found: ${user.uid}");

        return FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .get(),
          builder: (context, roleSnapshot) {
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (roleSnapshot.hasError ||
                !roleSnapshot.hasData ||
                !roleSnapshot.data!.exists) {
              debugPrint("Error fetching user role: ${roleSnapshot.error}");
              return const Center(child: Text('Failed to fetch role.'));
            }

            String role = roleSnapshot.data!['role'] ?? '';
            debugPrint("User role: $role");

            if (role == 'boss') {
              return BossWrapper();
            } else if (role == 'employee') {
              return EmployeWrapper();
            }

            return SignInPage();
          },
        );
      },
    );
  }
}
