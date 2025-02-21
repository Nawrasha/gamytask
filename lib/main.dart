import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart'; // Import the BottomNavBar widget
import 'task_manager_screen.dart'; // Import the TaskManagerScreen
import 'stats_page.dart'; // Import the StatsPage
import 'profile_page.dart'; // Import the ProfilePage

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0A0C16), // Dark background
      ),
      home: const MainScreen(), // MainScreen is the initial screen
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Index of the selected tab

  // List of pages to display
  final List<Widget> _pages = [
    const TaskManagerScreen(), // Your existing Task Manager screen
    const StatsPage(), // Example: A stats page
    const ProfilePage(), // Example: A profile page
  ];

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}