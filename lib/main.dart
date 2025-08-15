import 'package:des/src/Modules/Splash/screens/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  WidgetsFlutterBinding
      .ensureInitialized(); // Inicializa o Flutter antes de tudo

  runApp(const DessApp());
}

class DessApp extends StatefulWidget {
  const DessApp({super.key});

  @override
  State<DessApp> createState() => _DessAppState();
}

class _DessAppState extends State<DessApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
