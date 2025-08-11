// measurable_service.dart
// measurable_service.dart
import 'dart:developer';
import 'package:des/src/Commom/rest_client.dart';
import 'package:des/src/Modules/Subcriteria/Services/fetch_evaluations.dart';
import 'package:des/src/Modules/Subcriteria/Services/get_participants.dart';

class SendValues {
  final RestClient restClient;
  final EvaluationService evaluationService;

  SendValues(String token)
      : restClient = RestClient(token: token),
        evaluationService = EvaluationService(RestClient(token: token));

  Future<List<Map<String, dynamic>>> loadFilteredAthletes(String token) async {
    try {
      final athletes = await GetParticipants.fetchAthletes(token);

      final futures = athletes.map((athlete) async {
        final user = athlete['user'];
        if (user == null) return null;

        final userId = user['id'] as int;
        final evalData = await evaluationService.fetchEvaluationData(userId);

        if (evalData != null && evalData['evaluation_id'] != null) {
          return athlete;
        }
        return null;
      });

      final results = await Future.wait(futures);
      final filtered =
          results.where((e) => e != null).cast<Map<String, dynamic>>().toList();

      return filtered;
    } catch (e) {
      log('Erro em loadFilteredAthletes: $e');
      rethrow;
    }
  }

  Future<bool> submitScores({
    required List<Map<String, dynamic>> results,
    required List<Map<String, dynamic>> filteredAthletes,
    required int itemId,
  }) async {
    bool allSuccess = true;

    for (final result in results) {
      try {
        final athleteData = filteredAthletes.firstWhere(
          (a) {
            final user = a['user'];
            final fullName = user != null
                ? '${user['name'] ?? ''} ${user['last_name'] ?? ''}'.trim()
                : '';
            return fullName == result['name'];
          },
          orElse: () => {},
        );

        if (athleteData.isEmpty) {
          allSuccess = false;
          continue;
        }

        final userId = athleteData['user']['id'] as int;
        final evalData = await evaluationService.fetchEvaluationData(userId);

        if (evalData == null) {
          allSuccess = false;
          continue;
        }

        final evaluationId = evalData['evaluation_id'] as int;
        final participantId = evalData['participant_id'] as int;

        await evaluationService.submitScore(
          evaluationId: evaluationId,
          itemId: result['item_id'],
          participantId: participantId,
          score: result['score'],
          athleteName: result['name'],
        );

        log('Score enviado para ${result['name']} com sucesso.');
      } catch (e) {
        log('Erro ao enviar score para ${result['name']}: $e');
        allSuccess = false;
      }
    }

    return allSuccess;
  }
}
