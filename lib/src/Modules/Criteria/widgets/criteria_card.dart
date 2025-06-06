import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class CriteriaCard extends StatelessWidget {
  final Map<String, dynamic> criterias;
  final VoidCallback onTap;

  const CriteriaCard({
    super.key,
    required this.criterias,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String name = criterias['name'] ?? 'Sem Nome';

    IconData getIconForRoute(String route) {
      switch (route) {
        case 'Físico':
          return Icons.fitness_center;
        case 'Técnico':
          return Icons.sports_soccer;
        case 'Mental':
          return Icons.psychology;
        case 'Tático':
          return Icons.assignment;
        default:
          return Icons.help;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 70,
      width: 365,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0XFFb0c32e), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(color: Colors.transparent),
        ),
        onPressed: onTap,
        child: Row(
          children: [
            Icon(getIconForRoute(name), color: Colors.white, size: 50),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                name,
                style: secondFont.bold(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
