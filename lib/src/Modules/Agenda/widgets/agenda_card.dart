import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/Modules/Criteria/screens/criteria_page.dart';
import 'package:flutter/material.dart';

class AgendaCard extends StatelessWidget {
  final String title;
  final String date;

  const AgendaCard({super.key, required this.title, required this.date});

  @override
  Widget build(BuildContext context) {
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
        onPressed: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => CriteriaPage())),
        child: Row(
          children: [
            const Icon(Icons.assignment, color: Colors.white, size: 50),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(title,
                      style: secondFont.bold(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center),
                  Text("Dia $date",
                      style: secondFont.bold(color: Colors.white, fontSize: 13),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
