// ignore_for_file: use_build_context_synchronously

import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/Modules/Subcriteria/Services/send_values.dart';
import 'package:des/src/Modules/Subcriteria/Widgets/ItemCard/measurable/widgets/measurable_card_athletes_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuantitativeCard extends StatefulWidget {
  final String itemName;
  final int itemId;

  const QuantitativeCard({
    super.key,
    required this.itemName,
    required this.itemId,
  });

  @override
  State<QuantitativeCard> createState() => _QuantitativeCardState();
}

class _QuantitativeCardState extends State<QuantitativeCard> {
  final Map<String, List<TextEditingController>> controllersMap = {};
  List<Map<String, dynamic>> filteredAthletes = [];
  late SendValues measurableService;

  // Cache estático para a sessão - mantém os dados enquanto o app rodar
  static List<Map<String, dynamic>>? _cachedAthletes;

  // Usado para atualizar o texto do botão dinamicamente
  final ValueNotifier<String> _buttonTextNotifier =
      ValueNotifier('SALVAR AVALIAÇÃO');

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      final token = prefs.getString('token');
      if (token != null && mounted) {
        measurableService = SendValues(token);
        if (_cachedAthletes != null) {
          // Se temos cache, usa direto
          filteredAthletes = _cachedAthletes!;
          setState(() {});
        } else {
          // Senão, carrega da API e salva no cache
          _loadAthletes(token);
        }
      }
    });
  }

  Future<void> _loadAthletes(String token) async {
    try {
      final filtered = await measurableService.loadFilteredAthletes(token);
      if (!mounted) return;
      filteredAthletes = filtered;
      _cachedAthletes = filtered; // salva no cache da sessão
      setState(() {});
    } catch (_) {
      if (!mounted) return;
      filteredAthletes = [];
      setState(() {});
    }
  }

  @override
  void dispose() {
    _buttonTextNotifier.dispose();
    for (var controllers in controllersMap.values) {
      for (var controller in controllers) {
        controller.dispose();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.9;
    final buttonWidth = screenWidth * 0.75;

    if (filteredAthletes.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum atleta com avaliação encontrada',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return Container(
      width: cardWidth,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0XFFA6B92E),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Text(
            widget.itemName.toUpperCase(),
            style: principalFont.bold(
              color: Colors.white,
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ...filteredAthletes.map((athlete) {
            final user = athlete['user'];
            final name = user != null
                ? '${user['name'] ?? ''} ${user['last_name'] ?? ''}'.trim()
                : 'Nome não informado';

            if (!controllersMap.containsKey(name)) {
              controllersMap[name] = List.generate(
                3,
                (_) => TextEditingController(),
              );
            }

            return MeasurableCardAthletesInfo(
              athleteName: name,
              itemId: widget.itemId, // passe o itemId aqui
              controller1: controllersMap[name]![0],
              controller2: controllersMap[name]![1],
              controller3: controllersMap[name]![2],
            );
          }),
          const SizedBox(height: 16),
          SizedBox(
            width: buttonWidth,
            child: ValueListenableBuilder<String>(
              valueListenable: _buttonTextNotifier,
              builder: (context, text, _) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFFA6B92E),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () async {
                    if (_buttonTextNotifier.value != 'SALVAR AVALIAÇÃO') return;

                    final token = await SharedPreferences.getInstance()
                        .then((prefs) => prefs.getString('token'));

                    if (token == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Token não encontrado'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final results = <Map<String, dynamic>>[];

                    controllersMap.forEach((name, controllers) {
                      final values = controllers
                          .map((c) => double.tryParse(c.text.trim()) ?? 0)
                          .where((v) => v > 0)
                          .toList();

                      if (values.isNotEmpty) {
                        final smallest = values.reduce((a, b) => a < b ? a : b);
                        results.add({
                          'item_id': widget.itemId,
                          'name': name,
                          'score': smallest,
                        });
                      }
                    });

                    if (results.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              'Preencha pelo menos um campo antes de salvar.'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    _buttonTextNotifier.value = 'Carregando avaliações...';

                    bool allSuccess = true;
                    int count = 0;

                    for (final result in results) {
                      count++;
                      _buttonTextNotifier.value =
                          'Enviando avaliação $count de ${results.length}...';

                      try {
                        final athleteData = filteredAthletes.firstWhere(
                          (a) {
                            final user = a['user'];
                            final fullName = user != null
                                ? '${user['name'] ?? ''} ${user['last_name'] ?? ''}'
                                    .trim()
                                : '';
                            return fullName == result['name'];
                          },
                          orElse: () => {},
                        );

                        if (athleteData.isEmpty) {
                          allSuccess = false;
                          continue;
                        }

                        final userId = athleteData['user']['id'] as int;
                        final evalData = await measurableService
                            .evaluationService
                            .fetchEvaluationData(userId);

                        if (evalData == null) {
                          allSuccess = false;
                          continue;
                        }

                        final evaluationId = evalData['evaluation_id'] as int;
                        final participantId = evalData['participant_id'] as int;

                        await measurableService.evaluationService.submitScore(
                          evaluationId: evaluationId,
                          itemId: result['item_id'],
                          participantId: participantId,
                          score: result['score'],
                          athleteName: result['name'],
                        );

                        _buttonTextNotifier.value = 'Avaliação $count enviada';
                      } catch (_) {
                        allSuccess = false;
                      }

                      await Future.delayed(const Duration(milliseconds: 700));
                    }

                    _buttonTextNotifier.value = allSuccess
                        ? 'Concluído!'
                        : 'Erro em algumas avaliações';

                    await Future.delayed(const Duration(seconds: 2));

                    _buttonTextNotifier.value = 'SALVAR AVALIAÇÃO';

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
                  },
                  child: Text(
                    text,
                    style: principalFont.medium(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
