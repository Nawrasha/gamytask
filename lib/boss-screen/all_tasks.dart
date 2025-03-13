import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'note_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Add the StatusIndicator class
class StatusIndicator extends StatelessWidget {
  final Color color;
  final String text;

  const StatusIndicator({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

// Update Task class to match the employee screen structure
class Task {
  String id;
  String title;
  String description;
  String status;
  DateTime createdAt;
  DateTime deadline;
  String userId;
  Color color;
  String userImage;
  String userName;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.deadline,
    required this.userId,
    required this.color,
    required this.userImage,
    required this.userName,
  });

  // Factory constructor to create Task from Firestore data
  static Task fromFirestore(DocumentSnapshot doc, Map<String, dynamic> userData) {
    final data = doc.data() as Map<String, dynamic>;
    return Task(
      id: doc.id,
      title: data['title'] ?? 'Untitled',
      description: data['description'] ?? 'No description',
      status: data['status'] ?? 'to-do',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      deadline: (data['deadline'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
      color: _getStatusColor(data['status'] ?? 'to-do'),
      userImage: userData['profileImage'] ?? 'assets/default_user.png',
      userName: userData['name'] ?? 'Unknown User',
    );
  }

  static Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF00CD06);
      case 'in-progress':
        return const Color(0xFF00CCFF);
      default:
        return const Color(0xFFFE0000);
    }
  }

  String getFormattedDeadline() {
    return '${deadline.day}/${deadline.month}/${deadline.year}';
  }
}

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  Stream<QuerySnapshot>? _tasksStream;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _setupTasksStream();
  }

  void _setupTasksStream() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Get the team first
      final teamSnapshot = await FirebaseFirestore.instance
          .collection('teams')
          .where('managerId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (teamSnapshot.docs.isEmpty) return;

      final teamDoc = teamSnapshot.docs.first;
      final List<String> memberIds = List<String>.from(teamDoc['members']);

      // Set up stream for tasks from all team members
      _tasksStream = FirebaseFirestore.instance
          .collection('tasks')
          .where('userId', whereIn: memberIds)
          .snapshots();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error setting up tasks stream: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateTaskStatus(String taskId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
        'status': newStatus.toLowerCase().replaceAll(' ', '-'),
      });
    } catch (e) {
      print('Error updating task status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SlidableAutoCloseBehavior(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 24.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    StatusIndicator(color: const Color(0xFFFE0000), text: "To Do"),
                    StatusIndicator(color: const Color(0xFF00CCFF), text: "In Progress"),
                    StatusIndicator(color: const Color(0xFF00CD06), text: "Completed"),
                  ],
                ),
                const SizedBox(height: 20),
                StreamBuilder<QuerySnapshot>(
                  stream: _tasksStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text('Error: ${snapshot.error}',
                            style: const TextStyle(color: Colors.white)),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      );
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return _buildEmptyState();
                    }

                    // Get user data for all tasks
                    return FutureBuilder(
                      future: _getUserDataForTasks(snapshot.data!.docs),
                      builder: (context, AsyncSnapshot<Map<String, Map<String, dynamic>>> userDataSnapshot) {
                        if (!userDataSnapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          );
                        }

                        final tasks = snapshot.data!.docs.map((doc) {
                          final userId = (doc.data() as Map<String, dynamic>)['userId'] as String;
                          return Task.fromFirestore(doc, userDataSnapshot.data![userId]!);
                        }).toList();

                        if (tasks.isEmpty) {
                          return _buildEmptyState();
                        }

                        // Group tasks by user
                        final Map<String, List<Task>> groupedTasks = {};
                        for (var task in tasks) {
                          if (!groupedTasks.containsKey(task.userId)) {
                            groupedTasks[task.userId] = [];
                          }
                          groupedTasks[task.userId]!.add(task);
                        }

                        return Column(
                          children: groupedTasks.entries.map((entry) {
                            final userTasks = entry.value;
                            final user = userTasks.first;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage: user.userImage.startsWith('assets/')
                                            ? AssetImage(user.userImage)
                                            : NetworkImage(user.userImage) as ImageProvider,
                                        radius: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        user.userName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ...userTasks.map((task) => _buildTaskItem(task)).toList(),
                              ],
                            );
                          }).toList(),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Map<String, Map<String, dynamic>>> _getUserDataForTasks(List<QueryDocumentSnapshot> tasks) async {
    final userIds = tasks.map((task) => (task.data() as Map<String, dynamic>)['userId'] as String).toSet();
    Map<String, Map<String, dynamic>> userData = {};

    for (String userId in userIds) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        userData[userId] = userDoc.data() as Map<String, dynamic>;
      }
    }

    return userData;
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/ghost1.png',
              width: 100,
              height: 100,
              opacity: const AlwaysStoppedAnimation(0.5),
            ),
            const SizedBox(height: 20),
            const Text(
              'No Tasks Found',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Create new tasks for your team',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(Task task) {
    List<Map<String, dynamic>> getAvailableStatuses() {
      final allStatuses = [
        {
          'status': 'to-do',
          'color': const Color(0xFFFE0000),
          'display': 'To do'
        },
        {
          'status': 'in-progress',
          'color': const Color(0xFF00CCFF),
          'display': 'In progress'
        },
        {
          'status': 'completed',
          'color': const Color(0xFF00CD06),
          'display': 'Completed'
        },
      ];
      return allStatuses
          .where((s) => s['status'] != task.status.toLowerCase())
          .toList();
    }

    final availableStatuses = getAvailableStatuses();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Slidable(
            startActionPane: ActionPane(
              motion: const StretchMotion(),
              extentRatio: 0.3,
              children: [
                ...availableStatuses.map((status) => SlidableAction(
                      flex: 1,
                      backgroundColor: status['color'],
                      foregroundColor: Colors.white,
                      onPressed: (context) async {
                        await _updateTaskStatus(task.id, status['status']);
                        if (status['status'] == 'completed') {
                          _showCompletedPopup(context);
                        }
                      },
                      label: status['display'],
                    )),
              ],
            ),
            child: Container(
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
                    task.title,
                    style: const TextStyle(
                      fontFamily: 'arcade',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    task.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey[400]),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[400]),
                      const SizedBox(width: 4),
                      Text(
                        task.getFormattedDeadline(),
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                      const Spacer(),
                      Container(
                        width: 81,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: task.color,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          task.status,
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
            ),
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
            borderRadius: BorderRadius.circular(24.0), // Set corner radius to 24
          ),
          child: Container(
            width: 340,
            height: 360,
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
                SizedBox(height: 5),
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
                SizedBox(height: 5),
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
}