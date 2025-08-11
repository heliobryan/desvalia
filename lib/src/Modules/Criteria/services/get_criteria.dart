import 'package:des/src/Commom/rest_client.dart';
import 'dart:developer';

class CriteriaService {
  final RestClient _restClient;

  CriteriaService(this._restClient);

  Future<List<dynamic>> getCriteria({int page = 1, int perPage = 1000}) async {
    try {
      final response = await _restClient.get(
        'api/criteria',
        queryParameters: {
          'page': page,
          'perPage': perPage,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> && data['data'] is List) {
          return data['data'] as List<dynamic>;
        } else {
          throw Exception('Formato inesperado da resposta da API');
        }
      } else {
        log('Erro statusCode: ${response.statusCode}');
        throw Exception('Erro ao buscar critérios');
      }
    } catch (e) {
      log('Erro em getCriteria: $e');
      throw Exception('Erro ao buscar critérios');
    }
  }
}
