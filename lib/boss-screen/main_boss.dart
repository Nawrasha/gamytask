import 'package:flutter/material.dart';

class MainBoss extends StatelessWidget {
  const MainBoss({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boss Dashboard'),
      ),
      body: const Center(
        child: Text(
          'Bienvenue dans l\'interface Boss.',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xFF0A0C16), // Dark background
    );
  }
}
