import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GetParticipantInfo {
  static Future<Map<String, dynamic>> fetchBasicInfo(int participantID) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    };

    final url = Uri.parse(
      '${dotenv.env['API_HOST']}api/participants/$participantID',
    );

    final response = await http.get(url, headers: headers);

    log('Status da resposta HTTP: ${response.statusCode}');
    if (response.statusCode != 200) {
      log('Erro ao buscar dados do participante: ${response.statusCode}');
      throw Exception(
          'Erro ao buscar dados do participante: ${response.statusCode}');
    }

    final data = jsonDecode(response.body);

    final Map<String, dynamic> participant = {
      'id': data['id'],
      'name': data['user']?['name'] ?? 'Sem nome',
      'last_name': data['user']?['last_name'] ?? 'Sem sobrenome',
      'photo': data['user']?['photo_temp'],
      'team': data['team'],
      'position': data['position'],
      'category': data['category'],
      "overall": data['overall'],
      'stats': data['stats'] ?? {},
    };

    log('--- Dados processados para retorno ---');
    participant.forEach((key, value) {
      log('$key = $value');
    });

    return participant;
  }
}
