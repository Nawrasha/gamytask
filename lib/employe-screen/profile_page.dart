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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: Center(
                child: const Text(
                  'Profile', 
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white  // Add explicit white color
                  ),
                ),
              ),
            ),
          ],
        ),
        centerTitle: false,
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
                                backgroundColor: Colors.grey[800],
                                child: userData['profileImage'] != null
                                    ? CircleAvatar(
                                        radius: 50,
                                        backgroundImage: NetworkImage(userData['profileImage']),
                                      )
                                    : CircleAvatar(
                                        radius: 50,
                                        backgroundImage: const NetworkImage(
                                          'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png'
                                        ),
                                      ),
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
                              GestureDetector(
                                onTap: () async {
                                  final teamMembers = await _getTeamMembers(userData['teamID']);
                                  showModalBottomSheet(
                                    context: context,
                                    backgroundColor: Colors.transparent,
                                    builder: (context) => Container(
                                      height: MediaQuery.of(context).size.height * 0.7,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFF1E1E1E),
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20),
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          // Handle bar
                                          Container(
                                            margin: const EdgeInsets.only(top: 8),
                                            width: 40,
                                            height: 4,
                                            decoration: BoxDecoration(
                                              color: Colors.grey[600],
                                              borderRadius: BorderRadius.circular(2),
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Text(
                                              'Team Members',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: teamMembers.length,
                                              padding: const EdgeInsets.symmetric(horizontal: 16),
                                              itemBuilder: (context, index) {
                                                final member = teamMembers[index];
                                                return Container(
                                                  margin: const EdgeInsets.only(bottom: 12),
                                                  padding: const EdgeInsets.all(12),
                                                  decoration: BoxDecoration(
                                                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 25,
                                                        backgroundImage: NetworkImage(member['profileImage']),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              member['name'],
                                                              style: const TextStyle(
                                                                color: Colors.white,
                                                                fontSize: 16,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            ),
                                                            Text(
                                                              member['role'],
                                                              style: TextStyle(
                                                                color: Colors.grey[400],
                                                                fontSize: 14,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12.0,
                                    horizontal: 20.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF0A0C16),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.white, width: 1),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

  // Add this method to fetch team members
  Future<List<Map<String, dynamic>>> _getTeamMembers(String teamId) async {
    try {
      final QuerySnapshot teamMembers = await FirebaseFirestore.instance
          .collection('users')
          .where('teamID', isEqualTo: teamId)
          .get();

      // Create a list of team members
      List<Map<String, dynamic>> members = teamMembers.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'name': data['name'] ?? 'Unknown',
          'profileImage': data['profileImage'] ?? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png',
          'role': data['role'] ?? 'Unknown',
          'isBoss': data['role'] == 'boss', // Check if this member is the boss
        };
      }).toList();

      // Sort the members to place the boss first
      members.sort((a, b) {
        if (a['isBoss'] == true && b['isBoss'] == false) {
          return -1; // a comes before b
        } else if (a['isBoss'] == false && b['isBoss'] == true) {
          return 1; // b comes before a
        }
        return 0; // maintain original order
      });

      return members;
    } catch (e) {
      print('Error fetching team members: $e');
      return [];
    }
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
