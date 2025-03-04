import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'main.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  // Task data structure
  List<Map<String, dynamic>> tasks = [
    {
      'title': 'Create Detail Booking',
      'subtitle': 'PRODUCTIVITY',
      'status': 'Completed',
      'color': const Color(0xFF00CD06),
    },
    {
      'title': 'Revision Home Page',
      'subtitle': 'BANKING MOBILE APP',
      'status': 'To do',
      'color': const Color(0xFFFE0000),
    },
    {
      'title': 'Course Flutter',
      'subtitle': 'SKILL',
      'status': 'In progress',
      'color': const Color(0xFF00CCFF),
    },
  ];

  void _updateTaskStatus(int index, String newStatus) {
    setState(() {
      tasks[index]['status'] = newStatus;
      switch (newStatus) {
        case 'To do':
          tasks[index]['color'] = const Color(0xFFFE0000);
          break;
        case 'In progress':
          tasks[index]['color'] = const Color(0xFF00CCFF);
          break;
        case 'Completed':
          tasks[index]['color'] = const Color(0xFF00CD06);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SlidableAutoCloseBehavior(
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
                  StatusIndicator(color: const Color(0xFFFE0000), text: "To Do"),
                  StatusIndicator(color: const Color(0xFF00CCFF), text: "In Progress"),
                  StatusIndicator(color: const Color(0xFF00CD06), text: "Completed"),
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
                      percent: 1.0,
                      progressColor: const Color(0xFFFE0000),
                      backgroundColor: Colors.transparent,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animationDuration: 1200,
                    ),
                    CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 24.0,
                      percent: (tasks.where((t) => t['status'] == 'In progress').length + 
                              tasks.where((t) => t['status'] == 'Completed').length) / tasks.length,
                      progressColor: const Color(0xFF00CCFF),
                      backgroundColor: Colors.transparent,
                      circularStrokeCap: CircularStrokeCap.round,
                      animation: true,
                      animationDuration: 1200,
                    ),
                    CircularPercentIndicator(
                      radius: 120.0,
                      lineWidth: 24.0,
                      percent: tasks.where((t) => t['status'] == 'Completed').length / tasks.length,
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
                          "${tasks.where((t) => t['status'] == 'Completed').length}/${tasks.length}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          "Completed",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
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
                      MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();
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
              ...tasks.asMap().entries.map((entry) {
                final index = entry.key;
                final task = entry.value;
                return _buildTaskItem(
                  index,
                  task['title'],
                  task['subtitle'],
                  task['status'],
                  task['color'],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskItem(int index, String title, String subtitle, String status, Color color) {
    List<Map<String, dynamic>> getAvailableStatuses() {
      final allStatuses = [
        {
          'status': 'To do',
          'color': const Color(0xFFFE0000),
        },
        {
          'status': 'In progress',
          'color': const Color(0xFF00CCFF),
        },
        {
          'status': 'Completed',
          'color': const Color(0xFF00CD06),
        },
      ];
      return allStatuses.where((s) => s['status'] != status).toList();
    }

    final availableStatuses = getAvailableStatuses();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Slidable(
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
                          _updateTaskStatus(index, availableStatuses[0]['status']);
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
                          _updateTaskStatus(index, availableStatuses[1]['status']);
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
                subtitle,
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
                        "01/03/2025",
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
          width: 10,
          height: 10,
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