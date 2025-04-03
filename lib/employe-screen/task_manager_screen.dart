import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Task {
  String title;
  String description;
  String status;
  DateTime createdAt;
  DateTime deadline;
  String userId;
  Color color;

  Task({
    required this.title,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.deadline,
    required this.userId,
    required this.color,
  });

  // Factory constructor to create Task from Firestore data
  factory Task.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Task(
      title: data['title'] ?? 'Untitled',
      description: data['description'] ?? 'No description',
      status: data['status'] ?? 'to-do',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      deadline: (data['deadline'] as Timestamp).toDate(),
      userId: data['userId'] ?? '',
      color: _getStatusColor(data['status'] ?? 'to-do'),
    );
  }

  // Helper function to get color based on task status
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

  // Format deadline for display
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
  List<Task> tasks = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<QuerySnapshot>? _tasksStream;

  @override
  void initState() {
    super.initState();
    _setupTasksStream();
  }

  // Add this new method to update task status in Firestore
  Future<void> _updateTaskStatus(String taskId, String newStatus) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // Update task status
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
        'status': newStatus.toLowerCase().replaceAll(' ', '-'),
      });

      if (newStatus == 'completed') {
        final userRef = FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid);

        // Get current user data
        final userDoc = await userRef.get();
        final userData = userDoc.data() ?? {};

        int currentScore = (userData['score'] ?? 0) + 1;
        int totalScore = (userData['totalScore'] ?? 0) + 1;

        if (currentScore >= 100) {
          // Reset current score but keep adding to totalScore
          await userRef.update({'score': 0, 'totalScore': totalScore});
          _showCompletedPopup(context, isAchievement: true);
        } else {
          // Update both scores
          await userRef.update({
            'score': currentScore,
            'totalScore': totalScore,
          });
          _showCompletedPopup(context);
        }
      }
    } catch (e) {
      print('Error updating task status: $e');
    }
  }

  void _setupTasksStream() {
    final user = _auth.currentUser;
    if (user != null) {
      _tasksStream =
          FirebaseFirestore.instance
              .collection('tasks')
              .where('userId', isEqualTo: user.uid)
              .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: SlidableAutoCloseBehavior(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 24.0,
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${getTodaysName().toUpperCase()}, ${DateTime.now().day}",
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
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
                    // Updated Progress Container
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('tasks')
                          .where('userId', isEqualTo: _auth.currentUser?.uid)
                          .snapshots(),
                      builder: (context, tasksSnapshot) {
                        if (!tasksSnapshot.hasData) {
                          return const SizedBox.shrink();
                        }

                        final completedTasks = tasksSnapshot.data!.docs
                            .where((doc) => (doc.data() as Map<String, dynamic>)['status'] == 'completed')
                            .length;
                        final totalTasks = tasksSnapshot.data!.docs.length;

                        return Container(
                          height: 120,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD600),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(_auth.currentUser?.uid)
                                        .snapshots(),
                                    builder: (context, userSnapshot) {
                                      // Print entire user data for debugging
                                      print('User Data: ${userSnapshot.data?.data()}');
                                      
                                      if (!userSnapshot.hasData) {
                                        print('No user data available');
                                        return Container(
                                          width: 45,
                                          height: 45,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Color(0xFFFAD107),
                                            ),
                                          ),
                                        );
                                      }
                                      
                                      final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
                                      print('Raw userData: $userData');
                                      
                                      // Try to get profileImage with different cases
                                      final profileImage = userData?['profileImage'] ?? 
                                                         userData?['ProfileImage'] ?? 
                                                         userData?['profile_image'] ?? 
                                                         userData?['profile_Image'];
                                      
                                      print('Profile Image URL found: $profileImage');
                                      
                                      return Container(
                                        width: 45,
                                        height: 45,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: ClipOval(
                                          child: profileImage != null
                                              ? Image.network(
                                                  profileImage,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    print('Error loading image: $error');
                                                    print('Stack trace: $stackTrace');
                                                    return const Icon(
                                                      Icons.person,
                                                      color: Color(0xFFFAD107),
                                                      size: 30,
                                                    );
                                                  },
                                                  loadingBuilder: (context, child, loadingProgress) {
                                                    if (loadingProgress == null) {
                                                      print('Image loaded successfully');
                                                      return child;
                                                    }
                                                    print('Loading progress: ${loadingProgress.expectedTotalBytes}');
                                                    return const Center(
                                                      child: CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Color(0xFFFAD107),
                                                      ),
                                                    );
                                                  },
                                                )
                                              : const Icon(
                                                  Icons.person,
                                                  color: Color(0xFFFAD107),
                                                  size: 30,
                                                ),
                                        ),
                                      );
                                    },
                                  ),
                                  const SizedBox(width: 12),
                                  StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(_auth.currentUser?.uid)
                                        .snapshots(),
                                    builder: (context, userSnapshot) {
                                      if (!userSnapshot.hasData) {
                                        return const Text('Loading...');
                                      }
                                      final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
                                      final name = userData?['name'] ?? 'Foulen ben foulen';
                                      return Text(
                                        name,
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: totalTasks > 0 ? completedTasks / totalTasks : 0,
                                      backgroundColor: Colors.white,
                                      valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                                      minHeight: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '$completedTasks/$totalTasks tasks done',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    Text(
                          "My tasks",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                    ),
                    const SizedBox(height: 16),
                    StreamBuilder<QuerySnapshot>(
                      stream: _tasksStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Text(
                              'Error: ${snapshot.error}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Stack(
                            children: [
                              // Background ghosts
                              Positioned(
                                top: 120,
                                right: 20,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Image.asset('assets/ghost1.png',
                                      width: 40, height: 40),
                                ),
                              ),
                              Positioned(
                                top: 150,
                                left: 40,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Image.asset('assets/ghost2.png',
                                      width: 35, height: 35),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                left: 60,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Image.asset('assets/ghost3.png',
                                      width: 35, height: 35),
                                ),
                              ),
                              // Additional ghost images
                              Positioned(
                                top: 200,
                                right: 60,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Image.asset('assets/ghost1.png',
                                      width: 40, height: 40),
                                ),
                              ),
                              Positioned(
                                top: 250,
                                left: 80,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Image.asset('assets/ghost2.png',
                                      width: 35, height: 35),
                                ),
                              ),
                              Positioned(
                                top: 100,
                                left: 100,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Image.asset('assets/ghost3.png',
                                      width: 35, height: 35),
                                ),
                              ),
                              // Centered text
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    'No tasks left',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        tasks =
                            snapshot.data!.docs
                                .map((doc) => Task.fromFirestore(doc))
                                .where(
                                  (task) =>
                                      task.status.toLowerCase() != 'completed',
                                )
                                .toList();

                        // Check if all tasks are completed
                        if (tasks.isEmpty) {
                          return Stack(
                            children: [
                              // Background ghosts
                              Positioned(
                                top: 120,
                                right: 20,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Image.asset('assets/ghost1.png',
                                      width: 40, height: 40),
                                ),
                              ),
                              Positioned(
                                top: 150,
                                left: 40,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Image.asset('assets/ghost2.png',
                                      width: 35, height: 35),
                                ),
                              ),
                              Positioned(
                                top: 20,
                                left: 60,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Image.asset('assets/ghost3.png',
                                      width: 35, height: 35),
                                ),
                              ),
                              // Additional ghost images
                              Positioned(
                                top: 200,
                                right: 60,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Image.asset('assets/ghost1.png',
                                      width: 40, height: 40),
                                ),
                              ),
                              Positioned(
                                top: 250,
                                left: 80,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Image.asset('assets/ghost2.png',
                                      width: 35, height: 35),
                                ),
                              ),
                              Positioned(
                                top: 100,
                                left: 100,
                                child: Opacity(
                                  opacity: 0.5,
                                  child: Image.asset('assets/ghost3.png',
                                      width: 35, height: 35),
                                ),
                              ),
                              // Centered text
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    'No tasks left',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }

                        return Column(
                          children:
                              tasks.map((task) {
                                // Get available status options (excluding current status)
                                List<Map<String, dynamic>>
                                getAvailableStatuses() {
                                  final allStatuses = [
                                    {
                                      'status': 'to-do',
                                      'color': const Color(0xFFFE0000),
                                      'icon': Icons.pending_actions,
                                      'display': 'To do',
                                    },
                                    {
                                      'status': 'in-progress',
                                      'color': const Color(0xFF00CCFF),
                                      'icon': Icons.trending_up,
                                      'display': 'In progress',
                                    },
                                    {
                                      'status': 'completed',
                                      'color': const Color(0xFF00CD06),
                                      'icon': Icons.check_circle,
                                      'display': 'Completed',
                                    },
                                  ];
                                  // Filter out current status using lowercase comparison
                                  return allStatuses
                                      .where(
                                        (s) =>
                                            s['status'] !=
                                            task.status.toLowerCase(),
                                      )
                                      .toList();
                                }

                                final availableStatuses =
                                    getAvailableStatuses();

                                // Find the document that matches this task
                                final taskDoc = snapshot.data!.docs.firstWhere((
                                  doc,
                                ) {
                                  final data =
                                      doc.data() as Map<String, dynamic>;
                                  return data['title'] == task.title &&
                                      data['description'] == task.description &&
                                      data['userId'] == task.userId;
                                });

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
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                if (availableStatuses.length >
                                                    0)
                                                  Container(
                                                    width: 120,
                                                    height: 40,
                                                    margin:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      color:
                                                          availableStatuses[0]['color'],
                                                    ),
                                                    child: CustomSlidableAction(
                                                      onPressed: (
                                                        context,
                                                      ) async {
                                                        final newStatus =
                                                            availableStatuses[0]['status'];
                                                        await _updateTaskStatus(
                                                          taskDoc.id,
                                                          newStatus,
                                                        );

                                                        if (newStatus ==
                                                            'completed') {
                                                          _showCompletedPopup(
                                                            context,
                                                          );
                                                        }

                                                        Slidable.of(
                                                          context,
                                                        )?.close();
                                                      },
                                                      padding: EdgeInsets.zero,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      foregroundColor:
                                                          Colors.white,
                                                      child: Text(
                                                        availableStatuses[0]['display'],
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                if (availableStatuses.length >
                                                    1)
                                                  Container(
                                                    width: 120,
                                                    height: 40,
                                                    margin:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 4,
                                                        ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                      color:
                                                          availableStatuses[1]['color'],
                                                    ),
                                                    child: CustomSlidableAction(
                                                      onPressed: (
                                                        context,
                                                      ) async {
                                                        final newStatus =
                                                            availableStatuses[1]['status'];
                                                        await _updateTaskStatus(
                                                          taskDoc.id,
                                                          newStatus,
                                                        );

                                                        if (newStatus ==
                                                            'completed') {
                                                          _showCompletedPopup(
                                                            context,
                                                          );
                                                        }
                                                        Slidable.of(
                                                          context,
                                                        )?.close();
                                                      },
                                                      padding: EdgeInsets.zero,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      foregroundColor:
                                                          Colors.white,
                                                      child: Text(
                                                        availableStatuses[1]['display'],
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                      description: task.description,
                                      status: task.status,
                                      date: task.getFormattedDeadline(),
                                      color: task.color,
                                    ),
                                  ),
                                );
                              }).toList(),
                        );
                      },
                    ),
                  ],
                ),
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
    required String description,
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
            description,
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
  void _showCompletedPopup(BuildContext context, {bool isAchievement = false}) {
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
                  'assets/popup.png',
                  width: 320,
                  height: 170,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 5),
                Column(
                  children: [
                    Text(
                      isAchievement ? 'Congratulations!' : 'Task Completed',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: Color(0xFF182035),
                      ),
                    ),
                    Text(
                      isAchievement
                          ? 'You\'ve reached 100 points!'
                          : 'Great Job!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF606268),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      isAchievement
                          ? 'You\'ve earned:\n1 Day Off\n\$50 Bonus'
                          : 'You received 1 point.',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF606268),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
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

// Run this once to add totalScore to all existing users
Future<void> addTotalScoreField() async {
  final usersRef = FirebaseFirestore.instance.collection('users');
  final users = await usersRef.get();

  for (var user in users.docs) {
    await usersRef.doc(user.id).update({
      'totalScore': user.data()['score'] ?? 0,
    });
  }
}