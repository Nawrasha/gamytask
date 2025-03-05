import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final VoidCallback onAddButtonPressed; // Callback pour le bouton +

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddButtonPressed, // Ajoutez ce paramètre
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // BottomNavigationBar avec 4 éléments
        BottomAppBar(
          height: 65,
          color: const Color(0xFF0A0C16), // Couleur de fond de la barre
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Icône Home
              IconButton(
                icon: Image.asset(
                  'assets/Home.png',
                  width: 24,
                  height: 24,
                  color: currentIndex == 0 ? Colors.yellow : Colors.grey,
                ),
                onPressed: () => onTap(0),
              ),
              // Icône Folder
              IconButton(
                icon: Image.asset(
                  'assets/Folder.png',
                  width: 24,
                  height: 24,
                  color: currentIndex == 1 ? Colors.yellow : Colors.grey,
                ),
                onPressed: () => onTap(1),
              ),
              // Espace vide pour le bouton + (centré)
              const SizedBox(width: 60),// Largeur du bouton +
              // Icône EditSquare
              IconButton(
                icon: Image.asset(
                  'assets/Prize.png',
                  width: 60,
                  height: 60,
                  color: currentIndex == 2 ? Colors.yellow : Colors.grey,
                ),
                onPressed: () => onTap(2),
              ),
              // Icône Profile
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
        // Bouton + au centre
        Positioned(
          left: MediaQuery.of(context).size.width / 2 - 30, // Centrer le bouton
          bottom: 25, // Position plus haute
          child: GestureDetector(
            onTap: onAddButtonPressed,
            child: Container(
              width: 50,
              height:50,
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