// ignore_for_file: avoid_print
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({super.key});

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  Future<void> _launchURL() async {
    final url = Uri.parse('https://loja.flamengo.com.br/');
    try {
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Não foi possível abrir a URL';
      }
    } catch (e) {
      print("Erro ao tentar abrir a URL: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.exit_to_app_outlined,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => const ExitButton(),
            ),
          ),
        ],
        title: Text(
          'LOJA',
          style: principalFont.medium(color: Colors.white, fontSize: 20),
        ),
      ),
      backgroundColor: const Color(0xFF121212),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 3,
                ),
              ),
              child: IconButton(
                onPressed: _launchURL,
                icon: const Icon(
                  Icons.store_outlined,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
