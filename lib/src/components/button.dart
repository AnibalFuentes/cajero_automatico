import 'package:flutter/material.dart';

class CajeroButton extends StatelessWidget {
  final Color color;
  final VoidCallback onPressed;

  const CajeroButton({
    super.key,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero, // Rectangular
        ),
        padding: const EdgeInsets.all(20), // Ajusta el padding si es necesario
      ),
      child: const SizedBox.shrink(), // Botón vacío
    );
  }
}
