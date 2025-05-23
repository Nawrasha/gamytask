import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart'; // Import the custom BottomNavBar
import 'task_manager_screen.dart'; // Import the TaskManagerScreen
import 'stats_page.dart'; // Import the StatsPage
import 'profile_page.dart'; // Import the ProfilePage
import 'note_page.dart'; // Import the NotePage
import 'leaderboard_page.dart'; // Import the LeaderboardPage

class MainEmploye extends StatelessWidget {
  const MainEmploye({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        brightness: Brightness.dark, // Enforces a dark theme
        scaffoldBackgroundColor: const Color(0xFF0A0C16), // Dark background for the app
        primaryColor: const Color(0xFF0A0C16), // Dark color for primary elements
        bottomAppBarTheme: const BottomAppBarTheme(
          color: Color(0xFF0A0C16), // Dark background for Bottom App Bar
        ), // <-- Parenthèse fermante pour BottomAppBarTheme
      ), // <-- Parenthèse fermante pour ThemeData
      home: const MainScreen(), // MainScreen is the initial screen
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  int selectedIndex = 0; // Index of the selected tab

  // List of pages to display
  final List<Widget> _pages = [
    const TaskManagerScreen(), // Your existing Task Manager screen
    const StatsPage(), // Example: A stats page
    const LeaderboardPage(),
    //const NotePage(), // Example: A notes page
    const ProfilePage(), // Example: A profile page
  ];

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      // Ensure index is within valid range (0, 1, 2, 3)
      if (index >= 0 && index < _pages.length) {
        selectedIndex = index;
      }
    });
  }

  // Function to handle the + button press
  void _onAddButtonPressed() {
    // Naviguer vers la NotePage
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