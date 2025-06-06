import 'package:flutter/material.dart';

class SubcriteriaCard extends StatelessWidget {
  final Map<String, dynamic> subcriteria;
  final VoidCallback onPressed;

  const SubcriteriaCard({
    super.key,
    required this.subcriteria,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final String name = subcriteria['name'] ?? 'Sem Nome';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 8.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 550),
          child: OutlinedButton(
            onPressed: onPressed,
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0XFFb0c32e),
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0XFFb0c32e)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.zero,
            ).copyWith(
              overlayColor: WidgetStateProperty.all(
                const Color(0xFF98A52A),
              ),
            ),
            child: SizedBox(
              height: 70,
              child: Center(
                child: Text(
                  name.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
