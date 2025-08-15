import 'dart:async';
import 'package:flutter/material.dart';

class SimpleCronometro extends StatefulWidget {
  final TextStyle? textStyle;
  final double? height;

  const SimpleCronometro({super.key, this.textStyle, this.height});

  @override
  State<SimpleCronometro> createState() => _SimpleCronometroState();
}

class _SimpleCronometroState extends State<SimpleCronometro> {
  late Stopwatch _stopwatch;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _stopwatch.stop();
    super.dispose();
  }

  void _start() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
      _timer ??= Timer.periodic(const Duration(milliseconds: 30), (_) {
        if (mounted) setState(() {});
      });
      setState(() {});
    }
  }

  void _pause() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _timer?.cancel();
      _timer = null;
      setState(() {});
    }
  }

  void _reset() {
    _stopwatch.reset();
    setState(() {});
  }

  String _formattedTime() {
    final elapsed = _stopwatch.elapsed;
    final minutes = elapsed.inMinutes.toString().padLeft(2, '0');
    final seconds = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    final centis =
        ((elapsed.inMilliseconds % 1000) ~/ 10).toString().padLeft(2, '0');
    return '$minutes:$seconds.$centis';
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = _stopwatch.isRunning;
    final textStyle = widget.textStyle ??
        const TextStyle(
            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0XFFA6B92E)),
      ),
      height: widget.height ?? 50,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_formattedTime(), style: textStyle),
          const SizedBox(width: 12),
          IconButton(
            icon: Icon(isRunning ? Icons.pause : Icons.play_arrow,
                color: const Color(0XFFA6B92E)),
            onPressed: isRunning ? _pause : _start,
          ),
          IconButton(
            icon: const Icon(Icons.replay, color: Colors.red),
            onPressed: _reset,
          ),
        ],
      ),
    );
  }
}
