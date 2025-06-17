// ignore_for_file: implementation_imports, non_constant_identifier_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GetAthletes {
  static Future<List<Map<String, dynamic>>> fetchAthletes(String token) async {
    final url =
        Uri.parse('${dotenv.env['API_HOST']}api/participants?page=1&getAll=1');

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
