import 'dart:developer';
import 'package:des/src/Commom/rest_client.dart';

class GetParticipantInfo {
  final RestClient restClient;

  GetParticipantInfo(this.restClient);

  Future<Map<String, dynamic>> fetchBasicInfo(int participantID) async {
    try {
      final response = await restClient.get('api/participants/$participantID');

      if (response.statusCode != 200) {
        log('Erro ao buscar dados do participante: ${response.statusCode}');
        throw Exception(
            'Erro ao buscar dados do participante: ${response.statusCode}');
      }

      final data = response.data;

      final Map<String, dynamic> participant = {
        'id': data['id'],
        'name': data['user']?['name'] ?? 'Sem nome',
        'last_name': data['user']?['last_name'] ?? 'Sem sobrenome',
        'photo': data['user']?['photo_temp'],
        'team': data['team'],
        'position': data['position'],
        'category': data['category'],
        'overall': data['overall'],
        'stats': data['stats'] ?? {},
      };

      log('--- Dados processados para retorno ---');
      participant.forEach((key, value) {
        log('$key = $value');
      });

      return participant;
    } catch (e) {
      log('Erro em fetchBasicInfo: $e');
      rethrow;
    }
  }
}
