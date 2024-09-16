import 'package:http/http.dart' as http;
import 'package:version_0/services/user_log_in_service.dart';

Map<String, String> headers = {
  "Content-Type": "application/json",
  'Authorization': 'Token $authToken',
};

Future logoutUser() async {
  try {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/accounts/logout/"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return true;
    }
  } catch (e) {
    rethrow;
  }
  return false;
}
