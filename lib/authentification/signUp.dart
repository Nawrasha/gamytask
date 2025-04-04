import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

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
  TextEditingController teamIdController = TextEditingController();

  String _selectedRole = 'employee';
  bool _isLoading = false;
  String? _errorMessage;

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

      User? user = userCredential.user;

      // Send email verification
      await user!.sendEmailVerification();

      // Wait for the verification (5 minutes)
      bool isVerified = false;
      Timer(const Duration(minutes: 5), () async {
        if (!user.emailVerified) {
          await _auth.currentUser!
              .delete(); // Delete unverified user after 5 minutes
          setState(() {
            _errorMessage = "Email not verified. User deleted.";
            _isLoading = false;
          });
          return;
        }
      });

      // Check if email is verified
      await Future.delayed(
        const Duration(seconds: 3),
      ); // Short delay before checking verification status

      if (!user.emailVerified) {
        setState(() {
          _errorMessage = "Please verify your email to proceed.";
          _isLoading = false;
        });
        return;
      }

      // Create user document in Firestore
      if (_selectedRole == 'boss') {
        DocumentSnapshot teamSnapshot =
            await _firestore
                .collection('teams')
                .doc(teamIdController.text.trim())
                .get();

        if (teamSnapshot.exists && teamSnapshot['managerId'] != null) {
          setState(() {
            _errorMessage = "This team already has a boss.";
            _isLoading = false;
          });
          return;
        }

        await _firestore
            .collection('teams')
            .doc(teamIdController.text.trim())
            .set({
              'managerId': user.uid,
              'members': [],
            }, SetOptions(merge: true));
      } else {
        DocumentSnapshot teamSnapshot =
            await _firestore
                .collection('teams')
                .doc(teamIdController.text.trim())
                .get();

        if (teamSnapshot.exists) {
          await _firestore
              .collection('teams')
              .doc(teamIdController.text.trim())
              .update({
                'members': FieldValue.arrayUnion([user.uid]),
              });
        }
      }

      // Navigate based on the selected role after successful verification
      if (_selectedRole == 'boss') {
        Navigator.pushReplacementNamed(context, '/bossHome');
      } else if (_selectedRole == 'employee') {
        Navigator.pushReplacementNamed(context, '/employeeHome');
      }
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SIGN UP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Create Account',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Please fill in the form to continue',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
                const SizedBox(height: 40),

                buildTextField(nameController, 'Full Name'),
                const SizedBox(height: 16),
                buildTextField(emailController, 'Email'),
                const SizedBox(height: 16),
                buildTextField(passwordController, 'Password', obscure: true),
                const SizedBox(height: 16),
                buildTextField(teamIdController, 'Team ID'),
                const SizedBox(height: 16),

                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _selectedRole,
                    dropdownColor: Colors.black,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                    ),
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Select Role',
                      hintStyle: const TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color(0xFFFFD700),
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Colors.white,
                          width: 1,
                        ),
                      ),
                      prefixIcon: Icon(
                        _selectedRole == 'boss'
                            ? Icons.admin_panel_settings
                            : Icons.person_outline,
                        color: Color(0xFFFFD700),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'employee',
                        child: Row(
                          children: const [
                            Icon(
                              Icons.person_outline,
                              color: Color(0xFFFFD700),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Employee",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'boss',
                        child: Row(
                          children: const [
                            Icon(
                              Icons.admin_panel_settings,
                              color: Color(0xFFFFD700),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "Boss",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedRole = value!;
                      });
                    },
                  ),
                ),

                const SizedBox(height: 32),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _signUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFD700),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'SIGN UP',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),

                const SizedBox(height: 32),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account? ",
                      style: TextStyle(color: Colors.grey),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/signin'),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xFFFFD700),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
    TextEditingController controller,
    String hintText, {
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Color(0xFFFFD700), width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(color: Colors.white, width: 1),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) return "Enter $hintText";
          if (hintText == 'Password' && value.length < 6)
            return "Password must be at least 6 characters";
          return null;
        },
      ),
    );
  }
}
