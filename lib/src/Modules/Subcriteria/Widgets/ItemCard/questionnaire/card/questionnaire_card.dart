import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class QuestionnaireCard extends StatelessWidget {
  final String itemName;

  const QuestionnaireCard({super.key, required this.itemName});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 550,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0XFFA6B92E),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Text(
            itemName.toUpperCase(),
            style: principalFont.bold(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
