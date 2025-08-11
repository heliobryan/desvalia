import 'dart:developer';
import 'package:des/src/Commom/rest_client.dart';

class EvaluationService {
  final RestClient _restClient;

  EvaluationService(this._restClient);

  Future<Map<String, dynamic>?> fetchEvaluationData(int userId) async {
    try {
      final response = await _restClient.get('api/users/$userId');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final participant = data['participant'];
          if (participant is Map<String, dynamic>) {
            final participantId = participant['id'];
            final evaluations =
                participant['evaluations'] as List<dynamic>? ?? [];

            if (evaluations.isNotEmpty) {
              final evaluationId = evaluations.first['id'];
              return {
                'participant_id': participantId,
                'evaluation_id': evaluationId,
              };
            }
          }
        }
      }
    } catch (e) {
      log('Error fetching evaluation data: $e');
    }
    return null;
  }

  Future<void> submitScore({
    required int evaluationId,
    required int itemId,
    required int participantId,
    required double score,
    required String athleteName,
  }) async {
    try {
      final payload = {
        "evaluation_id": evaluationId,
        "item_id": itemId,
        "participant_id": participantId,
        "score": score,
      };

      final response = await _restClient.post(
        'api/judgments',
        data: payload,
      );

      if (response.statusCode != 201) {
        log("Error sending score for $athleteName: ${response.statusCode} - ${response.data}");
        throw Exception("Error sending score");
      }

      log("Score successfully submitted for $athleteName: $score");
    } catch (e) {
      log("Exception sending score for $athleteName: $e");
      rethrow;
    }
  }

  Future<void> postEvaluationScore({
    required int evaluationId,
    required int itemId,
    required int participantId,
    required double score,
  }) async {
    try {
      final payload = {
        "evaluation_id": evaluationId,
        "item_id": itemId,
        "participant_id": participantId,
        "score": score,
      };

      final response = await _restClient.post(
        'api/judgments',
        data: payload,
      );

      if (response.statusCode != 201) {
        log("Error sending score: ${response.statusCode} - ${response.data}");
        throw Exception("Error sending score");
      }

      log("Score successfully submitted: $score");
    } catch (e) {
      log("Exception sending score: $e");
      rethrow;
    }
  }
}
