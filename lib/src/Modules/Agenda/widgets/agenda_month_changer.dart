// ignore_for_file: prefer_const_constructors

import 'package:des/src/GlobalConstants/font.dart';
import 'package:flutter/material.dart';

class MonthChanger extends StatefulWidget {
  final Function(int) onMonthChanged;
  const MonthChanger({super.key, required this.onMonthChanged});

  @override
  State<MonthChanger> createState() => _MonthChangerState();
}

class _MonthChangerState extends State<MonthChanger> {
  int currentMonth = DateTime.now().month;

  final List<String> monthNames = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro'
  ];

  void changeMonth(int delta) {
    setState(() {
      currentMonth = (currentMonth + delta) % 12;
      if (currentMonth <= 0) currentMonth += 12;
    });
    widget.onMonthChanged(currentMonth);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 365,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0XFFb0c32e), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => changeMonth(-1),
            ),
            Text(
              monthNames[currentMonth - 1],
              style: secondFont.bold(color: Colors.white, fontSize: 20),
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
              onPressed: () => changeMonth(1),
            ),
          ],
        ),
      ),
    );
  }
}
