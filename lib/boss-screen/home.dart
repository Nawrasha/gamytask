import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class TeamMember {
  final String id;
  final String name;
  final String? profileImage;
  final int tasksCompleted;
  final int totalTasks;

  TeamMember({
    required this.id,
    required this.name,
    required this.profileImage,
    required this.tasksCompleted,
    required this.totalTasks,
  });
}

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List<TeamMember> _teamMembers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTeamMembers();
  }

  Future<void> _fetchTeamMembers() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      // Fetch the team where the user is the manager
      final teamSnapshot = await FirebaseFirestore.instance
          .collection('teams')
          .where('managerId', isEqualTo: user.uid)
          .limit(1)
          .get();

      if (teamSnapshot.docs.isEmpty) return;

      final teamDoc = teamSnapshot.docs.first;
      final List<String> memberIds = List<String>.from(teamDoc['members'] ?? []);

      if (memberIds.isEmpty) return;

      // Bulk fetch users in one query
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: memberIds)
          .get();

      // Bulk fetch tasks in one query
      final tasksSnapshot = await FirebaseFirestore.instance
          .collection('tasks')
          .where('userId', whereIn: memberIds)
          .get();

      // Process users and tasks together
      List<TeamMember> fetchedMembers = usersSnapshot.docs.map((userDoc) {
        final userData = userDoc.data();
        final userId = userDoc.id;

        // Get user's tasks
        final userTasks = tasksSnapshot.docs.where((task) => task['userId'] == userId);
        final totalTasks = userTasks.length;
        final completedTasks = userTasks.where((task) => task['status'] == 'completed').length;

        return TeamMember(
          id: userId,
          name: userData['name'] ?? 'No Name',
          profileImage: userData['profileImage'],
          tasksCompleted: completedTasks,
          totalTasks: totalTasks,
        );
      }).toList();

      setState(() {
        _teamMembers = fetchedMembers;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching team members: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final dayName = DateFormat('EEEE').format(now).toUpperCase();
    final day = DateFormat('d').format(now);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Text(
                  '$dayName, $day',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Your team members:',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                : Column(
                    children: _teamMembers.isEmpty
                        ? [
                            const Center(
                              child: Text(
                                'No team members found',
                                style: TextStyle(color: Colors.white),
                              ),
                            )
                          ]
                        : _teamMembers
                            .map((member) => _buildTeamMemberCard(member))
                            .toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMemberCard(TeamMember member) {
    return Container(
      width: double.infinity,
      height: 100,
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white,
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey[800],
            backgroundImage: member.profileImage != null
                ? NetworkImage(member.profileImage!)
                : const AssetImage('assets/Profilen.PNG') as ImageProvider,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  member.name.toLowerCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Stack(
                  children: [
                    Container(
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    FractionallySizedBox(
                      widthFactor: member.totalTasks > 0
                          ? member.tasksCompleted / member.totalTasks
                          : 0.0,
                      child: Container(
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD600),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${member.tasksCompleted}/${member.totalTasks} tasks done',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
