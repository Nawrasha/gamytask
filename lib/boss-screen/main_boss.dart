import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart'; // Import the custom BottomNavBar
import 'all_tasks.dart'; // Import the TaskManagerScreen
import 'home.dart'; 
import 'profile_page.dart'; // Import the ProfilePage
import 'note_page.dart'; // Import the NotePage
import 'leaderboard_page.dart'; // Import the LeaderboardPage

class MainBoss extends StatelessWidget {
  const MainBoss({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager Boss',
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0C16),
        primaryColor: const Color(0xFF0A0C16),
        bottomAppBarTheme: const BottomAppBarTheme(
          color: Color(0xFF0A0C16),
        ),
      ),
      home: const BossScreen(), // BossScreen is the initial screen
    );
  }
}

class BossScreen extends StatefulWidget {
  const BossScreen({super.key});

  @override
  BossScreenState createState() => BossScreenState();
}

class BossScreenState extends State<BossScreen> {
  int selectedIndex = 0; // Index of the selected tab

  // List of pages to display
  final List<Widget> _pages = [
    const StatsPage(), // Stats page is now first
    const TaskManagerScreen(), // Task Manager screen is now second
    const LeaderboardPage(),
    const ProfilePage(),
  ];

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      if (index >= 0 && index < _pages.length) {
        selectedIndex = index;
      }
    });
  }

  // Function to handle the + button press
  void _onAddButtonPressed() {
    // Navigate to the NotePage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C16), // Dark background for the whole screen
      body: _pages[selectedIndex], // Display the selected page
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        onAddButtonPressed: _onAddButtonPressed, // Pass the + button action
      ),
    );
  }
}