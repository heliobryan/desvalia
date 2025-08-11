import 'dart:developer';
import 'package:des/src/Commom/rest_client.dart';

class GetParticipantEvaluations {
  final RestClient restClient;

  GetParticipantEvaluations(this.restClient);

  Future<List<Map<String, dynamic>>> fetchJudgments(int participantID) async {
    try {
      // 1. Buscar participante
      final participantResponse =
          await restClient.get('api/participants/$participantID');

      if (participantResponse.statusCode != 200) {
        throw Exception(
            'Erro ao buscar participante: ${participantResponse.statusCode}');
      }

      final participantData = participantResponse.data;

      final List evaluations = participantData['evaluations'] ?? [];
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
      final evaluationResponse =
          await restClient.get('api/evaluations/$evaluationId');

      if (evaluationResponse.statusCode != 200) {
        throw Exception(
            'Erro ao buscar avaliação: ${evaluationResponse.statusCode}');
      }

      final evaluationData = evaluationResponse.data;
      final List<dynamic> judgmentsList = evaluationData['judgments'] ?? [];

      // Garantindo que seja lista de Map<String, dynamic>
      final List<Map<String, dynamic>> judgments = judgmentsList
          .map<Map<String, dynamic>>((e) => Map<String, dynamic>.from(e))
          .toList();

      // 3. Injetar dados do usuário em cada judgment
      for (var judgment in judgments) {
        judgment['user'] = {
          'name': userName,
          'photo_temp': userPhoto,
        };
      }

      return judgments;
    } catch (e) {
      log('Erro em fetchJudgments: $e');
      rethrow;
    }
  }
}
