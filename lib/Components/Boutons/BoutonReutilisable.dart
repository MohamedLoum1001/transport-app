import 'package:flutter/material.dart';

// Composant bouton réutilisable
class BoutonReutilisable extends StatelessWidget {
  final String text; // The text to display on the button
  final VoidCallback onPressed; // Callback when the button is pressed
  final Color backgroundColor; // Background color of the button
  final Color textColor; // Text color of the button

  const BoutonReutilisable({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = Colors.purple,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // The button takes the full width of the screen
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16), // Uniform padding
        ),
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 16),
        ),
      ),
    );
  }
}
