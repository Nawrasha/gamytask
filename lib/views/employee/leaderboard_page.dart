import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  bool _isMonthlySelected = true; // Par défaut, "Monthly" est sélectionné

  // Liste des participants pour "Monthly"
  final List<Map<String, dynamic>> _monthlyEntries = [
    {
      "name": "adem omri",
      "points": "2,569",
      "rank": "1",
      "avatar": "assets/avatar1.png",
      "badge": "gold"
    },
    {
      "name": "ECHEIKHROHOU",
      "points": "1,469",
      "rank": "2",
      "avatar": "assets/avatar2.png",
      "badge": "silver"
    },
    {
      "name": "LE BOSS ADAM",
      "points": "1,053",
      "rank": "3",
      "avatar": "assets/avatar3.png",
      "badge": "bronze"
    },
    {
      "name": "Madame cheikhrohou",
      "points": "590",
      "rank": "4",
      "avatar": "assets/avatar4.png",
      "badge": "none"
    },
  ];

  // Liste des participants pour "All Time"
  final List<Map<String, String>> _allTimeEntries = [
    {"name": "Si user", "points": "5,000 points", "rank": "1"},
    {"name": "user", "points": "20.60 points", "rank": "2"},
    {"name": "User le boss", "points": "2,053 points", "rank": "3"},
    {"name": "Madame user", "points": "1,690 points", "rank": "4"},
    {"name": "usegh", "points": "1,448 points", "rank": "5"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Leaderboard",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
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
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: _isMonthlySelected ? _monthlyEntries.length : _allTimeEntries.length,
              itemBuilder: (context, index) {
                final entry = _isMonthlySelected ? _monthlyEntries[index] : _allTimeEntries[index];
                return Center(
                  child: _buildLeaderboardEntry(
                    entry["name"]!,
                    entry["points"]!,
                    entry["rank"]!,
                    _isMonthlySelected ? entry["avatar"]! : "assets/avatar1.png",
                    MediaQuery.of(context).size.width * 0.9,
                  ),
                );
              },
            ),
          ],
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

  Widget _buildLeaderboardEntry(String name, String points, String rank, String avatar, double width) {
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
            backgroundImage: AssetImage(avatar),
            onBackgroundImageError: (exception, stackTrace) {
              // Handle avatar image error
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
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
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