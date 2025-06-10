// ignore_for_file: deprecated_member_use
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/Modules/UserAvaliations/screens/avaliation_page.dart';
import 'package:flutter/material.dart';

class AvaliationCardTrigger extends StatelessWidget {
  final int participantID;

  const AvaliationCardTrigger({super.key, required this.participantID});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 90,
      width: 380,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border.all(color: const Color(0XFFb0c32e), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: const BorderSide(color: Colors.transparent),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AvaliationPage(participantID: participantID),
            ),
          );
        },
        child: Row(
          children: [
            const Icon(Icons.assignment, color: Colors.white, size: 60),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AVALIAÇÕES',
                    style:
                        principalFont.bold(color: Colors.white, fontSize: 22),
                  ),
                  Text(
                    'Veja seus resultados',
                    style: secondFont.bold(color: Colors.white, fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
