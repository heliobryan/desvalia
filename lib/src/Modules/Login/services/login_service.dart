import 'dart:developer';
import 'package:des/src/Commom/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final RestClient _restClient;

  AuthService(this._restClient);

  Future<bool> userLogin(String email, String password) async {
    try {
      final response = await _restClient.post(
        'api/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;

        final token = data['token'] as String?;

        if (token != null && token.isNotEmpty) {
          final sharedPreferences = await SharedPreferences.getInstance();
          await sharedPreferences.setString('token', token);

          log('Token recebido da API: $token');

          return true;
        } else {
          log('Token não encontrado na resposta da API');
          return false;
        }
      } else {
        log('Erro na resposta da API: ${response.statusCode} - ${response.data}');
        return false;
      }
    } catch (e) {
      log('Erro no login do usuário: $e');
      return false;
    }
  }
}
