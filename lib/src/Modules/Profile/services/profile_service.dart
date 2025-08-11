import 'dart:developer';
import 'package:des/src/Commom/rest_client.dart';

class ProfileService {
  final RestClient _restClient;

  ProfileService(this._restClient);

  Future<Map<String, dynamic>?> userInfo() async {
    try {
      final response = await _restClient.get('api/user');

      log("Response status: ${response.statusCode}");
      log("Response body: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          return data;
        }
      }
    } catch (e) {
      log('Error fetching user info: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> fetchParticipantDetails() async {
    try {
      log("Fetching participant details for logged user");

      final response = await _restClient.get('api/user');

      log("Response status: ${response.statusCode}");
      log("Response body: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final participant = data['participant'];

          if (participant != null && participant is Map<String, dynamic>) {
            log("Participant data: $participant");
            return participant;
          } else {
            log("No participant data found");
          }
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
