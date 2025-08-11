import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class QuantitativeCardAthletesInfo extends StatelessWidget {
  final String athleteName;
  final List<TextEditingController> controllers;

  const QuantitativeCardAthletesInfo({
    super.key,
    required this.athleteName,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      double fieldWidth = (constraints.maxWidth - 20) / 3;

      return Column(
        children: [
          Text(
            athleteName.toUpperCase(),
            style: secondFont.bold(color: Colors.white, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: controllers
                .map((c) => Container(
                      width: fieldWidth.clamp(100, 200),
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: const Color(0XFFA6B92E), width: 1),
                      ),
                      child: Center(
                        child: TextField(
                          controller: c,
                          style: secondFont.bold(
                              color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                          cursorColor: const Color(0XFFA6B92E),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintStyle: TextStyle(color: Colors.white54),
                          ),
                        ),
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 20),
        ],
      );
    });
  }
}
