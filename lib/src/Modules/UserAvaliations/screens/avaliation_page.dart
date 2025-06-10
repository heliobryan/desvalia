// ignore_for_file: deprecated_member_use
import 'dart:developer';
import 'package:des/src/GlobalConstants/font.dart';
import 'package:des/src/GlobalConstants/images.dart';
import 'package:des/src/GlobalWidgets/exit_button.dart';
import 'package:des/src/Modules/UserAvaliations/services/get_participant_evaluation.dart';
import 'package:des/src/Modules/UserAvaliations/widgets/view_avaliation.dart';
import 'package:flutter/material.dart';

class AvaliationPage extends StatefulWidget {
  final int participantID;

  const AvaliationPage({super.key, required this.participantID});

  @override
  State<AvaliationPage> createState() => _AvaliationPageState();
}

class _AvaliationPageState extends State<AvaliationPage> {
  late Future<List<Map<String, dynamic>>> allJudgments;

  @override
  void initState() {
    super.initState();
    allJudgments = loadJudgments();
  }

  Future<List<Map<String, dynamic>>> loadJudgments() async {
    try {
      final judgments =
          await GetParticipantEvaluations.fetchJudgments(widget.participantID);

      for (var judgment in judgments) {
        // ignore: unused_local_variable
        final measurement = judgment['item']['measurement_unit'] ?? "";
        final id = judgment['id'];
        final score = judgment['score'];
        final itemName = judgment['item']?['name'] ?? 'sem nome';

        log('ID: $id | Score: $score | Item: $itemName');
      }

      return judgments;
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
        title: Image.asset(
          Assets.homelogo,
          width: 250,
        ),
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
                  "Avaliações do Atleta",
                  style: principalFont.bold(color: Colors.white, fontSize: 25),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: FutureBuilder<List<Map<String, dynamic>>>(
                    future: allJudgments,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              color: Color(0XFFA6B92E),
                              strokeWidth: 4,
                            ),
                          ),
                        );
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            "Erro ao carregar dados.",
                            style: secondFont.bold(color: Colors.white),
                          ),
                        );
                      }

                      final judgments = snapshot.data!;
                      if (judgments.isEmpty) {
                        return Center(
                          child: Text(
                            "Nenhuma avaliação encontrada.",
                            style: secondFont.bold(color: Colors.white),
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        itemCount: judgments.length,
                        itemBuilder: (context, index) {
                          return ViewAvaliation(judgment: judgments[index]);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
