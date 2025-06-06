import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class SubjetiveCardAthletesInfo extends StatefulWidget {
  final String athleteName;

  const SubjetiveCardAthletesInfo({
    super.key,
    required this.athleteName,
  });

  @override
  State<SubjetiveCardAthletesInfo> createState() =>
      _SubjetiveCardAthletesInfoState();
}

class _SubjetiveCardAthletesInfoState extends State<SubjetiveCardAthletesInfo> {
  final List<bool> _starsSelected = List.generate(5, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.athleteName.toUpperCase(),
          style: secondFont.bold(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        Container(
          width: 450,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0XFFA6B92E),
              width: 1,
            ),
          ),
          height: 0,
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return IconButton(
              icon: Icon(
                _starsSelected[index] ? Icons.star : Icons.star_border,
                color: const Color(0XFFA6B92E),
                size: 36,
              ),
              onPressed: () {
                setState(() {
                  _starsSelected[index] = !_starsSelected[index];
                });
              },
            );
          }),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
