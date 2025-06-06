import 'package:des/src/Modules/Splash/screens/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DessApp());
  await dotenv.load(fileName: '.env');
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
