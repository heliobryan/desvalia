import 'package:flutter/material.dart';

class FilterGender extends StatefulWidget {
  const FilterGender({super.key});

  @override
  State<FilterGender> createState() => _FilterGenderState();
}

class _FilterGenderState extends State<FilterGender> {
  bool isHomem = true;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0XFFb0c32e), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.transparent),
        ),
        child: Icon(
          isHomem ? Icons.male : Icons.female,
          size: 25,
          color: Colors.white,
        ),
        onPressed: () {
          setState(() {
            isHomem = !isHomem;
          });
        },
      ),
    );
  }
}
