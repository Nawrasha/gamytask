/*import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'main.dart';




class StatsPage extends StatelessWidget {
  const StatsPage({super.key});
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
                    lineWidth: 24.0,
                    percent: 1.0,
                    progressColor: Colors.red,
                    backgroundColor: Colors.transparent,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animationDuration: 1200,
                  ),
                  CircularPercentIndicator(
                    radius: 120.0,
                    lineWidth: 24.0,
                    percent: (12 + 1) / 15,
                    progressColor: Colors.blue,
                    backgroundColor: Colors.transparent,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animationDuration: 1200,
                  ),
                  CircularPercentIndicator(
                    radius: 120.0,
                    lineWidth: 24.0,
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
                    // Change _selectedIndex à 2 pour afficher LeaderboardPage
                    MainScreenState? mainScreenState = context.findAncestorStateOfType<MainScreenState>();
                    if (mainScreenState != null) {
                      mainScreenState.setState(() {
                        mainScreenState.selectedIndex = 2; // Index de la LeaderboardPage
                      });
                    }
                  },
                  child: Text("Leaderboard", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            SizedBox(height: 10),
            TaskCard(
              category: "PRODUCTIVITY",
              title: "Create Detail Booking",
              status: "Completed",
              color: Colors.green,
            ),
            TaskCard(
              category: "BANKING MOBILE APP",
              title: "Revision Home Page",
              status: "To do",
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

class StatusIndicator extends StatelessWidget {
  final Color color;
  final String text;

  StatusIndicator ({required this.color, required this.text});

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
}*/
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'main.dart';
class StatsPage extends StatelessWidget {
  const StatsPage({super.key});
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
                    lineWidth: 24.0,
                    percent: 1.0,
                    progressColor: Colors.red,
                    backgroundColor: Colors.transparent,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animationDuration: 1200,
                  ),
                  CircularPercentIndicator(
                    radius: 120.0,
                    lineWidth: 24.0,
                    percent: (12 + 1) / 15,
                    progressColor: Colors.blue,
                    backgroundColor: Colors.transparent,
                    circularStrokeCap: CircularStrokeCap.round,
                    animation: true,
                    animationDuration: 1200,
                  ),
                  CircularPercentIndicator(
                    radius: 120.0,
                    lineWidth: 24.0,
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

class TaskCard extends StatefulWidget {
  final String category;
  final String title;
  final Color initialColor;

  TaskCard({required this.category, required this.title, required this.initialColor});

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late Color _taskColor;
  bool _showOptions = false;
  final List<Color> _colors = [Colors.red, Colors.blue, Colors.green];
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    _taskColor = widget.initialColor;
  }

  void _changeColor(Color color) {
    setState(() {
      _taskColor = color;
      _showOptions = false;
      _offset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _showOptions = !_showOptions;
          _offset = _showOptions ? 50 : 0;
        });
      },
      child: Stack(
        children: [
          ClipRect(
            child: Transform.translate(
              offset: Offset(_offset, 0),
              child: Card(
                color: Colors.black,
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white54),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  title: Text(widget.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  subtitle: Text(widget.category, style: TextStyle(color: Colors.white54)),
                  trailing: Icon(Icons.circle, color: _taskColor, size: 30),
                ),
              ),
            ),
          ),
          if (_showOptions)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _colors
                    .where((color) => color != _taskColor)
                    .map((color) => IconButton(
                          icon: Icon(Icons.circle, color: color, size: 30),
                          onPressed: () => _changeColor(color),
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
