/*import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            // Titre "Leaderboard" centré
            Text(
              "Leaderboard",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            
            // Ligne avec deux containers (Monthly et All Time)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container pour "Monthly"
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 55, vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 215, 201, 66), // Couleur de fond
                    borderRadius: BorderRadius.circular(20), // Bords arrondis
                  ),
                  child: Text(
                    "Monthly",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
                // Container pour "All Time"
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 55, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey[800], // Couleur de fond
                    borderRadius: BorderRadius.circular(20), // Bords arrondis
                  ),
                  child: Text(
                    "All Time",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            //SizedBox(height: 5),
            // Liste des participants
            Expanded(
              child: ListView(
              padding: EdgeInsets.symmetric(vertical: 19.0),               
              children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 10), // Espace en bas de la Card
                    child: _buildLeaderboardEntry("St cheikhrouhou", "2,500 points"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10), // Espace en bas de la Card
                    child: _buildLeaderboardEntry("ECHEIKHROUHOU", "14.60 points"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10), // Espace en bas de la Card
                    child: _buildLeaderboardEntry("LE BOSS ADAM", "1,053 points"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10), // Espace en bas de la Card
                    child: _buildLeaderboardEntry("Madame cheikhrouhou", "690 points"),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10), // Espace en bas de la Card
                    child: _buildLeaderboardEntry("Cheikh", "448 points"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLeaderboardEntry(String name, String points) {
    return Card(
      color: Colors.grey[900],
      
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 27, horizontal: 16),
        title: Text(
          name,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Text(
          points,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  _LeaderboardPageState createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  bool _isMonthlySelected = true; // Par défaut, "Monthly" est sélectionné

  // Liste des participants pour "Monthly"
  final List<Map<String, String>> _monthlyEntries = [
    {"name": "Si user ", "points": "2,569 points", "rank": "1"},
    {"name": "user", "points": "14.60 points", "rank": "2"},
    {"name": "User le boss", "points": "1,053 points", "rank": "3"},
    {"name": "Madame user", "points": "690 points", "rank": "4"},
    {"name": "usegh", "points": "448 points", "rank": "5"},
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            // Titre "Leaderboard" centré
            Text(
              "Leaderboard",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Ligne avec deux containers (Monthly et All Time)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Container pour "Monthly"
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isMonthlySelected = true; // Sélectionner "Monthly"
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 58, vertical: 11),
                    decoration: BoxDecoration(
                      color: _isMonthlySelected ? const Color.fromARGB(255, 214, 195, 20) : const Color.fromARGB(255, 0, 0, 0), // Couleur dynamique
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "Monthly",
                      style: TextStyle(
                        color: _isMonthlySelected ? const Color.fromARGB(255, 255, 255, 255) : Colors.white, // Couleur du texte dynamique
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                // Container pour "All Time"
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isMonthlySelected = false; // Sélectionner "All Time"
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 58, vertical: 11),
                    decoration: BoxDecoration(
                      color: _isMonthlySelected ? const Color.fromARGB(255, 0, 0, 0) :const Color.fromARGB(255, 214, 195, 20), // Couleur dynamique
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "All Time",
                      style: TextStyle(
                        color: _isMonthlySelected ? Colors.white : const Color.fromARGB(255, 255, 255, 255), // Couleur du texte dynamique
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            // Liste des participants
            Expanded(
              child: ListView(
                
                padding: EdgeInsets.zero,
                children: _isMonthlySelected
                    ? _monthlyEntries.map((entry) => _buildLeaderboardEntry(entry["name"]!, entry["points"]!, entry["rank"]!)).toList()
                    : _allTimeEntries.map((entry) => _buildLeaderboardEntry(entry["name"]!, entry["points"]!, entry["rank"]!)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildLeaderboardEntry(String name, String points, String rank) {
  return Container(
    height: 120, // Hauteur de la carte augmentée
    width: double.infinity, // Largeur de la carte (occupe toute la largeur disponible)
    child: Card(
      color: const Color.fromARGB(255, 0, 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
        side: BorderSide(
          color: Colors.white, // Couleur de la bordure
          width: 1, // Épaisseur de la bordure
        ),
      ),
      margin: EdgeInsets.only(bottom: 20),
      child: Container(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            // Icône de classement à gauche
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0), // Couleur de fond de l'icône
                shape: BoxShape.circle, // Forme circulaire
                border: Border.all(
                  color: Colors.white, // Couleur de la bordure
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  rank,
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16), // Espace entre l'icône et le texte
            // Nom et points centrés
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Nom du participant
                  Text(
                    name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8), // Espace entre le nom et les points
                  // Points
                  Text(
                    points,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
}