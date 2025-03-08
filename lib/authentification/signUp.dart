import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController teamIdController =
      TextEditingController(); // New controller for teamID

  String _selectedRole = 'employee'; // Default role is employee
  bool _isLoading = false;
  String? _errorMessage;

  // Function to handle the sign-up logic
  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      // Check if the team already has a boss
      DocumentSnapshot teamSnapshot =
          await _firestore
              .collection('teams')
              .doc(teamIdController.text.trim())
              .get();

      if (_selectedRole == 'boss') {
        // If user is trying to sign up as a boss
        if (teamSnapshot.exists && teamSnapshot['managerId'] != null) {
          setState(() {
            _errorMessage = "This team already has a boss.";
            _isLoading = false;
          });
          return;
        }
        // Set the managerId to this user's UID
        await _firestore
            .collection('teams')
            .doc(teamIdController.text.trim())
            .set({
              'managerId': userCredential.user!.uid,
              'members': [], // Initialize members list
            }, SetOptions(merge: true));
      } else {
        // If user is signing up as an employee
        if (teamSnapshot.exists) {
          // Add the user ID to the members list
          await _firestore
              .collection('teams')
              .doc(teamIdController.text.trim())
              .update({
                'members': FieldValue.arrayUnion([userCredential.user!.uid]),
              });
        }
      }

      // Store user details in Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': emailController.text.trim(),
        'name': nameController.text.trim(),
        'role': _selectedRole,
        'teamID':
            teamIdController.text.trim(), // Save teamID from the new field
      });

      Navigator.pushReplacementNamed(context, '/'); // Redirect to AuthWrapper
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to sign up. ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.person_add, size: 80, color: Colors.blueAccent),
                  SizedBox(height: 20),
                  Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) => value!.isEmpty ? "Enter your name" : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator:
                        (value) =>
                            value!.isEmpty ? "Enter a valid email" : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator:
                        (value) =>
                            value!.length < 6
                                ? "Password must be at least 6 characters"
                                : null,
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: teamIdController, // New field for teamID
                    decoration: InputDecoration(
                      labelText: "Team ID",
                      border: OutlineInputBorder(),
                    ),
                    validator:
                        (value) =>
                            value!.isEmpty
                                ? "Enter a team ID"
                                : null, // Optional validation
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    items: [
                      DropdownMenuItem(
                        value: 'employee',
                        child: Text("Employee"),
                      ),
                      DropdownMenuItem(value: 'boss', child: Text("Boss")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Role",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    SizedBox(height: 10),
                    Text(_errorMessage!, style: TextStyle(color: Colors.red)),
                  ],
                  SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                        onPressed: _signUp,
                        child: Text("Sign Up"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () => Navigator.pushNamed(context, '/signin'),
                    child: Text("Already have an account? Sign in"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
