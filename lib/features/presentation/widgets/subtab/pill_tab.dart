import 'package:flutter/material.dart';

class PillTab extends StatelessWidget {
  final String label;

  const PillTab({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: const Color(0xFF7C83FD).withOpacity(0.25),
          width: 1.5,
        ),
      ),
      alignment: Alignment.center,
      child: Text(label),
    );
  }
}
