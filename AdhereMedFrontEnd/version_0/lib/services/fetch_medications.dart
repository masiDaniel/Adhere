import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:version_0/models/medicine.dart';
import 'package:version_0/services/user_log_in_service.dart';

List<MedicineDetails>? medicinesTouseRevised;

Future<List<MedicineDetails>?> fetchMedicationsRevised() async {
  // Make an HTTP GET request to fetch medications from the backend
  try {
    final headersWithToken = {
      ...headers,
      'Authorization': 'Token $authToken',
    };
    var response = await http.get(
      Uri.parse('http://127.0.0.1:8000/prescriptions/medications/'),
      headers: headersWithToken,
    );

    if (response.statusCode == 200) {
      // If the request is successful, parse the response body
      // and update the list of medications
      List<dynamic> data = json.decode(response.body);
      medicinesTouseRevised =
          data.map((item) => MedicineDetails.fromJson(item)).toList();
      return medicinesTouseRevised;
    } else {
      // If the request fails, handle the error (e.g., show an error message)
      print('Failed to fetch medications: ${response.statusCode}');
    }
  } catch (e) {
    print('Error fetching medications: $e');
  }
  return null;
}
