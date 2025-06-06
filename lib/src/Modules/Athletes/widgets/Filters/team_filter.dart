import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class TeamFilter extends StatefulWidget {
  const TeamFilter({super.key});

  @override
  State<TeamFilter> createState() => _TeamFilterState();
}

class _TeamFilterState extends State<TeamFilter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0XFFb0c32e), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.transparent),
        ),
        child: Text(
          "ESCOLA FLAMENGO",
          style: secondFont.bold(color: Colors.white),
        ),
        onPressed: () {},
      ),
    );
  }
}
