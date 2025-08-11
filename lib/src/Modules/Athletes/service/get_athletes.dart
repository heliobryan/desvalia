// ignore_for_file: implementation_imports, non_constant_identifier_names

import 'package:des/src/Commom/rest_client.dart';

class GetAthletesService {
  final RestClient _restClient;

  GetAthletesService(this._restClient);

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
        throw Exception('Erro ao buscar atletas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao buscar atletas: $e');
    }
  }
}
