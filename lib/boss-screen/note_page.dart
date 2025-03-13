import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  _NotePageState createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  String _currentDate = '';
  TextEditingController _noteController = TextEditingController();
  bool _isSaving = false;

  // List to hold notes fetched from Firestore
  List<Map<String, dynamic>> _notes = [];

  @override
  void initState() {
    super.initState();
    _updateDate();
    _fetchNotes(); // Fetch notes when the page loads
  }

  void _updateDate() {
    final now = DateTime.now();
    setState(() {
      _currentDate = '${_getMonthName(now.month)}, ${now.day}';
    });
  }

  String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  // Fetch notes from Firestore
  void _fetchNotes() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final querySnapshot =
            await FirebaseFirestore.instance
                .collection('notes')
                .where('userId', isEqualTo: user.uid)
                .orderBy('timestamp', descending: true)
                .get();
        setState(() {
          _notes =
              querySnapshot.docs
                  .map(
                    (doc) => {
                      'id': doc.id, // Document ID for editing
                      'content': doc['content'],
                      'timestamp': doc['timestamp'],
                    },
                  )
                  .toList();
        });
      }
    } catch (e) {
      print('Error fetching notes: $e');
    }
  }

  // Save the note to Firestore
  void _saveNote() async {
    if (_noteController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a note!')));
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw 'User not authenticated';
      }

      // Save note to Firestore
      await FirebaseFirestore.instance.collection('notes').add({
        'userId': user.uid,
        'content': _noteController.text,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Clear the text field and stop the saving process
      setState(() {
        _noteController.clear();
        _isSaving = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Note saved successfully!')));
      _fetchNotes(); // Refresh the notes list
    } catch (e) {
      setState(() {
        _isSaving = false;
      });
      print("Error saving note: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to save note: $e')));
    }
  }

  // Edit note functionality
  void _editNote(String noteId, String currentContent) async {
    TextEditingController _editController = TextEditingController(
      text: currentContent,
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: TextField(
            controller: _editController,
            maxLines: null,
            decoration: const InputDecoration(hintText: "Edit your note..."),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  if (_editController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Note cannot be empty!')),
                    );
                    return;
                  }

                  await FirebaseFirestore.instance
                      .collection('notes')
                      .doc(noteId)
                      .update({
                        'content': _editController.text,
                        'timestamp': FieldValue.serverTimestamp(),
                      });

                  Navigator.of(context).pop();
                  _fetchNotes(); // Refresh notes
                } catch (e) {
                  print('Error updating note: $e');
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  "Espace privé",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                _currentDate,
                style: const TextStyle(color: Colors.white54, fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            // Input field for writing notes
            TextField(
              controller: _noteController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: 'Écrivez vos notes ici...',
                hintStyle: TextStyle(color: Colors.white54),
                border: InputBorder.none,
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 16),
            // Save Button
            ElevatedButton(
              onPressed: _isSaving ? null : _saveNote,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFE0000),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child:
                  _isSaving
                      ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                      : const Text(
                        'Save Note',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
            ),
            SizedBox(height: 20),
            // Display Saved Notes
            Expanded(
              child:
                  _notes.isEmpty
                      ? const Center(
                        child: Text(
                          "No Notes Found",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      )
                      : ListView.builder(
                        itemCount: _notes.length,
                        itemBuilder: (context, index) {
                          final note = _notes[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8.0),
                            color: Colors.grey[800],
                            child: ListTile(
                              title: Text(
                                note['content'] ?? 'No content',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              subtitle: Text(
                                note['timestamp'] != null
                                    ? 'Posted on: ${note['timestamp'].toDate()}'
                                    : '',
                                style: const TextStyle(color: Colors.white54),
                              ),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  _editNote(note['id'], note['content']);
                                },
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
