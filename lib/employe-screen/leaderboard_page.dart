import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  bool _isMonthlySelected = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> _fetchLeaderboardData() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return [];

      // Get current user's data to get their teamID
      final currentUserDoc =
          await _firestore.collection('users').doc(currentUser.uid).get();

      if (!currentUserDoc.exists) return [];

      final currentUserData = currentUserDoc.data() as Map<String, dynamic>;
      final userTeamID = currentUserData['teamID'];

      // Get all users with the same teamID
      final QuerySnapshot teamUsersSnapshot = await _firestore
          .collection('users')
          .where('teamID', isEqualTo: userTeamID)
          .where('role', isEqualTo: 'employee')
          .get();

      List<Map<String, dynamic>> users =
          teamUsersSnapshot.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            // Make sure totalScore is always >= score
            int currentScore = data['score'] ?? 0;
            int totalScore = data['totalScore'] ?? 0;
            if (totalScore < currentScore) {
              totalScore = currentScore;
            }

            return {
              'id': doc.id,
              'name': data['name'] ?? 'Unknown',
              'score': currentScore,
              'totalScore': totalScore,
              'profileImage': data['profileImage'] ?? '',
            };
          }).toList();

      // Sort based on selected view
      users.sort((a, b) {
        if (_isMonthlySelected) {
          return (b['score'] as int).compareTo(a['score'] as int);
        } else {
          return (b['totalScore'] as int).compareTo(a['totalScore'] as int);
        }
      });

      print('Found ${users.length} users in team');
      return users;
    } catch (e) {
      print('Detailed error in _fetchLeaderboardData: $e');
      // Return current user's data as fallback
      try {
        final currentUser = _auth.currentUser;
        if (currentUser == null) return [];

        final userDoc =
            await _firestore.collection('users').doc(currentUser.uid).get();

        if (!userDoc.exists) return [];

        final userData = userDoc.data() as Map<String, dynamic>;
        int currentScore = userData['score'] ?? 0;
        int totalScore = userData['totalScore'] ?? 0;
        if (totalScore < currentScore) {
          totalScore = currentScore;
        }

        return [
          {
            'id': currentUser.uid,
            'name': userData['name'] ?? 'Unknown',
            'score': currentScore,
            'totalScore': totalScore,
            'profileImage': userData['profileImage'] ?? '',
          },
        ];
      } catch (e) {
        print('Error getting current user data: $e');
        return [];
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Leaderboard",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          return Future.delayed(Duration(seconds: 1));
        },
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Toggle buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildToggleButton("Monthly", _isMonthlySelected, () {
                    setState(() => _isMonthlySelected = true);
                  }),
                  const SizedBox(width: 12),
                  _buildToggleButton("All Time", !_isMonthlySelected, () {
                    setState(() => _isMonthlySelected = false);
                  }),
                ],
              ),
              const SizedBox(height: 24),
              // Podium image
              Container(
                width: double.infinity,
                height: 220,
                color: Colors.black,
                child: Center(
                  child: Image.asset(
                    'assets/laderboardimg.png',
                    width: MediaQuery.of(context).size.width * 0.9,
                    height: 220,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          'Image not found',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              ),
              // Leaderboard list
              FutureBuilder<List<Map<String, dynamic>>>(
                future: _fetchLeaderboardData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(
                              'Error loading leaderboard',
                              style: TextStyle(color: Colors.white),
                            ),
                            ElevatedButton(
                              onPressed: () => setState(() {}),
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final users = snapshot.data ?? [];

                  if (users.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'No rankings available yet',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return _buildLeaderboardEntry(
                        user['name'],
                        _isMonthlySelected
                            ? user['score'].toString()
                            : user['totalScore'].toString(),
                        (index + 1).toString(),
                        user['profileImage'] ?? "assets/avatar1.png",
                        MediaQuery.of(context).size.width * 0.9,
                      );
                    },
                  );
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFFFFD700) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildLeaderboardEntry(
    String name,
    String points,
    String rank,
    String avatarUrl,
    double width,
  ) {
    return Container(
      width: width,
      height: 92,
      margin: EdgeInsets.only(bottom: 16),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white, width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: Text(
              rank,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(width: 16),
          CircleAvatar(
            radius: 24,
            backgroundImage:
                avatarUrl.startsWith('http')
                    ? NetworkImage(avatarUrl)
                    : AssetImage(avatarUrl) as ImageProvider,
            onBackgroundImageError: (exception, stackTrace) {
              print('Error loading avatar: $exception');
            },
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "$points points",
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ],
            ),
          ),
          if (rank == "1" || rank == "2" || rank == "3")
            Image.asset(
              rank == "1"
                  ? "assets/goldmedal.png"
                  : rank == "2"
                  ? "assets/argentmedal.png"
                  : "assets/bronzemedal.png",
              width: 28,
              height: 28,
            )
          else
            SizedBox(width: 28),
        ],
      ),
    );
  }
}