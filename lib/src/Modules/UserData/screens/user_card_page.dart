import 'dart:developer';

import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/Modules/UserData/services/get_user_data.dart';
import 'package:des/src/Modules/UserData/widgets/player_card.dart';
import 'package:flutter/material.dart';

class UserCardPage extends StatefulWidget {
  final int participantID;

  const UserCardPage({super.key, required this.participantID});

  @override
  State<UserCardPage> createState() => _UserCardPageState();
}

class _UserCardPageState extends State<UserCardPage> {
  late Future<Map<String, dynamic>> _participantInfoFuture;
  @override
  void initState() {
    super.initState();
    _participantInfoFuture =
        GetParticipantInfo.fetchBasicInfo(widget.participantID);
  }

  @override
  Widget build(BuildContext context) {
    log('ParticipantID: ${widget.participantID}');

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
        title: Image.asset(Assets.homelogo, width: 250),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
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
                FutureBuilder<Map<String, dynamic>>(
                  future: _participantInfoFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                          color: Colors.white);
                    } else if (snapshot.hasError) {
                      return Text(
                        'Erro: ${snapshot.error}',
                        style: const TextStyle(color: Colors.white),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text(
                        'Nenhum dado encontrado',
                        style: TextStyle(color: Colors.white),
                      );
                    } else {
                      final participantData = snapshot.data!;
                      final name = participantData['name'] ?? '';
                      final photo = participantData['photo'] ?? '';
                      final lastName = participantData['last_name'] ?? '';
                      final stats =
                          participantData['stats'] ?? <String, dynamic>{};
                      final overall = participantData["overall"];
                      final position = participantData["position"];

                      log("photo: $photo");
                      log("name: $name");
                      log("lastname: $lastName");
                      log("stats: $stats");
                      log("overall: $overall");

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 20),
                          PlayerCard(
                            position: position,
                            participantID: widget.participantID,
                            name: name,
                            lastName: lastName,
                            stats: Map<String, dynamic>.from(stats),
                            photo: photo,
                            overall: overall,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
