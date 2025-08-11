import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/Modules/Subcriteria/Services/get_participants.dart';
import 'package:des/src/Modules/Subcriteria/Widgets/ItemCard/subjetive/widgets/subjetive_card_athletes_info.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubjetiveCard extends StatelessWidget {
  final String itemName;

  const SubjetiveCard({super.key, required this.itemName});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final cardMaxWidth = screenWidth * 0.9;

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
                  child: CircularProgressIndicator(color: Color(0XFFA6B92E)));
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

            return Container(
              constraints: BoxConstraints(
                maxWidth: cardMaxWidth,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
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
                  ),
                  const SizedBox(height: 10),
                  ...athletes.map((athlete) {
                    final user = athlete['user'];
                    final name = user != null
                        ? '${user['name'] ?? ''} ${user['last_name'] ?? ''}'
                            .trim()
                        : 'Nome não informado';

                    return SubjetiveCardAthletesInfo(athleteName: name);
                  }),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: cardMaxWidth.clamp(200, 450),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFFA6B92E),
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
