import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../authentification/signout.dart'; // Import the signout function

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Stream<DocumentSnapshot> _getUserStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots();
    }
    throw Exception('No user logged in');
  }

  Stream<QuerySnapshot> _getTasksStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return FirebaseFirestore.instance
          .collection('tasks')
          .where('userId', isEqualTo: user.uid)
          .snapshots();
    }
    throw Exception('No user logged in');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Profile', 
          style: TextStyle(
            fontSize: 28,
            color: Colors.white  // Add explicit white color
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _getUserStream(),
        builder: (context, userSnapshot) {
          if (userSnapshot.hasError) {
            return Center(
              child: Text('Error: ${userSnapshot.error}',
                  style: const TextStyle(color: Colors.white)),
            );
          }

          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = userSnapshot.data?.data() as Map<String, dynamic>?;
          if (userData == null) {
            return const Center(
              child: Text('No user data found',
                  style: TextStyle(color: Colors.white)),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: _getTasksStream(),
            builder: (context, taskSnapshot) {
              if (taskSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${taskSnapshot.error}',
                      style: const TextStyle(color: Colors.white)),
                );
              }

              if (taskSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final tasks = taskSnapshot.data?.docs ?? [];
              final notDoneTasks = tasks
                  .where((doc) {
                    final status = (doc.data() as Map<String, dynamic>)['status'];
                    return status == 'in-progress' || status == 'to-do';
                  })
                  .length;
              final completedTasks = tasks
                  .where((doc) =>
                      (doc.data() as Map<String, dynamic>)['status'] ==
                      'completed')
                  .length;

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
                  Positioned(
                    top: 0,
                    bottom: 500,
                    right: -20,
                    left: 0,
                    child: Opacity(
                      opacity: 1,
                      child:
                          Image.asset('assets/points.png', width: 100, height: 100),
                    ),
                  ),

                  // Main Content
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Profile Picture
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: userData['profileImage'] != null
                                    ? NetworkImage(userData['profileImage'])
                                    : const AssetImage('assets/Profilen.PNG')
                                        as ImageProvider,
                              ),
                              const SizedBox(height: 16),

                              // User Name
                              Text(
                                userData['name'] ?? 'No Name',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Username (now showing full email)
                              Text(
                                FirebaseAuth.instance.currentUser?.email ?? 'No email',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                              const SizedBox(height: 24),

                              // Statistics with Vertical Dashed Divider
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _buildStatistic(
                                    notDoneTasks.toString(),
                                    'Not Done',
                                    'assets/Time_Square.png',
                                  ),
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    height: 80,
                                    child:
                                        CustomPaint(painter: VerticalDashPainter()),
                                  ),
                                  const SizedBox(width: 15),
                                  _buildStatistic(
                                    completedTasks.toString(),
                                    'Total Done',
                                    'assets/Tick_Square.png',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),

                              // View My Team Button
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12.0,
                                  horizontal: 20.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0A0C16),
                                  borderRadius: BorderRadius.circular(16),
                                  border:
                                      Border.all(color: Colors.white, width: 1),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'VIEW MY TEAM',
                                      style: TextStyle(
                                        fontFamily: 'poppins',
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 100),

                              // Log Out Button
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: ElevatedButton(
                                  onPressed: () => signOut(context),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFE0000),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 32,
                                      vertical: 16,
                                    ),
                                  ),
                                  child: const Text(
                                    'Log Out',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  // Helper method to build a statistic widget
  Widget _buildStatistic(String value, String label, String iconPath) {
    return Column(
      children: [
        Image.asset(iconPath, width: 30, height: 30),
        const SizedBox(height: 1),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24, 
            fontWeight: FontWeight.bold,
            color: Colors.white,  // Add white color
          ),
        ),
        const SizedBox(height: 0),
        Text(
          label, 
          style: const TextStyle(
            fontSize: 16, 
            color: Colors.grey
          )
        ),
      ],
    );
  }
}

// Custom painter for the vertical dashed line
class VerticalDashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double dashHeight = 5, dashSpace = 3;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(
          Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
