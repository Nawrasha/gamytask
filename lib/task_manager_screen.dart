import 'package:flutter/material.dart';

class TaskManagerScreen extends StatelessWidget {
  const TaskManagerScreen({super.key});

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
        color: Colors.black, // Set background to black
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
                      getTodaysName().toUpperCase() +
                          ", " +
                          DateTime.now().day.toString(),
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 4.0,
                            color: Colors.white.withOpacity(0.5),
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.notifications, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Let's eat tasks together",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 20),

                // Dashboard
                _buildDashboard(),

                const SizedBox(height: 20),

                // Task List
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "My tasks",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Text(
                        "View all",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildTaskCard(
                  title: 'Create Detail Booking',
                  subtitle: 'Productivity Mobile App',
                  status: 'Completed',
                  date: '01/03/2025',
                  color: Color(0xFF00CD06),
                ),
                const SizedBox(height: 16),
                _buildTaskCard(
                  title: 'Revision Home Page',
                  subtitle: 'Banking Mobile App',
                  status: 'To do',
                  date: '01/03/2025',
                  color: Color(0xFFFE0000),
                ),
                const SizedBox(height: 16),
                _buildTaskCard(
                  title: 'Course Flutter',
                  subtitle: 'Productivity Mobile App',
                  status: 'In progress',
                  date: '01/03/2025',
                  color: Color(0xFF00CCFF),
                ),
                const SizedBox(height: 16),
                _buildTaskCard(
                  title: 'Revision Home Page',
                  subtitle: 'Banking Mobile App',
                  status: 'Completed',
                  date: '01/03/2025',
                  color: Color(0xFF00CD06),
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
      height: 124,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD600), // Vibrant yellow
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD600).withOpacity(0.6), // Glow effect
            blurRadius: 12,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white,
            child: Text(
              "1",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Foulen ben foulen",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          height: 8,
                          width: constraints.maxWidth * (126 / 150),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "126/150 tasks done",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
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
    required String date,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
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
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
              const Spacer(),
              Container(
                width: 81, // Fixed width for status
                padding: const EdgeInsets.symmetric(vertical: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text inside
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
