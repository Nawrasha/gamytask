import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class Task {
  String title;
  String description; // Changed from subtitle to description
  String status;
  String date;
  Color color;

  Task({
    required this.title,
    required this.description, // Changed from subtitle to description
    required this.status,
    required this.date,
    required this.color,
  });

  // Factory constructor to create Task from Firestore data
  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Task(
      title: data['title'] ?? 'Untitled', // Default to 'Untitled' if missing
      description:
          data['description'] ?? 'No description', // Default if missing
      status: data['status'] ?? 'To do', // Default to 'To do' if missing
      date: data['date'] ?? 'Unknown', // Default if missing
      color: _getStatusColor(data['status'] ?? 'To do'),
    );
  }

  // Helper function to get color based on task status
  static Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return const Color(0xFF00CD06);
      case 'In progress':
        return const Color(0xFF00CCFF);
      default:
        return const Color(0xFFFE0000);
    }
  }
}

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    // Load tasks from Firestore here
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final userId = 'USER_ID'; // Replace with the current user's ID
    final tasksSnapshot =
        await FirebaseFirestore.instance
            .collection('tasks')
            .where('assignedTo', isEqualTo: userId)
            .get();

    final List<Task> loadedTasks =
        tasksSnapshot.docs.map((doc) {
          return Task.fromFirestore(doc);
        }).toList();

    setState(() {
      tasks = loadedTasks;
    });
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
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                        ),
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
                      return allStatuses
                          .where((s) => s['status'] != task.status)
                          .toList();
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
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 120,
                                      height: 40,
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: availableStatuses[0]['color'],
                                      ),
                                      child: CustomSlidableAction(
                                        onPressed: (context) {
                                          setState(() {
                                            task.status =
                                                availableStatuses[0]['status'];
                                            task.color =
                                                availableStatuses[0]['color'];
                                          });

                                          if (task.status == 'Completed') {
                                            _showCompletedPopup(context);
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
                                      margin: const EdgeInsets.symmetric(
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: availableStatuses[1]['color'],
                                      ),
                                      child: CustomSlidableAction(
                                        onPressed: (context) {
                                          setState(() {
                                            task.status =
                                                availableStatuses[1]['status'];
                                            task.color =
                                                availableStatuses[1]['color'];
                                          });

                                          if (task.status == 'Completed') {
                                            _showCompletedPopup(context);
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
                          description:
                              task.description, // Changed from subtitle to description
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

  // Widget for a Task Card
  Widget _buildTaskCard({
    required String title,
    required String description, // Changed from subtitle to description
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
            description, // Changed from subtitle to description
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Row(
                children: [
                  Icon(Icons.access_time, size: 16, color: Colors.grey[400]),
                  const SizedBox(width: 4),
                  Text(
                    date,
                    style: TextStyle(fontSize: 12, color: Colors.grey[400]),
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

  // Function to show the dialog when task is completed
  void _showCompletedPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          child: Container(
            width: 340,
            height: 360,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24.0),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(
                  'assets/popup.png', // Ensure you have this image in assets
                  width: 320,
                  height: 170,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 5),
                Column(
                  children: [
                    Text(
                      'Task Completed',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Color(0xFF182035),
                      ),
                    ),
                    Text(
                      'Great Job!',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF606268),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'You received 1 point.',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF606268),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFAD107),
                    minimumSize: Size(200, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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

  // Helper function to get today's name
  String getTodaysName() {
    final DateTime now = DateTime.now();
    final List<String> daysOfWeek = [
      'Sunday',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
    ];
    return daysOfWeek[now.weekday % 7];
  }
}
