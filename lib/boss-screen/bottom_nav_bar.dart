import 'package:flutter/material.dart';
import 'note_page.dart';
import 'task_create.dart'; // Import the TaskCreate page
import 'dart:ui'; // Add this import for ImageFilter

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onAddButtonPressed;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddButtonPressed,
  });

  void _showAddOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Stack(
            children: [
              Container(
                height: 280,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[600],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Create Task Button
                    _buildOptionButton(
                      context,
                      'Create Task',
                      Icons.edit_note_outlined,
                      () {
                        Navigator.pop(context); // Close the bottom sheet
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const TaskCreate()), // Navigate to TaskCreate
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    // Espace privé Button
                    _buildOptionButton(
                      context,
                      'Espace privé',
                      Icons.space_dashboard_outlined,
                      () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const NotePage()),
                        );
                      },
                    ),
                    const Spacer(),
                    // Bottom section
                    Container(
                      height: 100,
                      color: const Color(0xFF1E1E1E),
                    ),
                  ],
                ),
              ),
              // Yellow X button
              Positioned(
                left: MediaQuery.of(context).size.width / 2 - 25,
                bottom: 50,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.yellow,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.yellow.withOpacity(0.3),
                          spreadRadius: 4,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, -1),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOptionButton(
    BuildContext context, 
    String text, 
    IconData icon,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BottomAppBar(
          height: 65,
          color: const Color(0xFF0A0C16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/Home.png',
                  width: 24,
                  height: 24,
                  color: currentIndex == 0 ? Colors.yellow : Colors.grey,
                ),
                onPressed: () => onTap(0),
              ),
              IconButton(
                icon: Image.asset(
                  'assets/Folder.png',
                  width: 24,
                  height: 24,
                  color: currentIndex == 1 ? Colors.yellow : Colors.grey,
                ),
                onPressed: () => onTap(1),
              ),
              const SizedBox(width: 60),
              IconButton(
                icon: Image.asset(
                  'assets/Prize.png',
                  width: 60,
                  height: 60,
                  color: currentIndex == 2 ? Colors.yellow : Colors.grey,
                ),
                onPressed: () => onTap(2),
              ),
              IconButton(
                icon: Image.asset(
                  'assets/Profile.png',
                  width: 24,
                  height: 24,
                  color: currentIndex == 3 ? Colors.yellow : Colors.grey,
                ),
                onPressed: () => onTap(3),
              ),
            ],
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width / 2 - 30,
          bottom: 8,
          child: GestureDetector(
            onTap: () => _showAddOptions(context), // Updated to show popup
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.yellow,
                boxShadow: [
                  BoxShadow(
                    color: Colors.yellow.withOpacity(0.3),
                    spreadRadius: 4,
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 4,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),
      ],
    );
  }
}