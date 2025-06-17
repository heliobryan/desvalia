import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

Future<List> getCriteria() async {
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    log('Token: $token');

    var url =
        Uri.parse('${dotenv.env['API_HOST']}api/criteria?page=1&perPage=1000');

    var restAwnser = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (restAwnser.statusCode == 200) {
      final decode = jsonDecode(restAwnser.body);
      final data = decode['data'];
      return data;
    } else {
      log('Erro statusCode: ${restAwnser.statusCode}');
      throw Exception('Erro ao buscar critérios');
    }
  } catch (e) {
    log('Erro em getCriteria: $e');
    throw Exception('Erro ao buscar critérios');
  }
}
