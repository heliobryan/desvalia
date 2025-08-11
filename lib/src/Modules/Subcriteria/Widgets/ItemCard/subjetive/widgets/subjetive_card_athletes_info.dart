import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class SubjetiveCardAthletesInfo extends StatefulWidget {
  final String athleteName;
  final ValueChanged<int> onScoreChanged; // número de estrelas

  const SubjetiveCardAthletesInfo({
    super.key,
    required this.athleteName,
    required this.onScoreChanged,
  });

  @override
  State<SubjetiveCardAthletesInfo> createState() =>
      _SubjetiveCardAthletesInfoState();
}

class _SubjetiveCardAthletesInfoState extends State<SubjetiveCardAthletesInfo> {
  final List<bool> _starsSelected = List.generate(5, (_) => false);

  void _updateStars(int index) {
    setState(() {
      for (int i = 0; i < 5; i++) {
        _starsSelected[i] = i <= index;
      }
    });

    final starsCount = index + 1; // index é zero-based
    widget.onScoreChanged(starsCount);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxWidth = screenWidth * 0.9;

    return Column(
      children: [
        Text(
          widget.athleteName.toUpperCase(),
          style: secondFont.bold(
            color: Colors.white,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: maxWidth.clamp(200, 450),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  _starsSelected[index] ? Icons.star : Icons.star_border,
                  color: const Color(0XFFA6B92E),
                  size: screenWidth < 400 ? 28 : 36,
                ),
                onPressed: () => _updateStars(index),
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
