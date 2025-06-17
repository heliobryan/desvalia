import 'dart:convert';
import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  Future<String> loadToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final token = sharedPreferences.getString('token');
    return token ?? '';
  }

  Future<Map<String, dynamic>?> userInfo(String token) async {
    try {
      var url = Uri.parse('${dotenv.env['API_HOST']}api/user');
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return data as Map<String, dynamic>;
      }
    } catch (e) {
      log('Error fetching user info: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchParticipantDetails(String token) async {
    try {
      log("Fetching participant details for logged user");

      var url = Uri.parse('${dotenv.env['API_HOST']}api/user');
      var response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      log("Response status: ${response.statusCode}");
      log("Response body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        final participant = data['participant'];

        if (participant != null) {
          log("Participant data: ${jsonEncode(participant)}");
          return participant as Map<String, dynamic>;
        } else {
          log("No participant data found");
        }
      } else if (response.statusCode == 403) {
        log("Authorization error: Verify token or permissions.");
      } else {
        log("Unexpected error: ${response.statusCode}");
      }
    } catch (e) {
      log('Error fetching participant details: $e');
    }
    return null;
  }
}
