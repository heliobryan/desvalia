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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 70,
      width: 420,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border.all(color: const Color(0XFFb0c32e), width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                width: 45,
                height: 45,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.person,
                  size: 45,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            // INFORMAÇÕES
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(name,
                      style: secondFont.bold(color: Colors.white, fontSize: 15),
                      textAlign: TextAlign.center),
                  Text(
                    "$position - $modality - $category - $team ",
                    style: secondFont.bold(color: Colors.white, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
