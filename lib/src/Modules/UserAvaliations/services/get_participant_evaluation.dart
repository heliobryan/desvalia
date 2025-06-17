// ignore: file_names
import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetParticipantEvaluations {
  static Future<List<Map<String, dynamic>>> fetchJudgments(
      int participantID) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    // 1. Buscar participante
    final participantUrl = Uri.parse(
      '${dotenv.env['API_HOST']}api/participants/$participantID',
    );
    final participantResponse =
        await http.get(participantUrl, headers: headers);

    if (participantResponse.statusCode != 200) {
      throw Exception(
          'Erro ao buscar participante: ${participantResponse.statusCode}');
    }

    final participantData = jsonDecode(participantResponse.body);

    final List evaluations = participantData['evaluations'];
    final Map<String, dynamic> user = participantData['user'] ?? {};

    final String userName = user['name'] ?? 'sem nome';
    final String? userPhoto = user['photo_temp'];
    log('Usuário: $userName | Foto: ${userPhoto ?? 'sem foto'}');

    if (evaluations.isEmpty) {
      throw Exception(
          'Nenhuma avaliação encontrada para o participante $participantID');
    }

    final int evaluationId = evaluations.first['id'];
    log('Evaluation ID encontrado: $evaluationId');

    // 2. Buscar avaliação
    final evaluationUrl = Uri.parse(
      '${dotenv.env['API_HOST']}api/evaluations/$evaluationId',
    );
    final evaluationResponse = await http.get(evaluationUrl, headers: headers);

    if (evaluationResponse.statusCode != 200) {
      throw Exception(
          'Erro ao buscar avaliação: ${evaluationResponse.statusCode}');
    }

    final evaluationData = jsonDecode(evaluationResponse.body);
    final List<Map<String, dynamic>> judgments =
        (evaluationData['judgments'] as List).cast<Map<String, dynamic>>();

    // 3. Injetar dados do usuário em cada judgment
    for (var judgment in judgments) {
      judgment['user'] = {
        'name': userName,
        'photo_temp': userPhoto,
      };
    }

    return judgments;
  }
}
