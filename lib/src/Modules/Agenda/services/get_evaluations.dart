import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GetEvaluations {
  static Future<List<Map<String, dynamic>>> fetchEvaluations(
      String token) async {
    final url = Uri.parse(
        '${dotenv.env['API_HOST']}api/evaluations?page=1&perPage=1000');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List evaluations = jsonDecode(response.body)['data'];
      return evaluations.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erro ao buscar avaliações: ${response.statusCode}');
    }
  }
}
