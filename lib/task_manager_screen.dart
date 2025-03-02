import 'package:flutter/material.dart';

class TaskManagerScreen extends StatelessWidget {
  const TaskManagerScreen({super.key});

  // Helper function to get today's name
  String getTodaysName() {
    final now = DateTime.now();
    return [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ][now.weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFF0A0C16), // Background color: #0A0C16
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      getTodaysName(),
                      style: TextStyle(
                        fontFamily: 'arcade',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.white.withOpacity(0.5),
                            offset: Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Let's eat tasks together",
                  style: TextStyle(
                    fontFamily: 'arcade',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [Colors.yellow, Colors.orange],
                      ).createShader(Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                ),
                const SizedBox(height: 20),

                // Dashboard
                _buildDashboard(),

                const SizedBox(height: 20),

                // Task List
                Text(
                  "Your Tasks",
                  style: TextStyle(
                    fontFamily: 'arcade',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTaskCard(
                  title: 'Productivity Mobile App',
                  subtitle: 'Create Detail Booking',
                  status: 'Completed',
                  color: Color(0xFF00CD06),
                ),
                const SizedBox(height: 16),
                _buildTaskCard(
                  title: 'Banking Mobile App',
                  subtitle: 'Revision Home Page',
                  status: 'To do',
                  color: Color(0xFFFE0000),
                ),
                const SizedBox(height: 16),
                _buildTaskCard(
                  title: 'Online Course',
                  subtitle: 'Working On Landing Page',
                  status: 'In Progress',
                  color: Color(0xFF00CCFF),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget for the Dashboard
  Widget _buildDashboard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Grey contour for the border
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // User Info and Progress
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person, size: 30, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      "Flen Ben Foulen",
                      style: TextStyle(
                        fontFamily: 'arcade',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: 12 / 15,
                  backgroundColor: Colors.grey[800],
                  color: Colors.yellow,
                ),
                const SizedBox(height: 8),
                Text(
                  "12/15 tasks done",
                  style: TextStyle(
                    fontFamily: 'arcade',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Ranking and Points
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // Grey contour
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      "1st",
                      style: TextStyle(
                        fontFamily: 'arcade',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "Rank",
                      style: TextStyle(
                        fontFamily: 'arcade',
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey, // Grey contour
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Icon(Icons.star, color: Colors.yellow, size: 24),
                    Text(
                      "1200",
                      style: TextStyle(
                        fontFamily: 'arcade',
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget for a Task Card
  Widget _buildTaskCard({
    required String title,
    required String subtitle,
    required String status,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      color: Colors.transparent, // Transparent background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Colors.grey, // Grey contour
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins', // Police Poppins
                fontSize: 22, // Taille de police 16
                fontWeight: FontWeight.bold, // Gras
                color: Colors.white, // Couleur blanche
                height: 14 / 16, // Hauteur de ligne 14 (calculée par rapport à la taille de police)
                letterSpacing: 0.13 * 16, // Espacement des lettres de 13% (0.13 * taille de police)
              ),
            ),
            const SizedBox(height: 15),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'arcade', // Police SkillScreen
                fontSize: 15, // Taille de police 12
                fontWeight: FontWeight.normal, // Poids regular (normal)
                color: const Color(0xFF848A94), // Couleur #848A94 avec opacité 100%
                height: 12 / 12, // Hauteur de ligne 12 (calculée par rapport à la taille de police)
                letterSpacing: 0, // Espacement des lettres de 0%
              ),
            ),
            const SizedBox(height: 12),
            Row(
  children: [
    Container(
      width: 100, // Fixed width
      height: 28, // Fixed height
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Padding
      decoration: BoxDecoration(
        color: color, // Dynamic background color (e.g., green for Completed)
        borderRadius: BorderRadius.circular(16), // Rounded corners
        border: Border.all(
          color: color,
          width: 2, // Border width
        ),
      ),
      child: Center(
        child: Text(
          status,
          style: TextStyle(
            fontFamily: 'Intel', // Font
            fontSize: 13, // Font size
            fontWeight: FontWeight.bold, // Bold text
            color: Colors.white, // White text
            height: 17.5 / 12, // Line height
            letterSpacing: -0.3, // Letter spacing
          ),
        ),
      ),
    ),
  ],
),

          ],
        ),
      ),
    );
  }
}