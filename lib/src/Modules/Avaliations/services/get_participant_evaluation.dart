// ignore: file_names
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetParticipantEvaluations {
  static Future<List<Map<String, dynamic>>> fetchEvaluations(
      int participantID) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final url = Uri.parse(
      'https://api.des.versatecnologia.com.br/api/participants/$participantID',
    );

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
    log('Buscando participante com ID: $participantID');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List evaluations = data['evaluations'];
      return evaluations.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Erro ao buscar avaliações: ${response.statusCode}');
    }
  }
}
