import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TaskCreate extends StatefulWidget {
  const TaskCreate({Key? key}) : super(key: key);

  @override
  _TaskCreateState createState() => _TaskCreateState();
}

class _TaskCreateState extends State<TaskCreate> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  String? _selectedMemberId;
  List<Map<String, dynamic>> _teamMembers = [];

  @override
  void initState() {
    super.initState();
    _fetchTeamMembers();
  }

  Future<void> _fetchTeamMembers() async {
    try {
      String? userID = FirebaseAuth.instance.currentUser?.uid;
      if (userID == null) {
        print("❌ Error: No user logged in!");
        return;
      }

      print("✅ Current User UID: $userID"); // Log user UID for debugging

      final teamSnapshot =
          await FirebaseFirestore.instance
              .collection('teams')
              .where('managerId', isEqualTo: userID)
              .limit(1)
              .get();

      if (teamSnapshot.docs.isEmpty) {
        print("❌ No team found where user is the manager.");
        return;
      }

      var teamDoc = teamSnapshot.docs.first;
      List<String> members = List<String>.from(teamDoc['members']);
      print("👥 Members: $members"); // Log team members for debugging

      List<Map<String, dynamic>> fetchedMembers = [];
      for (String memberID in members) {
        final userSnapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .doc(memberID)
                .get();

        if (userSnapshot.exists) {
          fetchedMembers.add({
            'name': userSnapshot['name'],
            'image': 'assets/default_image.png',
            'userId': memberID,
          });
        } else {
          print("❌ No user found with UID: $memberID");
        }
      }

      setState(() {
        _teamMembers = fetchedMembers;
        _selectedMemberId =
            fetchedMembers.isNotEmpty ? fetchedMembers[0]['userId'] : null;
      });
    } catch (e) {
      print("❌ Error fetching employees: $e");
    }
  }

  void _pickDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _createTask() async {
    if (_formKey.currentState!.validate() &&
        _selectedMemberId != null &&
        _selectedDate != null) {
      Timestamp createdAt = Timestamp.now();
      Timestamp deadline = Timestamp.fromDate(_selectedDate!);

      try {
        await FirebaseFirestore.instance.collection('tasks').add({
          'title': _titleController.text,
          'description': _descriptionController.text,
          'userId': _selectedMemberId,
          'status': 'to-do',
          'deadline': deadline,
          'createdAt': createdAt,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task successfully created!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context);
      } catch (e) {
        print('❌ Error creating task: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create task. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields correctly.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Select a Team Member:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 80,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children:
                      _teamMembers.map((member) {
                        bool isSelected = _selectedMemberId == member['userId'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedMemberId = member['userId'];
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage(
                                        member['image'],
                                      ),
                                      radius: 30,
                                    ),
                                    if (isSelected)
                                      Container(
                                        width: 60,
                                        height: 60,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.yellow.withOpacity(0.6),
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  member['name'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                title: const Text('Deadline'),
                subtitle: Text(
                  _selectedDate != null
                      ? DateFormat('MMMM dd, yyyy').format(_selectedDate!)
                      : 'Select a date',
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () => _pickDate(context),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _createTask,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
