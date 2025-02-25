import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return const Center(
      child: Text(
        'Profile Page',
        style: TextStyle(color: Colors.white, fontSize: 24),
=======
    return Scaffold(
      body: Container(
        width: double.infinity, // Full screen width
        height: double.infinity, // Full screen height
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.black,
              Colors.grey.shade900,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10), // Reduced space at the top
                // Profile Title with Retro Arcade Style
                const Text(
                  'PROFILE',
                  style: TextStyle(
                    fontSize: 24, // Smaller font size
                    fontFamily: 'arcade',
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Color.fromRGBO(255, 235, 59, 0.5), // Yellow with 50% opacity
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10), // Reduced space
                // Profile Picture with Glow Effect
                Container(
                  padding: const EdgeInsets.all(6), // Smaller padding
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.yellow.withOpacity(0.3),
                        blurRadius: 15, // Smaller glow
                        spreadRadius: 3, // Smaller glow
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 50, // Smaller profile image
                    backgroundImage: NetworkImage(
                      'https://via.placeholder.com/150', // Replace with the actual image URL
                    ),
                    backgroundColor: Colors.transparent,
                  ),
                ),
                const SizedBox(height: 8), // Reduced space
                // Profile Name and Username
                const Text(
                  'Alvart Ainstain',
                  style: TextStyle(
                    fontSize: 22, // Smaller font size
                    fontFamily: 'arcade',
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        blurRadius: 5.0,
                        color: Color.fromRGBO(255, 235, 59, 0.5), // Yellow with 50% opacity
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4), // Reduced space
                const Text(
                  '@albart.ainstain',
                  style: TextStyle(
                    fontSize: 14, // Smaller font size
                    fontFamily: 'arcade',
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20), // Reduced space
                // Stats Section with Creative Layout
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // On Going Tasks
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10), // Smaller padding
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.yellow, Colors.orange],
                              ),
                            ),
                            child: const Icon(
                              Icons.assignment,
                              color: Colors.black,
                              size: 24, // Smaller icon
                            ),
                          ),
                          const SizedBox(height: 8), // Reduced space
                          const Text(
                            '5',
                            style: TextStyle(
                              fontSize: 20, // Smaller font size
                              fontFamily: 'arcade',
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4), // Reduced space
                          const Text(
                            'On Going',
                            style: TextStyle(
                              fontSize: 14, // Smaller font size
                              fontFamily: 'arcade',
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      // Completed Tasks
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10), // Smaller padding
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [Colors.yellow, Colors.orange],
                              ),
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.black,
                              size: 24, // Smaller icon
                            ),
                          ),
                          const SizedBox(height: 8), // Reduced space
                          const Text(
                            '25',
                            style: TextStyle(
                              fontSize: 20, // Smaller font size
                              fontFamily: 'arcade',
                              color: Colors.yellow,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4), // Reduced space
                          const Text(
                            'Completed',
                            style: TextStyle(
                              fontSize: 14, // Smaller font size
                              fontFamily: 'arcade',
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Reduced space
                // Settings and My Task Buttons with Creative Design
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Settings Button
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20.0), // Smaller padding
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.yellow, Colors.orange],
                          ),
                          borderRadius: BorderRadius.circular(12), // Smaller border radius
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellow.withOpacity(0.3),
                              blurRadius: 8, // Smaller glow
                              spreadRadius: 2, // Smaller glow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'SETTINGS',
                              style: TextStyle(
                                fontFamily: 'arcade',
                                color: Colors.black,
                                fontSize: 16, // Smaller font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.arrow_forward, color: Colors.black, size: 24), // Smaller icon
                          ],
                        ),
                      ),
                      const SizedBox(height: 16), // Reduced space
                      // My Task Button
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 20.0), // Smaller padding
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.yellow, Colors.orange],
                          ),
                          borderRadius: BorderRadius.circular(12), // Smaller border radius
                          boxShadow: [
                            BoxShadow(
                              color: Colors.yellow.withOpacity(0.3),
                              blurRadius: 8, // Smaller glow
                              spreadRadius: 2, // Smaller glow
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'MY TASK',
                              style: TextStyle(
                                fontFamily: 'arcade',
                                color: Colors.black,
                                fontSize: 16, // Smaller font size
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.arrow_forward, color: Colors.black, size: 24), // Smaller icon
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20), // Reduced space
              ],
            ),
          ),
        ),
>>>>>>> main
      ),
    );
  }
}