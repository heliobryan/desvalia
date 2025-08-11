import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class MeasurableCardAthletesInfo extends StatelessWidget {
  final String athleteName;
  final TextEditingController controller1;
  final TextEditingController controller2;
  final TextEditingController controller3;

  const MeasurableCardAthletesInfo({
    super.key,
    required this.athleteName,
    required this.controller1,
    required this.controller2,
    required this.controller3,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 500;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          athleteName.toUpperCase(),
          style: secondFont.bold(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          width: isSmallScreen ? double.infinity : screenWidth * 0.8,
          height: 1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0XFFA6B92E),
              width: 1,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildTextFieldContainer(screenWidth, controller1),
            _buildTextFieldContainer(screenWidth, controller2),
            _buildTextFieldContainer(screenWidth, controller3),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTextFieldContainer(
      double screenWidth, TextEditingController controller) {
    final double width = screenWidth < 400
        ? screenWidth * 0.8
        : screenWidth < 600
            ? screenWidth * 0.4
            : 150;

    return SizedBox(
      width: width,
      height: 50,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0XFFA6B92E),
            width: 1,
          ),
        ),
        child: Center(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
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
      ),
    );
  }
}
