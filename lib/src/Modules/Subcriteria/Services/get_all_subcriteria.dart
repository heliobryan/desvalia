import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<List> getSubcriteria({required int criterionId}) async {
  try {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');

    var url = Uri.parse(
        '${dotenv.env['API_HOST']}api/subcriteria?page=1&perPage=1000');

    var restAnswer = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (restAnswer.statusCode == 200) {
      final decode = jsonDecode(restAnswer.body);
      final data = decode['data'] as List;

      final filtered = data.where((sub) {
        final criterion = sub['criterion'];
        final items = sub['items'] as List?;
        return criterion != null &&
            criterion['id'] == criterionId &&
            items != null &&
            items.isNotEmpty;
      }).toList();

      return filtered;
    } else {
      throw Exception(
          'Erro ao buscar subcritérios: statusCode ${restAnswer.statusCode}');
    }
  } catch (e) {
    throw Exception('Erro ao buscar subcritérios: $e');
  }
}
