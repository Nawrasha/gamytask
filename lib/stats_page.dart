import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'main.dart';
import 'TaskCard.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  StatusIndicator(color: Colors.red, text: "To Do"),
                  StatusIndicator(color: Colors.blue, text: "In Progress"),
                  StatusIndicator(color: Colors.green, text: "Completed"),
                ],
              ),
              SizedBox(height: 40),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 33.0,
                      percent: 1.0,
                      progressColor: Colors.red,
                      backgroundColor: Colors.transparent,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animationDuration: 1200,
                    ),
                    CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 33.0,
                      percent: (12 + 1) / 15,
                      progressColor: Colors.blue,
                      backgroundColor: Colors.transparent,
                      circularStrokeCap: CircularStrokeCap.round,   
                      animation: true,
                      animationDuration: 1200,
                    ),
                    CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 33.0,
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("This month", style: TextStyle(color: Colors.white, fontSize: 18)),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                    ),
                    onPressed: () {
                      MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();
                      if (mainScreenState != null) {
                        mainScreenState.setState(() {
                          mainScreenState.selectedIndex = 2;
                        });
                      }
                    },
                    child: Text("Leaderboard", style: TextStyle(color: Colors.white)),
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
    );
  }
}

class StatusIndicator extends StatelessWidget {
  final Color color;
  final String text;

  StatusIndicator({required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 5),
        Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
