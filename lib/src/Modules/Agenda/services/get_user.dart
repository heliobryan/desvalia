import 'dart:developer';
import 'package:des/src/Commom/rest_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeServices {
  final RestClient _restClient;

  HomeServices(this._restClient);

  Future<String> loadToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    return token ?? '';
  }

  Future<Map<String, dynamic>?> userInfo() async {
    try {
      final token = await loadToken();

      // Atualiza token no RestClient (caso tenha mudado)
      _restClient.updateToken(token);

      final response = await _restClient.get('api/user');

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return response.data as Map<String, dynamic>;
        } else {
          return {};
        }
      } else {
        log('Erro ao buscar info do usuário: ${response.statusCode}');
        return {};
      }
    } catch (e, st) {
      log('Erro ao recuperar informações do usuário: $e\n$st');
    }
    return null;
  }
}
