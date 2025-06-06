import 'dart:convert';
import 'package:http/http.dart' as http;

class GetScores {
  static Future<List<Map<String, dynamic>>> fetchAthletes(String token) async {
    final url = Uri.parse(
        'https://api.des.versatecnologia.com.br/api/participants?page=1&getAll=1');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List athletes = jsonDecode(response.body);
      return athletes.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erro ao buscar avaliações: ${response.statusCode}');
    }
  }
}
