import 'package:flutter/material.dart';
import '../models/area.dart';

class AreaCard extends StatelessWidget {
  final Area area;
  final VoidCallback onTap;

  const AreaCard({super.key, required this.area, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.teal.shade100,
      Colors.blue.shade100,
      Colors.purple.shade100,
      Colors.orange.shade100,
      Colors.green.shade100,
      Colors.pink.shade100,
    ];
    final color = colors[area.name.length % colors.length];

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              area.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
