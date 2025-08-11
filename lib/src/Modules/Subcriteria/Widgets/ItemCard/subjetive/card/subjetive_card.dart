import 'dart:developer';

import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/Modules/Subcriteria/Services/get_participants.dart';
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
  bool isLoading = true;
  List<Map<String, dynamic>> athletes = [];
  late SendValues measurableService;
  String buttonText = "SALVAR AVALIAÇÃO";

  @override
  void initState() {
    super.initState();
    _loadAthletes();
  }

  Future<void> _loadAthletes() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      setState(() => isLoading = false);
      return;
    }

    measurableService = SendValues(token);

    try {
      final filteredAthletes =
          await measurableService.loadFilteredAthletes(token);

      setState(() {
        athletes = filteredAthletes;
        isLoading = false;
      });
    } catch (e) {
      log("Erro ao carregar atletas filtrados: $e");
      setState(() => isLoading = false);
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

    // monta lista de resultados
    final results = scoresMap.entries
        .where((e) => e.value > 0)
        .map((e) => {
              "item_id": widget.itemId,
              "name": e.key,
              "score": e.value.toDouble(), // força double
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

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0XFFA6B92E)),
      );
    }

    if (athletes.isEmpty) {
      return const Center(
        child: Text('Nenhum atleta encontrado',
            style: TextStyle(color: Colors.white)),
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
