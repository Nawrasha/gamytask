import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// Task model to manage task data
class Task {
  String title;
  String subtitle;
  String status;
  String date;
  Color color;

  Task({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.date,
    required this.color,
  });
}

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  // List of tasks
  List<Task> tasks = [
    Task(
      title: 'Create Detail Booking',
      subtitle: 'Productivity Mobile App',
      status: 'Completed',
      date: '01/03/2025',
      color: const Color(0xFF00CD06),
    ),
    Task(
      title: 'Revision Home Page',
      subtitle: 'Banking Mobile App',
      status: 'To do',
      date: '01/03/2025',
      color: const Color(0xFFFE0000),
    ),
    Task(
      title: 'Course Flutter',
      subtitle: 'Productivity Mobile App',
      status: 'In progress',
      date: '01/03/2025',
      color: const Color(0xFF00CCFF),
    ),
    Task(
      title: 'Revision Home Page',
      subtitle: 'Banking Mobile App',
      status: 'Completed',
      date: '01/03/2025',
      color: const Color(0xFF00CD06),
    ),
  ];

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

  // Function to show the dialog when task is completed
  void _showCompletedPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0), // Set corner radius to 24
        ),
        child: Container(
          width: 340,
          height:360,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24.0), // Set corner radius to 24
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Reduced space between image and top of popup
             // Small space between the top and the image
              Image.asset(
                'assets/popup.png', // Ensure you have this image in assets
                width: 320, // New width
                height: 170,
                fit: BoxFit.cover,
              ),
              // Task completed text and Great Job text
              SizedBox(height:5),
              Column(
                children: [
                  Text(
                    'Task Completed',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24, // Bold and font size 20
                      color: Color(0xFF182035), // Color for "Task Completed"
                    ),
                  ),
                
                  Text(
                    'Great Job!',
                    style: TextStyle(
                      fontSize: 18,  // Font size 16
                      fontWeight: FontWeight.w500, // Medium weight
                      color: Color(0xFF606268), // Color for "Great Job!"
                    ),
                    textAlign: TextAlign.center, // Center align the text
                  ),
              
                  Text(
                    'You received 1 point.',
                    style: TextStyle(
                      fontSize: 18,  // Font size 16
                      fontWeight: FontWeight.w500, // Medium weight
                      color: Color(0xFF606268), // Color for "You received 1 point."
                    ),
                    textAlign: TextAlign.center, // Center align the text
                  ),
                ],
              ),
              SizedBox(height:5),
              // Continue Button with white text
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFAD107), // Color for the button
                  minimumSize: Size(200, 50), // Adjust the size of the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White color for text in the button
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: SlidableAutoCloseBehavior(
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
                              // ignore: deprecated_member_use
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
                      const Text(
                        "My tasks",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const Text(
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
                  ...tasks.map((task) {
                    // Get available status options (excluding current status)
                    List<Map<String, dynamic>> getAvailableStatuses() {
                      final allStatuses = [
                        {
                          'status': 'To do',
                          'color': const Color(0xFFFE0000),
                          'icon': Icons.pending_actions,
                        },
                        {
                          'status': 'In progress',
                          'color': const Color(0xFF00CCFF),
                          'icon': Icons.trending_up,
                        },
                        {
                          'status': 'Completed',
                          'color': const Color(0xFF00CD06),
                          'icon': Icons.check_circle,
                        },
                      ];
                      return allStatuses.where((s) => s['status'] != task.status).toList();
                    }

                    final availableStatuses = getAvailableStatuses();

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Slidable(
                        key: ValueKey(task.title),
                        startActionPane: ActionPane(
                          motion: const StretchMotion(),
                          extentRatio: 0.3,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 40,
                                      margin: const EdgeInsets.symmetric(vertical: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: availableStatuses[0]['color'],
                                      ),
                                      child: CustomSlidableAction(
                                        onPressed: (context) {
                                          setState(() {
                                            task.status = availableStatuses[0]['status'];
                                            task.color = availableStatuses[0]['color'];
                                          });

                                          if (task.status == 'Completed') {
                                            _showCompletedPopup(context);
                                            // Show dialog when task is marked as completed
                                          }

                                          Slidable.of(context)?.close();
                                        },
                                        padding: EdgeInsets.zero,
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        child: Text(
                                          availableStatuses[0]['status'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 120,
                                      height: 40,
                                      margin: const EdgeInsets.symmetric(vertical: 4),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: availableStatuses[1]['color'],
                                      ),
                                      child: CustomSlidableAction(
                                        onPressed: (context) {
                                          setState(() {
                                            task.status = availableStatuses[1]['status'];
                                            task.color = availableStatuses[1]['color'];
                                          });
                                           if (task.status == 'Completed') {
                                           _showCompletedPopup(context);
                                            // Show dialog when task is marked as completed
                                          }
                                          Slidable.of(context)?.close();
                                        },
                                        padding: EdgeInsets.zero,
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        child: Text(
                                          availableStatuses[1]['status'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        child: _buildTaskCard(
                          title: task.title,
                          subtitle: task.subtitle,
                          status: task.status,
                          date: task.date,
                          color: task.color,
                        ),
                      ),
                    );
                  }),
                ],
              ),
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
        color: const Color(0xFFFFD600),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD600).withOpacity(0.6),
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
            style: const TextStyle(
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
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                width: 81,
                padding: const EdgeInsets.symmetric(vertical: 4),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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