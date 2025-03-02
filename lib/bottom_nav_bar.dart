
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
          color: const Color(0xFF0A0C16), // Couleur de fond de la barre
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Icône Home
              IconButton(
                icon: Image.asset(
                  'assets/Home.png',
                  width: 30,
                  height: 30,
                  color: currentIndex == 0 ? Colors.yellow : Colors.grey,
                ),
                onPressed: () => onTap(0),
              ),
              // Icône Folder
              IconButton(
                icon: Image.asset(
                  'assets/Folder.png',
                  width: 30,
                  height: 30,
                  color: currentIndex == 1 ? Colors.yellow : Colors.grey,
                ),
                onPressed: () => onTap(1),
              ),
              // Espace vide pour le bouton + (centré)
              SizedBox(width: 60), // Largeur du bouton +
              // Icône EditSquare
              IconButton(
                icon: Image.asset(
                  'assets/EditSquare.png',
                  width: 30,
                  height: 30,
                  color: currentIndex == 2 ? Colors.yellow : Colors.grey,
                ),
                onPressed: () => onTap(2),
              ),
              // Icône Profile
              IconButton(
                icon: Image.asset(
                  'assets/Profile.png',
                  width: 30,
                  height: 30,
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
          bottom: 20, // Ajuster la position verticale
          child: GestureDetector(
            onTap: onAddButtonPressed,
            child: Container(
              width: 60, // Diamètre du cercle
              height: 60, // Diamètre du cercle
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Forme circulaire
                color: Colors.yellow, // Couleur de fond
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3), // Ombre
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // Position de l'ombre
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.add,
                  color: Colors.white, // Couleur de l'icône +
                  size: 30, // Taille de l'icône
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}