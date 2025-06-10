import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/Modules/Profile/widgets/avaliation_card_trigger.dart';
import 'package:des/src/Modules/Profile/widgets/data_card_trigger.dart';
import 'package:des/src/Modules/Profile/widgets/player_card_trigger.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> athlete;

  const ProfilePage({super.key, required this.athlete});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final Map<String, dynamic> athlete;
  late final Map<String, dynamic> user;

  @override
  void initState() {
    super.initState();
    athlete = widget.athlete;
    user = athlete['user'] ?? {};
  }

  @override
  Widget build(BuildContext context) {
    final name =
        '${user['name'] ?? ''} ${user['last_name'] ?? ''}'.toUpperCase();
    final position = athlete['position'] ?? 'POSIÇÃO DESCONHECIDA';
    final modality = athlete['modality']?['name'] ?? 'Modalidade';
    final team = athlete['team']?['name'] ?? 'Time';
    final category = athlete['category'] ?? 'Instituição';
    final photo = user['photo_temp'] ?? '';
    // ignore: unused_local_variable
    final participantID = athlete['id'] ?? '';

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 65,
        backgroundColor: const Color(0XFFA6B92E),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 30,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.exit_to_app_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => const ExitButton(),
                ),
              ),
            ),
          ),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              colors: [
                Colors.black,
                Colors.black,
                // ignore: deprecated_member_use
                const Color(0xFF42472B).withOpacity(0.5),
              ],
            ),
          ),
        ),
        title: Image.asset(
          Assets.homelogo,
          width: 250,
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.background),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 4),
                  ),
                  child: Center(
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child: Image.network(
                          photo,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.person,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  name,
                  style: principalFont.bold(color: Colors.white, fontSize: 20),
                ),
                Text(
                  "$position - $modality",
                  style: secondFont.bold(color: Colors.white70, fontSize: 17),
                ),
                Text(
                  "$category - $team",
                  style: secondFont.bold(color: Colors.white70, fontSize: 17),
                ),
                const SizedBox(height: 40),
                AvaliationCardTrigger(
                  participantID: participantID,
                ),
                const SizedBox(height: 30),
                PlayerCardTrigger(
                  participantID: participantID,
                ),
                const SizedBox(height: 30),
                DataCardTrigger(
                  participantID: participantID,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
