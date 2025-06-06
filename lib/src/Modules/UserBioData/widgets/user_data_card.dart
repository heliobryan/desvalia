import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class ViewAvaliation extends StatelessWidget {
  const ViewAvaliation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: 400,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0XFFb0c32e)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0XFFb0c32e),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(
              "itemName",
              textAlign: TextAlign.center,
              style: secondFont.bold(color: Colors.white, fontSize: 20),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Nota:',
                  style: principalFont.bold(color: Colors.black, fontSize: 20),
                ),
                const SizedBox(height: 10),
                Container(
                  width: 120,
                  height: 30,
                  decoration: const BoxDecoration(color: Colors.black),
                  child: Center(
                    child: Text(
                      "score",
                      style: secondFont.bold(color: Colors.white, fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
