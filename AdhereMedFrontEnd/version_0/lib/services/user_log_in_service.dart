import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:version_0/models/user.dart';

const Map<String, String> headers = {
  "Content-Type": "application/json",
};

String? authToken;
String? firstName;
String? imageUrl;
String? userType;
int? userId;

Future fetchUserSignIn(String username, String password) async {
  try {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/accounts/patientlogin/"),
      headers: headers,
      body: jsonEncode({
        "email": username,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      final userData = json.decode(response.body);
      final token = userData['token'];
      final first_name = userData['first_name'];
      final currentUserId = userData['user_id'];
      userId = currentUserId;
      userType = userData['user_type'];
      // imageUrl = userData['profile_pic'];
      authToken = token;
      firstName = first_name;
      print(userId);

      return UserLogin.fromJson(userData);
    }
  } catch (e) {
    rethrow;
  }
  return null;
}
