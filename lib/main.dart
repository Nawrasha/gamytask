
/*import 'package:flutter/material.dart';
import 'bottom_nav_bar.dart'; // Import the custom BottomNavBar
import 'task_manager_screen.dart'; // Import the TaskManagerScreen
import 'stats_page.dart'; // Import the StatsPage
import 'profile_page.dart'; // Import the ProfilePage
import 'note_page.dart'; // Import the NotePage
import 'leaderboard_page.dart';

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
        brightness: Brightness.dark, // Enforces a dark theme
        scaffoldBackgroundColor: const Color(0xFF0A0C16), // Dark background for the app
        primaryColor: const Color(0xFF0A0C16), // Dark color for primary elements
        bottomAppBarTheme: BottomAppBarTheme(
          color: const Color(0xFF0A0C16), // Dark background for Bottom App Bar
        ),
      ),
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
    MaterialPageRoute(builder: (context) => NotePage()),
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
}*/
import 'package:flutter/material.dart';
import 'views/employee/bottom_nav_bar.dart'; // Import the custom BottomNavBar
import 'task_manager_screen.dart'; // Import the TaskManagerScreen (pour manager)
import 'stats_page.dart'; // Import the StatsPage (pour manager et employé)
import 'views/employee/profile_page.dart'; // Import the ProfilePage (pour manager et employé)
import 'views/employee/note_page.dart'; // Import the NotePage (pour manager et employé)
import 'views/employee/leaderboard_page.dart'; // Import the LeaderboardPage (pour manager)

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
        brightness: Brightness.dark, // Enforces a dark theme
        scaffoldBackgroundColor: const Color(0xFF0A0C16), // Dark background for the app
        primaryColor: const Color(0xFF0A0C16), // Dark color for primary elements
        bottomAppBarTheme: BottomAppBarTheme(
          color: const Color(0xFF0A0C16), // Dark background for Bottom App Bar
        ),
      ),
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

  // Rôle de l'utilisateur : peut être "manager" ou "employee"
  final bool isManager = false; // Change cette valeur selon le rôle de l'utilisateur, tu peux la définir dynamiquement plus tard
  
  // Liste des pages pour le manager
  final List<Widget> _managerPages = [
    const TaskManagerScreen(), // TaskManagerScreen pour le manager
    const StatsPage(), // StatsPage, accessible aussi bien par le manager que l'employé
    const LeaderboardPage(), // LeaderboardPage, spécifique au manager
    const ProfilePage(), // ProfilePage, accessible par les deux
  ];

  // Liste des pages pour l'employé
  final List<Widget> _employeePages = [
    const TaskManagerScreen(), // TaskManagerScreen pour le manager
    const StatsPage(), // StatsPage, accessible aussi bien par le manager que l'employé
    const LeaderboardPage(), // LeaderboardPage, spécifique au manager
    const ProfilePage(), //Page, accessible par l'employé aussi
  ];

  // Fonction de sélection des onglets
  void _onItemTapped(int index) {
    setState(() {
      if (index >= 0 && index < (isManager ? _managerPages.length : _employeePages.length)) {
        selectedIndex = index;
      }
    });
  }

  // Fonction pour la gestion du bouton + (par exemple, pour ajouter une tâche)
  void _onAddButtonPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NotePage()), // Cette page pourrait être différente pour le manager
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C16), // Fond sombre pour toute l'application
      body: isManager ? _managerPages[selectedIndex] : _employeePages[selectedIndex], // On affiche la page en fonction du rôle
      bottomNavigationBar: BottomNavBar(
        currentIndex: selectedIndex,
        onTap: _onItemTapped,
        onAddButtonPressed: _onAddButtonPressed, // Action du bouton + pour le manager et l'employé
      ),
    );
  }
}
