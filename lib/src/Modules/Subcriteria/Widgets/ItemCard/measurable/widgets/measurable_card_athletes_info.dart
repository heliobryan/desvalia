import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class MeasurableCardAthletesInfo extends StatelessWidget {
  final String athleteName;

  const MeasurableCardAthletesInfo({
    super.key,
    required this.athleteName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          athleteName.toUpperCase(),
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
          children: [
            _buildTextFieldContainer(),
            const SizedBox(width: 10),
            _buildTextFieldContainer(),
            const SizedBox(width: 10),
            _buildTextFieldContainer(),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextFieldContainer() {
    return Container(
      width: 150,
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0XFFA6B92E),
          width: 1,
        ),
      ),
      child: Center(
        child: TextField(
          style: secondFont.bold(
            color: Colors.white,
            fontSize: 16,
          ),
          textAlign: TextAlign.center,
          cursorColor: const Color(0XFFA6B92E),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white54),
          ),
        ),
      ),
    );
  }
}
