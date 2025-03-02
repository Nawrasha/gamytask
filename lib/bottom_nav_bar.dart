import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      backgroundColor: const Color(0xFF0A0C16), // Dark background
      selectedItemColor: const Color(0xFFFFD600), // Selected tab color
      unselectedItemColor: Colors.grey, // Unselected tab color
      type: BottomNavigationBarType.fixed,
      items:[
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/Home.png', // Path to your custom Home image
            width: 30, // Width of the icon
            height: 30, // Height of the icon
            color: currentIndex == 0 ? Colors.yellow : Colors.grey, // Change color if selected
          ),
          label: '', // No label, as per your example
        ),
    
         BottomNavigationBarItem(
          icon: Image.asset(
            'assets/Folder.png', // Path to your custom Folder image
            width: 30,
            height: 30,
            color: currentIndex == 1 ? Colors.yellow : Colors.grey,
          ),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/EditSquare.png', // Path to your custom Edit image
            width: 30,
            height: 30,
            color: currentIndex == 2 ? Colors.yellow : Colors.grey,
          ),
          label: '',
        ),
      
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/Profile.png', // Path to your custom Profile image
            width: 30,
            height: 30,
            color: currentIndex == 3 ? Colors.yellow : Colors.grey,
          ),
          label: '',
        ),

      ],
    );


  }
}  




