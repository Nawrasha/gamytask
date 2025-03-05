import 'package:flutter/material.dart';
import 'TaskCard.dart';
import 'main.dart';

class TaskManagerScreen extends StatelessWidget {
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
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 0, 0), // Background color: #0A0C16
        ),
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
                      ),
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
                SizedBox(height: 10),
                TaskCard(category: "PRODUCTIVITY", title: "Create Detail Booking", initialColor: Colors.green),
                TaskCard(category: "BANKING MOBILE APP", title: "Revision Home Page", initialColor: Colors.red),
                TaskCard(category: "SKILL", title: "Course flutter", initialColor: Colors.blue),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget for the Dashboard
  /*Widget _buildDashboard() {
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
}
