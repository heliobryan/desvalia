// ignore_for_file: library_private_types_in_public_api, use_super_parameters

import 'dart:async';
import 'package:flutter/material.dart';

class Simple15sTimer extends StatefulWidget {
  const Simple15sTimer({Key? key}) : super(key: key);

  @override
  _Simple15sTimerState createState() => _Simple15sTimerState();
}

class _Simple15sTimerState extends State<Simple15sTimer> {
  static const int totalSeconds = 15;
  int _secondsLeft = totalSeconds;
  Timer? _timer;
  bool _isRunning = false;

  void _startTimer() {
    if (_isRunning) return;

    setState(() {
      _isRunning = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft == 0) {
        _stopTimer();
      } else {
        setState(() {
          _secondsLeft--;
        });
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      _secondsLeft = totalSeconds;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0XFFA6B92E)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Start button
          GestureDetector(
            onTap: _startTimer,
            child: Icon(
              Icons.play_arrow,
              color: _isRunning ? Colors.grey : const Color(0XFFA6B92E),
            ),
          ),
          const SizedBox(width: 12),

          // Stop button
          GestureDetector(
            onTap: _stopTimer,
            child: Icon(
              Icons.stop,
              color: _isRunning ? const Color(0XFFA6B92E) : Colors.grey,
            ),
          ),
          const SizedBox(width: 12),

          // Reset button
          GestureDetector(
            onTap: _resetTimer,
            child: Icon(
              Icons.replay,
              color: const Color(0XFFA6B92E),
            ),
          ),
          const SizedBox(width: 16),

          // Timer text
          Text(
            '$_secondsLeft s',
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
