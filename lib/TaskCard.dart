import 'package:flutter/material.dart';
class TaskCard extends StatefulWidget {
  final String category;
  final String title;
  final Color initialColor;

  TaskCard({required this.category, required this.title, required this.initialColor});

  @override
  TaskCardState createState() => TaskCardState();
}

class TaskCardState extends State<TaskCard> {
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
          _offset = _showOptions ? 50: 0;
        });
      },
      child: Stack(
        children: [
          ClipRect(
            child: Transform.translate(
              offset: Offset(_offset, 0),
              child: Card(
                elevation: 20,
                color: const Color.fromARGB(255, 0, 0, 0),
                shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.white54),
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(bottom: 20),
                child: Container(
                  height: 120, // Augmentez la hauteur de la carte ici
                  width: double.infinity, // Prend toute la largeur disponible
                  //padding: EdgeInsets.all(16), // Ajoutez un padding si nécessaire 
                  child: ListTile(
                    title: Text(widget.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    subtitle: Text(widget.category, style: TextStyle(color: Colors.white54)),
                    trailing: Icon(Icons.circle, color: _taskColor, size: 30),
                  ),
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