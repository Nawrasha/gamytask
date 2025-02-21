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
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Add today's name widget here
            Center(
              child: Text(
                getTodaysName(),
                style: const TextStyle(
                  fontFamily: 'arcade',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // White text for the heading
                ),
              ),
            ),
            const SizedBox(height: 20), // Add some spacing
            const Text(
              "Let's eat tasks together",
              style: TextStyle(
                fontFamily: 'arcade',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text for the heading
              ),
            ),
            const SizedBox(height: 20),

            // Add the dashboard widget here
            _buildDashboard(),

            const SizedBox(height: 20),

            // Add the task cards
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
    );
  }

  // Widget for the Dashboard
  Widget _buildDashboard() {
    return IntrinsicHeight( // Ensure both sides have equal height
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // User Info and Progress
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.person, size: 30, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        "Flen Ben Foulen",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Circular progress indicator
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 60,
                            width: 60,
                            child: CircularProgressIndicator(
                              value: 12 / 15, // Percentage progress (12 of 15 tasks)
                              color: Colors.yellow,
                              backgroundColor: Colors.grey[800],
                              strokeWidth: 6,
                            ),
                          ),
                          const Text(
                            "12/15",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "tasks done",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.yellow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Ranking and Points
          Expanded(
            flex: 1,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Classement",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "1er",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E2D),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 24),
                        SizedBox(height: 8),
                        Text(
                          "1200 Points",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.yellow,
                          ),
                        ),
                      ],
                    ),
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
    required String time,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      color: const Color(0xFF1E1E2D), // Dark card background
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white, // White text for title
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400], // Light gray text for subtitle
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[400], // Light gray text for time
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
