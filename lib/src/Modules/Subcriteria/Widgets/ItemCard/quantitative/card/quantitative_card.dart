import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/Modules/Subcriteria/Services/get_participants.dart';
import 'package:des/src/Modules/Subcriteria/Widgets/ItemCard/quantitative/widgets/quantitative_card_athletes_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuantitativeCard extends StatefulWidget {
  final String itemName;
  final int itemId; // para associar o item para avaliação

  const QuantitativeCard(
      {super.key, required this.itemName, required this.itemId});

  @override
  State<QuantitativeCard> createState() => _QuantitativeCardState();
}

class _QuantitativeCardState extends State<QuantitativeCard> {
  final Map<String, List<TextEditingController>> controllersMap = {};

  @override
  void dispose() {
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

    return FutureBuilder<String?>(
      future: SharedPreferences.getInstance()
          .then((prefs) => prefs.getString('token')),
      builder: (context, tokenSnap) {
        if (!tokenSnap.hasData) {
          return const CircularProgressIndicator(color: Color(0XFFA6B92E));
        }

        final token = tokenSnap.data!;
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: GetParticipants.fetchAthletes(token),
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0XFFA6B92E)),
              );
            }

            if (snap.hasError || !snap.hasData) {
              return const Center(
                child: Text('Erro ao carregar atletas',
                    style: TextStyle(color: Colors.white)),
              );
            }

            if (snap.data!.isEmpty) {
              return const Center(
                child: Text('Nenhum atleta encontrado',
                    style: TextStyle(color: Colors.white)),
              );
            }

            final athletes = snap.data!;

            for (final athlete in athletes) {
              final user = athlete['user'];
              final name = user != null
                  ? '${user['name'] ?? ''} ${user['last_name'] ?? ''}'.trim()
                  : 'Nome não informado';

              if (!controllersMap.containsKey(name)) {
                controllersMap[name] =
                    List.generate(3, (_) => TextEditingController());
              }
            }

            return Container(
              width: screenWidth < 600 ? double.infinity : 550,
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0XFFA6B92E), width: 1),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    widget.itemName.toUpperCase(),
                    style:
                        principalFont.bold(color: Colors.white, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ...athletes.map((athlete) {
                    final user = athlete['user'];
                    final name = user != null
                        ? '${user['name'] ?? ''} ${user['last_name'] ?? ''}'
                            .trim()
                        : 'Nome não informado';

                    return QuantitativeCardAthletesInfo(
                      athleteName: name,
                      controllers: controllersMap[name]!,
                    );
                  }),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: screenWidth * 0.75,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFFA6B92E),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () async {
                        final results = <Map<String, dynamic>>[];

                        controllersMap.forEach((name, controllers) {
                          final values = controllers
                              .map((c) => double.tryParse(c.text.trim()) ?? 0)
                              .where((v) => v > 0)
                              .toList();

                          if (values.isNotEmpty) {
                            final smallest =
                                values.reduce((a, b) => a < b ? a : b);
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

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Avaliações preparadas para envio: ${results.length}'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      child: Text("SALVAR AVALIAÇÃO",
                          style: principalFont.medium(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
