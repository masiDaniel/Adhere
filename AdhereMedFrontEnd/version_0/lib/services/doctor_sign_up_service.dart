import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:version_0/models/user.dart';

const Map<String, String> headers = {
  "Content-Type": "application/json",
};

/// what is the difference of using Future<UserSignUp?> fetchUserSignIp and just writting Future fetchUserSignUp?
///
Future<UserSignUp?> fetchDoctorSignUp(String firstName, String lastName,
    String email, String password, String liscense_no, String specialty) async {
  try {
    final response = await http.post(
        Uri.parse("http://127.0.0.1:8000/accounts/doctorsignup/"),
        headers: headers,
        body: jsonEncode({
          "first_name": firstName,
          "last_name": lastName,
          "email": email,
          "password": password,
          "user_type": "doctor",
          "license_number": liscense_no,
          "specialty": specialty
        }));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('message') &&
          jsonResponse["message"] == "User successfully registered.") {
        return UserSignUp.fromJson(jsonResponse);
      } else {
        throw Exception("server returned status: ${response.statusCode}");
      }
    } else {
      throw Exception("request failed with status: ${response.statusCode}");
    }
  } catch (e) {
    rethrow;
  }
}
