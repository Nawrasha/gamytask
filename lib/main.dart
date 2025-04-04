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
import 'welcome/splash_screen.dart';
import 'welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');
  } catch (e) {
    print('❌ Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GamyTask',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: SplashScreen(), // Start with SplashScreen
      routes: {
        '/welcome': (context) => WelcomeScreen(),
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
          debugPrint("Waiting for auth state...");
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          debugPrint("Error in AuthWrapper: ${snapshot.error}");
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        if (snapshot.data == null) {
          debugPrint("No user found, showing SignInPage");
          return SignInPage();
        }

        User user = snapshot.data!;
        debugPrint("User found: ${user.uid}");

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get(),
          builder: (context, roleSnapshot) {
            debugPrint("Fetching role for user: ${user.uid}");
            
            if (roleSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (roleSnapshot.hasError) {
              debugPrint("Error fetching role: ${roleSnapshot.error}");
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Failed to fetch role.'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );
            }

            if (!roleSnapshot.hasData || !roleSnapshot.data!.exists) {
              debugPrint("No user document found");
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('User data not found'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                      },
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );
            }

            final data = roleSnapshot.data!.data() as Map<String, dynamic>;
            String role = data['role'] ?? '';
            debugPrint("User role: $role");

            if (role == 'boss') {
              return BossWrapper();
            } else if (role == 'employee') {
              return EmployeWrapper();
            }

            debugPrint("Invalid role: $role");
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Invalid role: $role'),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                    child: const Text('Sign Out'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
