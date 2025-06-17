import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class QuantitativeCardAthletesInfo extends StatelessWidget {
  final String athleteName;

  const QuantitativeCardAthletesInfo({
    super.key,
    required this.athleteName,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double fieldWidth = (constraints.maxWidth - 20) / 3;

        return Column(
          children: [
            Text(
              athleteName.toUpperCase(),
              style: secondFont.bold(
                color: Colors.white,
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              width: double.infinity,
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
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: [
                _buildTextFieldContainer(fieldWidth),
                _buildTextFieldContainer(fieldWidth),
                _buildTextFieldContainer(fieldWidth),
              ],
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildTextFieldContainer(double width) {
    return Container(
      width: width.clamp(100, 200),
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
