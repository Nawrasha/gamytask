import 'package:flutter/material.dart';
import 'package:gamytask_app/main.dart';
import 'package:gamytask_app/task_manager_screen.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskScreen(),
    );
  }
}

class TaskScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
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
            Center(
              child: Transform.translate(
                offset: Offset(-80, 20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 100.0,
                      lineWidth: 16.0,
                      percent: 1.0,
                      progressColor: Colors.red,
                      backgroundColor: Colors.transparent,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animationDuration: 1200,
                    ),
                    CircularPercentIndicator(
                      radius: 100.0,
                      lineWidth: 16.0,
                      percent: (12 + 1) / 15,
                      progressColor: Colors.blue,
                      backgroundColor: Colors.transparent,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animationDuration: 1200,
                    ),
                    CircularPercentIndicator(
                      radius: 100.0,
                      lineWidth: 16.0,
                      percent: 12 / 15,
                      progressColor: Colors.green,
                      backgroundColor: Colors.transparent,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animationDuration: 1200,
                    ),
                    Text(
                      "12/15\nCompleted",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: Transform.translate(
                offset: Offset(100, -100),
                child: Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.yellow,
                        shape: BoxShape.rectangle,
                      ),
                      child: Center(
                        child: Text(
                          "1",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Au classement de la team",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("This month", style: TextStyle(color: Colors.white, fontSize: 18)),
            SizedBox(height: 10),
            TaskCard(
              category: "PRODUCTIVITY",
              title: "Create Detail Booking",
              status: "Completed",
              color: Colors.green,
            ),
            TaskCard(
              category: "BANKING MOBILE",
              title: "ReVision Home Page",
              status: "Todo",
              color: Colors.red,
            ),
            TaskCard(
              category: "SKILL",
              title: "Course flutter",
              status: "In progress",
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String category;
  final String title;
  final String status;
  final Color color;

  TaskCard({required this.category, required this.title, required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white54),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        title: Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        subtitle: Text(category, style: TextStyle(color: Colors.white54)),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(status, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}