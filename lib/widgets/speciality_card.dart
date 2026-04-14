import 'package:flutter/material.dart';
import '../models/speciality.dart';

class SpecialityCard extends StatelessWidget {
  final Speciality speciality;
  final VoidCallback onTap;

  const SpecialityCard({
    super.key,
    required this.speciality,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.teal.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.teal.shade100),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(speciality.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(
              speciality.displayName,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
