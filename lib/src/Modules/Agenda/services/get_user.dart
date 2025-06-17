import 'dart:convert';
import 'dart:developer';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeServices {
  Future<String> loadToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    final token = sharedPreferences.getString('token');

    return token ?? '';
  }

  Future<Map<String, dynamic>?> userInfo(String? token) async {
    try {
      var url = Uri.parse('${dotenv.env['API_HOST']}api/user');
      var restAnswer = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (restAnswer.statusCode == 200) {
        final decode = jsonDecode(restAnswer.body);
        final userDados = decode;

        return userDados as Map<String, dynamic>;
      }

      return {};
    } catch (e) {
      log("Erro ao recuperar informações do usuário: $e");
    }
    return null;
  }
}
