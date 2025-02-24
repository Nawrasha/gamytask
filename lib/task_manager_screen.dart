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
                  time: '2min ago',
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                _buildTaskCard(
                  title: 'Banking Mobile App',
                  subtitle: 'Revision Home Page',
                  status: 'Suspended',
                  time: '5min ago',
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                _buildTaskCard(
                  title: 'Online Course',
                  subtitle: 'Working On Landing Page',
                  status: 'In Progress',
                  time: '7min ago',
                  color: Colors.blue,
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
    required String time,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: Colors.grey, // Grey border
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
                fontFamily: 'arcade',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'arcade',
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey, // Grey contour
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontFamily: 'arcade',
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  time,
                  style: TextStyle(
                    fontFamily: 'arcade',
                    fontSize: 12,
                    color: Colors.grey[400],
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
