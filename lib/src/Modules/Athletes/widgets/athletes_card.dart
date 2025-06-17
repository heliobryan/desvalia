// ignore_for_file: deprecated_member_use
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/Modules/Profile/screens/profile_page.dart';
import 'package:flutter/material.dart';

class AthletesCard extends StatelessWidget {
  final Map<String, dynamic> athlete;

  const AthletesCard({super.key, required this.athlete});

  @override
  Widget build(BuildContext context) {
    final user = athlete['user'] ?? {};
    final name =
        '${user['name'] ?? ''} ${user['last_name'] ?? ''}'.toUpperCase();
    final position = athlete['position'] ?? 'POSIÇÃO DESCONHECIDA';
    final modality = athlete['modality']?['name'] ?? 'Modalidade';
    final team = athlete['team']?['name'] ?? 'Time';
    final category = athlete['category'] ?? 'Instituição';
    final photo = user['photo_temp'] ?? '';
    // ignore: unused_local_variable
    final participantID = athlete['id'] ?? 'ID DESCONHECIDO';

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final cardHeight = maxWidth * 0.19;
        final photoSize = cardHeight * 0.7;
        final spacing = maxWidth * 0.03;
        final nameFontSize = maxWidth * 0.04;
        final infoFontSize = maxWidth * 0.035;

        return Container(
          padding: EdgeInsets.symmetric(horizontal: maxWidth * 0.03),
          height: cardHeight,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            border: Border.all(color: const Color(0XFFb0c32e), width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              side: const BorderSide(color: Colors.transparent),
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(athlete: athlete),
              ),
            ),
            child: Row(
              children: [
                // FOTO
                ClipOval(
                  child: Image.network(
                    photo,
                    width: photoSize,
                    height: photoSize,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.person,
                      size: photoSize,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: spacing),
                // INFORMAÇÕES
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        name,
                        style: secondFont.bold(
                          color: Colors.white,
                          fontSize: nameFontSize.clamp(12, 20),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "$position - $modality - $category - $team",
                        style: secondFont.bold(
                          color: Colors.white,
                          fontSize: infoFontSize.clamp(10, 18),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
