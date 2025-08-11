// ignore_for_file: deprecated_member_use
import 'dart:developer';

import 'package:des/src/Commom/rest_client.dart';
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/Modules/UserAvaliations/services/get_participant_evaluation.dart';
import 'package:des/src/Modules/UserBioData/widgets/user_data_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBiologicalPage extends StatefulWidget {
  final int participantID;

  const UserBiologicalPage({super.key, required this.participantID});

  @override
  State<UserBiologicalPage> createState() => _UserBiologicalPageState();
}

class _UserBiologicalPageState extends State<UserBiologicalPage> {
  late Future<List<Map<String, dynamic>>> allJudgments;
  @override
  void initState() {
    super.initState();
    allJudgments = loadJudgments();
  }

  Future<List<Map<String, dynamic>>> loadJudgments() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null) {
        throw Exception('Token não encontrado');
      }

      final restClient = RestClient(token: token);
      final evaluationsFetcher = GetParticipantEvaluations(restClient);

      final judgments =
          await evaluationsFetcher.fetchJudgments(widget.participantID);

      final filteredJudgments = judgments.where((judgment) {
        final item = judgment['item'];
        final itemId = item?['id'];
        return itemId == 16 || itemId == 17;
      }).toList();

      for (var judgment in filteredJudgments) {
        final id = judgment['id'];
        final score = judgment['score'];
        final itemName = judgment['item']?['name'] ?? 'sem nome';
        final userName = judgment['user']?['name'] ?? 'sem nome';
        final userPhoto = judgment['user']?['photo_temp'] ?? 'sem foto';

        log('ID: $id | Score: $score | Item: $itemName | User: $userName | Foto: $userPhoto');
      }

      return filteredJudgments;
    } catch (e, stack) {
      log('Erro ao carregar julgamentos: $e');
      log('Stack trace: $stack');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                const SizedBox(height: 20),
                Text(
                  "Dados Biológicos",
                  style: principalFont.bold(color: Colors.white, fontSize: 25),
                ),
                const SizedBox(height: 50),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: allJudgments,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(
                        color: Color(0XFFA6B92E),
                      );
                    } else if (snapshot.hasError) {
                      return const Text("Erro ao carregar dados",
                          style: TextStyle(color: Colors.white));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text("Nenhum dado encontrado",
                          style: TextStyle(color: Colors.white));
                    } else {
                      final data = snapshot.data!;
                      final item16 = data.firstWhere(
                        (j) => j['item']?['id'] == 16,
                        orElse: () => {},
                      );
                      final item17 = data.firstWhere(
                        (j) => j['item']?['id'] == 17,
                        orElse: () => {},
                      );

                      return ViewBiological(
                        item16: item16.isNotEmpty ? item16 : null,
                        item17: item17.isNotEmpty ? item17 : null,
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
