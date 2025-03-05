import 'package:flutter/material.dart';
import 'TaskCard.dart';


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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 0, 0, 0), // Background color: #0A0C16
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child:Center(
                        child:Text(
                          getTodaysName(),
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

                const SizedBox(height: 20),

                // Task List
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("This month", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                    ),
                    onPressed: () {
                      
                        });
                      }
                    },
                    child: Text("viw all", style: TextStyle(color: Colors.white)),
                  ),
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
}*/
Widget _buildDashboard() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey, // Grey contour for the border
          width: 2,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          // User Info and Progress
          Expanded(
            child:Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 0, 0, 0), // Couleur de fond de l'icône
                    shape: BoxShape.circle, // Forme circulaire
                    border: Border.all(
                      color: Colors.white, // Couleur de la bordure
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '1',
                      style: TextStyle(
                        color: const Color.fromARGB(255, 255, 255, 255),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
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
          ),
          const SizedBox(height: 16),
                LinearProgressIndicator(
                  value: 12 / 15,
                  backgroundColor: Colors.grey[800],
                  color: Colors.yellow,
                ),
        ],
      ),
    );
  }
}

  

