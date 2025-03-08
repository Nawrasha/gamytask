import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main_employe.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Stream<QuerySnapshot>? _tasksStream;

  @override
  void initState() {
    super.initState();
    _setupTasksStream();
  }

  void _setupTasksStream() {
    final user = _auth.currentUser;
    if (user != null) {
      _tasksStream = FirebaseFirestore.instance
          .collection('tasks')
          .where('userId', isEqualTo: user.uid)
          .snapshots();
    }
  }

  Future<void> _updateTaskStatus(String taskId, String newStatus) async {
    try {
      await FirebaseFirestore.instance.collection('tasks').doc(taskId).update({
        'status': newStatus.toLowerCase().replaceAll(' ', '-'),
      });
      if (newStatus.toLowerCase() == 'completed') {
        _showCompletedPopup(context);
      }
    } catch (e) {
      print('Error updating task status: $e');
    }
  }

  // Method to show a popup when the status is completed
  void _showCompletedPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              24.0,
            ), // Set corner radius to 24
          ),
          child: Container(
            width: 340,
            height: 360,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(
                24.0,
              ), // Set corner radius to 24
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
                        fontSize: 18, // Font size 16
                        fontWeight: FontWeight.w500, // Medium weight
                        color: Color(0xFF606268), // Color for "Great Job!"
                      ),
                      textAlign: TextAlign.center, // Center align the text
                    ),

                    Text(
                      'You received 1 point.',
                      style: TextStyle(
                        fontSize: 18, // Font size 16
                        fontWeight: FontWeight.w500, // Medium weight
                        color: Color(
                          0xFF606268,
                        ), // Color for "You received 1 point."
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot>(
          stream: _tasksStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}', 
                style: const TextStyle(color: Colors.white)));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: Colors.white));
            }

            final tasks = snapshot.data?.docs ?? [];
            final completedTasks = tasks.where((doc) => 
              (doc.data() as Map<String, dynamic>)['status'] == 'completed').length;
            final inProgressTasks = tasks.where((doc) => 
              (doc.data() as Map<String, dynamic>)['status'] == 'in-progress').length;
            final totalTasks = tasks.length;

            return SlidableAutoCloseBehavior(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                physics: const BouncingScrollPhysics(),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "ALL MY TASKS",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      StatusIndicator(
                        color: const Color(0xFFFE0000),
                        text: "To Do",
                      ),
                      StatusIndicator(
                        color: const Color(0xFF00CCFF),
                        text: "In Progress",
                      ),
                      StatusIndicator(
                        color: const Color(0xFF00CD06),
                        text: "Completed",
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularPercentIndicator(
                          radius: 120.0,
                          lineWidth: 24.0,
                          percent: totalTasks > 0 ? 1.0 : 0.0,
                          progressColor: const Color(0xFFFE0000),
                          backgroundColor: Colors.transparent,
                          circularStrokeCap: CircularStrokeCap.round,
                          animation: true,
                          animationDuration: 1200,
                        ),
                        CircularPercentIndicator(
                          radius: 120.0,
                          lineWidth: 24.0,
                          percent: totalTasks > 0 ? (inProgressTasks + completedTasks) / totalTasks : 0.0,
                          progressColor: const Color(0xFF00CCFF),
                          backgroundColor: Colors.transparent,
                          circularStrokeCap: CircularStrokeCap.round,
                          animation: true,
                          animationDuration: 1200,
                        ),
                        CircularPercentIndicator(
                          radius: 120.0,
                          lineWidth: 24.0,
                          percent: totalTasks > 0 ? completedTasks / totalTasks : 0.0,
                          progressColor: const Color(0xFF00CD06),
                          backgroundColor: Colors.transparent,
                          circularStrokeCap: CircularStrokeCap.round,
                          animation: true,
                          animationDuration: 1200,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "$completedTasks/$totalTasks",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(
                              "Completed",
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "This month",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00CCFF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          MainScreenState? mainScreenState =
                              context.findAncestorStateOfType<MainScreenState>();
                          if (mainScreenState != null) {
                            mainScreenState.setState(() {
                              mainScreenState.selectedIndex = 2;
                            });
                          }
                        },
                        child: const Text(
                          "Leaderboard",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ...tasks.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final deadline = (data['deadline'] as Timestamp).toDate();
                    final formattedDeadline = '${deadline.day}/${deadline.month}/${deadline.year}';
                    return _buildTaskItem(
                      doc.id,
                      data['title'] ?? 'Untitled',
                      data['description'] ?? 'No description',
                      data['status'] ?? 'to-do',
                      _getStatusColor(data['status'] ?? 'to-do'),
                      formattedDeadline,
                    );
                  }).toList(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF00CD06);
      case 'in-progress':
        return const Color(0xFF00CCFF);
      default:
        return const Color(0xFFFE0000);
    }
  }

  Widget _buildTaskItem(
    String taskId,
    String title,
    String description,
    String status,
    Color color,
    String deadline,
  ) {
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
          .where((s) => s['status'] != status.toLowerCase())
          .toList();
    }

    final availableStatuses = getAvailableStatuses();
    final isCompleted = status.toLowerCase() == 'completed';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: isCompleted 
          ? _buildTaskContainer(title, description, status, color, deadline)
          : Slidable(
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
                          if (availableStatuses.length > 0) Container(
                            width: 120,
                            height: 40,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: availableStatuses[0]['color'],
                            ),
                            child: CustomSlidableAction(
                              onPressed: (context) async {
                                await _updateTaskStatus(
                                  taskId,
                                  availableStatuses[0]['status'],
                                );
                                Slidable.of(context)?.close();
                              },
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              child: Text(
                                availableStatuses[0]['display'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          if (availableStatuses.length > 1) Container(
                            width: 120,
                            height: 40,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: availableStatuses[1]['color'],
                            ),
                            child: CustomSlidableAction(
                              onPressed: (context) async {
                                await _updateTaskStatus(
                                  taskId,
                                  availableStatuses[1]['status'],
                                );
                                Slidable.of(context)?.close();
                              },
                              padding: EdgeInsets.zero,
                              backgroundColor: Colors.transparent,
                              foregroundColor: Colors.white,
                              child: Text(
                                availableStatuses[1]['display'],
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
              child: _buildTaskContainer(title, description, status, color, deadline),
            ),
    );
  }

  Widget _buildTaskContainer(
    String title,
    String description,
    String status,
    Color color,
    String deadline,
  ) {
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
                    deadline,
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
}

class StatusIndicator extends StatelessWidget {
  final Color color;
  final String text;

  const StatusIndicator({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 5),
        Text(text, style: TextStyle(color: Colors.white)),
      ],
    );
  }
}
