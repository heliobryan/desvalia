import 'dart:convert';
import 'dart:developer';

import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/Modules/Subcriteria/Services/get_participants.dart';
import 'package:des/src/Modules/Subcriteria/Widgets/ItemCard/measurable/widgets/measurable_card_athletes_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MeasurableCard extends StatelessWidget {
  final String itemName;

  const MeasurableCard({super.key, required this.itemName});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth * 0.9;
    final buttonWidth = screenWidth * 0.75;

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
                child: Text(
                  'Erro ao carregar atletas',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            if (snap.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Nenhum atleta encontrado',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            log('Lista de Atletas Formatada:\n${const JsonEncoder.withIndent('  ').convert(snap.data)}');

            final athletes = snap.data!;

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
                    itemName.toUpperCase(),
                    style: principalFont.bold(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  ...athletes.map((athlete) {
                    final user = athlete['user'];

                    final name = user != null
                        ? '${user['name'] ?? ''} ${user['last_name'] ?? ''}'
                            .trim()
                        : 'Nome não informado';
                    //${user["id"] ?? ""}
                    return MeasurableCardAthletesInfo(athleteName: name);
                  }),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: buttonWidth,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0XFFA6B92E),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: Text(
                        "SALVAR AVALIAÇÃO",
                        style: principalFont.medium(color: Colors.white),
                      ),
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
