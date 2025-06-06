// ignore_for_file: deprecated_member_use

import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class PlayerCardTrigger extends StatefulWidget {
  const PlayerCardTrigger({super.key});

  @override
  State<PlayerCardTrigger> createState() => _PlayerCardTriggerState();
}

class _PlayerCardTriggerState extends State<PlayerCardTrigger> {
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
        onPressed: () {},
        child: Row(
          children: [
            const Icon(Icons.badge, color: Colors.white, size: 60),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CARD',
                    style:
                        principalFont.bold(color: Colors.white, fontSize: 22),
                  ),
                  Text(
                    'Card do atleta',
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
