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

      print("✅ Current User UID: $userID");

      final teamSnapshot = await FirebaseFirestore.instance
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
      print("👥 Members: $members");

      List<Map<String, dynamic>> fetchedMembers = [];
      for (String memberID in members) {
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(memberID)
            .get();

        if (userSnapshot.exists) {
          final userData = userSnapshot.data() as Map<String, dynamic>;
          fetchedMembers.add({
            'name': userData['name'] ?? 'No Name',
            'profileImage': userData['profileImage'],
            'userId': memberID,
          });
        } else {
          print("❌ No user found with UID: $memberID");
        }
      }

      setState(() {
        _teamMembers = fetchedMembers;
        _selectedMemberId = null;
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
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields correctly.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    if (_selectedMemberId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a team member.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a deadline.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Create Task', 
          style: TextStyle(
            fontFamily: 'arcade',
            fontSize: 28,
            color: Colors.white,
          )
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Task Name',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Select a Team Member:',
                  style: TextStyle(
                    fontSize: 16, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 90,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: _teamMembers.map((member) {
                      bool isSelected = _selectedMemberId == member['userId'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_selectedMemberId == member['userId']) {
                              _selectedMemberId = null;
                            } else {
                              _selectedMemberId = member['userId'];
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: Colors.grey[800],
                                    backgroundImage: member['profileImage'] != null && member['profileImage'].toString().isNotEmpty
                                        ? NetworkImage(member['profileImage'])
                                        : const AssetImage('assets/Profilen.PNG') as ImageProvider,
                                    onBackgroundImageError: (exception, stackTrace) {
                                      print('❌ Error loading profile image: $exception');
                                    },
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
                              SizedBox(
                                width: 60,
                                child: Text(
                                  member['name'],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
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
                  title: const Text(
                    'Deadline',
                    style: TextStyle(color: Colors.white),
                  ),
                  subtitle: Text(
                    _selectedDate != null
                        ? DateFormat('MMMM dd, yyyy').format(_selectedDate!)
                        : 'Select a date',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: const Icon(
                    Icons.calendar_today,
                    color: Colors.white,
                  ),
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
      ),
    );
  }
}
