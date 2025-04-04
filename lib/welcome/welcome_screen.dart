import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0C16),
      body: PageView(
        controller: _pageController,
        children: [
          // First welcome page
          _buildWelcomePage(
            context, 
            'welcome_bg.png', 
            isFirstPage: true,
            imageWidth: MediaQuery.of(context).size.width * 0.97,
          ),
          // Second welcome page
          _buildWelcomePage(
            context, 
            'welcome_bg2.png', 
            isFirstPage: false,
            imageWidth: MediaQuery.of(context).size.width * 1.8,
          ),
          // Third welcome page
          _buildWelcomePage(
            context, 
            'welcome_bg3.png', 
            isFirstPage: false,
            imageWidth: MediaQuery.of(context).size.width * 1.8,
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomePage(
    BuildContext context, 
    String imageName, {
    required bool isFirstPage,
    required double imageWidth,
  }) {
    return Stack(
      children: [
        // Image aligned to left and centered vertically with padding
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: EdgeInsets.only(right: 0, bottom: 55),
            child: Image.asset(
              'assets/images/$imageName',
              width: imageWidth,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading image: assets/images/$imageName');
                print('Error details: $error');
                print('Stack trace: $stackTrace');
                return Container(
                  width: imageWidth,
                  height: 180,
                  color: Colors.red.withOpacity(0.3),
                  child: Center(
                    child: Text(
                      'Image not found: $imageName',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        
        // Skip button
        Positioned(
          bottom: 18,
          left: 24,
          child: TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/signin'),
            child: Text(
              'Skip',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),

        // Next button at extreme right bottom
        Positioned(
          bottom: 0,
          right: -25,
          child: GestureDetector(
            onTap: () {
              if (isFirstPage) {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else if (imageName == 'welcome_bg2.png') {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              } else {
                Navigator.pushReplacementNamed(context, '/signin');
              }
            },
            child: Image.asset(
              'assets/images/next_arrow.png',
              width: 160,
              height: 160,
              errorBuilder: (context, error, stackTrace) {
                print('Error loading next arrow image');
                print('Error details: $error');
                return Container(
                  width: 160,
                  height: 160,
                  color: Colors.blue.withOpacity(0.3),
                  child: Center(
                    child: Icon(Icons.arrow_forward, color: Colors.white, size: 40),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
} 