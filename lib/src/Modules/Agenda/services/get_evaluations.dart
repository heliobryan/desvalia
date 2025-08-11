import 'package:des/src/Commom/rest_client.dart';

class GetEvaluationsService {
  final RestClient _restClient;

  GetEvaluationsService(this._restClient);

  Future<List<Map<String, dynamic>>> fetchEvaluations(
      {int page = 1, int perPage = 1000}) async {
    try {
      final response = await _restClient.get(
        'api/evaluations',
        queryParameters: {
          'page': page,
          'perPage': perPage,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['data'] is List) {
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception('Formato inesperado da resposta da API');
        }
      } else {
        throw Exception('Erro ao buscar avaliações: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar avaliações: $e');
    }
  }
}
