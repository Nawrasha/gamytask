import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          // Background ghosts
          Positioned(
            top: 120,
            right: 20,
            child: Opacity(
              opacity: 0.5, // Adjust for ghostly effect
              child: Image.asset(
                'assets/ghost1.png', // Add this asset to your project
                width: 40,
                height: 40,
              ),
            ),
          ),
          Positioned(
            top: 150,
            left: 40,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/ghost2.png', // Add this asset to your project
                width: 35,
                height: 35,
              ),
            ),
          ),
          Positioned(
            top: 20,
            left: 60,
            child: Opacity(
              opacity: 0.5,
              child: Image.asset(
                'assets/ghost3.png', // Add this asset to your project
                width: 35,
                height: 35,
              ),
            ),
          ),
          Positioned(
            top: 0,
            bottom:500,
            right:-20,
            left: 0, // Center the image
            child: Opacity(
              opacity: 1,
              child: Image.asset(
                'assets/points.png', // Add this asset to your project
                width: 100,
                height: 100,
              ),
            ),
          ),


          // Main Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Picture
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/Profilen.PNG'),
                      ),
                      const SizedBox(height: 16),

                      // User Name
                      const Text(
                        'Alvart Alnstein',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),

                      // Username
                      const Text(
                        '@goldentalnstein',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),

                      // Statistics with Vertical Dashed Divider
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStatistic('5', 'On Going', 'assets/Time_Square.png'),
                          const SizedBox(width: 15),
                          SizedBox(
                            height: 80,
                            child: CustomPaint(
                              painter: VerticalDashPainter(),
                            ),
                          ),
                          const SizedBox(width: 15),
                          _buildStatistic('25', 'Total Done', 'assets/Tick_Square.png'),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // View My Team Button
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A0C16),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.white, width: 1),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              'VIEW MY TEAM',
                              style: TextStyle(
                                fontFamily: 'poppins',
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                          ],
                        ),
                      ),
                      const SizedBox(height: 100),

                      // Log Out Button
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFE0000),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                          child: const Text(
                            'Log Out',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method to build a statistic widget
  Widget _buildStatistic(String value, String label, String iconPath) {
    return Column(
      children: [
        Image.asset(iconPath, width: 30, height: 30),
        const SizedBox(height: 1),
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 0),
        Text(
          label,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }
}

// Custom painter for the vertical dashed line
class VerticalDashPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double dashHeight = 5, dashSpace = 3;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}