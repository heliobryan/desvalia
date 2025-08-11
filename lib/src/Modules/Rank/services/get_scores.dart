import 'package:des/src/Commom/rest_client.dart';

class GetScoresService {
  final RestClient _restClient;

  GetScoresService(this._restClient);

  Future<List<Map<String, dynamic>>> fetchAthletes(
      {int page = 1, bool getAll = true}) async {
    try {
      final response = await _restClient.get(
        'api/participants',
        queryParameters: {
          'page': page,
          'getAll': getAll ? 1 : 0,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else {
          throw Exception('Resposta inesperada da API');
        }
      } else {
        throw Exception('Erro ao buscar avaliações: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar avaliações: $e');
    }
  }
}
