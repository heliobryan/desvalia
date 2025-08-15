// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/Modules/Subcriteria/Services/send_values.dart';
import 'package:des/src/Modules/Subcriteria/Widgets/ItemCard/subjetive/widgets/subjetive_card_athletes_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubjetiveCard extends StatefulWidget {
  final String itemName;
  final int itemId; // para enviar para a API

  const SubjetiveCard({
    super.key,
    required this.itemName,
    required this.itemId,
  });

  @override
  State<SubjetiveCard> createState() => _SubjetiveCardState();
}

class _SubjetiveCardState extends State<SubjetiveCard> {
  final Map<String, int> scoresMap = {}; // nome -> score em pontos
  List<Map<String, dynamic>> athletes = [];
  late SendValues measurableService;
  String buttonText = "SALVAR AVALIAÇÃO";

  // Cache estático para a sessão - mantém os dados enquanto o app rodar
  static List<Map<String, dynamic>>? _cachedAthletes;

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  Future<void> _initLoad() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    measurableService = SendValues(token);

    if (_cachedAthletes != null) {
      // Usa cache direto
      athletes = _cachedAthletes!;
      setState(() {});
    } else {
      // Carrega da API e salva no cache
      await _loadAthletes(token);
    }
  }

  Future<void> _loadAthletes(String token) async {
    final stopwatch = Stopwatch()..start();
    try {
      final filteredAthletes =
          await measurableService.loadFilteredAthletes(token);
      stopwatch.stop();
      log('loadFilteredAthletes demorou: ${stopwatch.elapsedMilliseconds} ms');
      _cachedAthletes = filteredAthletes;
      athletes = filteredAthletes;
      setState(() {});
    } catch (e) {
      stopwatch.stop();
      log("Erro ao carregar atletas filtrados: $e, tempo: ${stopwatch.elapsedMilliseconds} ms");
      athletes = [];
      setState(() {});
    }
  }

  Future<void> _saveEvaluations() async {
    if (buttonText != "SALVAR AVALIAÇÃO") return;

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Token não encontrado'), backgroundColor: Colors.red),
      );
      return;
    }

    final results = scoresMap.entries
        .where((e) => e.value > 0)
        .map((e) => {
              "item_id": widget.itemId,
              "name": e.key,
              "score": e.value.toDouble(),
            })
        .toList();

    if (results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Selecione pelo menos uma estrela antes de salvar.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => buttonText = "Enviando avaliações...");

    bool allSuccess = await measurableService.submitScores(
      results: results,
      filteredAthletes: athletes,
      itemId: widget.itemId,
    );

    setState(() =>
        buttonText = allSuccess ? "Concluído!" : "Erro em algumas avaliações");

    await Future.delayed(const Duration(seconds: 2));
    setState(() => buttonText = "SALVAR AVALIAÇÃO");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          allSuccess
              ? 'Avaliações salvas com sucesso!'
              : 'Erro ao salvar algumas avaliações.',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: allSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardMaxWidth = screenWidth * 0.9;

    if (athletes.isEmpty) {
      return const Center(
        child: Text('', style: TextStyle(color: Colors.white)),
      );
    }

    return Container(
      constraints: BoxConstraints(maxWidth: cardMaxWidth),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0XFFA6B92E), width: 1),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            widget.itemName.toUpperCase(),
            style: principalFont.bold(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(height: 10),
          ...athletes.map((athlete) {
            final user = athlete['user'];
            final name = user != null
                ? '${user['name'] ?? ''} ${user['last_name'] ?? ''}'.trim()
                : 'Nome não informado';

            return SubjetiveCardAthletesInfo(
              athleteName: name,
              onScoreChanged: (stars) {
                setState(() {
                  scoresMap[name] = stars * 20; // cada estrela vale 20 pontos
                });
              },
            );
          }),
          const SizedBox(height: 20),
          SizedBox(
            width: cardMaxWidth.clamp(200, 450),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0XFFA6B92E),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: _saveEvaluations,
              child: Text(
                buttonText,
                style: principalFont.medium(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
