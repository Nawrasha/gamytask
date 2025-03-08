import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'note_page.dart';

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

// Task model to manage task data
class Task {
  String title;
  String subtitle;
  String status;
  String date;
  Color color;
  String userImage;
  String userName;

  Task({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.date,
    required this.color,
    this.userImage = 'assets/default_user.png', // Provide default value
    this.userName = 'Unknown User', // Provide default value
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
      subtitle: 'PRODUCTIVITY',
      status: 'Completed',
      date: '01/03/2025',
      color: const Color(0xFF00CD06),
      userImage: 'assets/user1.png',
      userName: 'Adem omri',
    ),
    Task(
      title: 'Revision Home Page',
      subtitle: 'BANKING MOBILE APP',
      status: 'To do',
      date: '01/03/2025',
      color: const Color(0xFFFE0000),
      userImage: 'assets/user2.png',
      userName: 'ECHEIKHROHOU',
    ),
    Task(
      title: 'Course Flutter',
      subtitle: 'SKILL',
      status: 'In progress',
      date: '01/03/2025',
      color: const Color(0xFF00CCFF),
      userImage: 'assets/user2.png',
      userName: 'ECHEIKHROHOU',
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
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
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
            const Row(
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
              ],
            ),
            const SizedBox(height: 20),
            ...tasks.map((task) => _buildTaskCard(task)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard(Task task) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture and name
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(task.userImage),
                  radius: 16,
                  onBackgroundImageError: (exception, stackTrace) {
                    print('Error loading image: $exception');
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  task.userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          // Task card
          Container(
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
                  task.subtitle,
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
                          task.date,
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
        ],
      ),
    );
  }
}