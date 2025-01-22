import 'package:des/src/Splash/screens/splashPage.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(
    const DessApp(),
  );
}

class DessApp extends StatelessWidget {
  const DessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
