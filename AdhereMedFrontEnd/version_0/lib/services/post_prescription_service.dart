import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:version_0/models/medicine.dart';
import 'package:version_0/models/prescriptions.dart';
import 'package:version_0/services/user_log_in_service.dart';

Future postPrescription(
  int? doctorId,
  int? patientId,
  String instructions,
  String diagnosis,
) async {
  Map<String, String> headers = {
    "Content-Type": "application/json",
    'Authorization': 'Token $authToken',
  };
  try {
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/prescriptions/doctorpostprescription/"),
      headers: headers,
      body: jsonEncode({
        "doctor": doctorId,
        "patient": patientId,
        "instructions": instructions,
        "diagnosis": diagnosis,
      }),
    );

    //look for abetter wy of doing this the return statement
    if (response.statusCode == 201) {
      print('prescription posted succesfully!');
      return 201;
    } else {
      print('failed to post prescription: ${response.statusCode}');
    }
  } catch (e) {
    print('error positng prescription: $e');
  }
  return null;
}

Future<List<prescriptionDetails>> getDoctorPrescriptions() async {
  try {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Token $authToken',
    };

    final response = await http.get(
      Uri.parse("http://127.0.0.1:8000/prescriptions/doctorsprescriptions/"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> prescribedMedicationData = json.decode(response.body);
      final List<prescriptionDetails> DoctorPrescriptionData =
          prescribedMedicationData
              .map((json) => prescriptionDetails.fromJson(json))
              .toList();
      return DoctorPrescriptionData;
    } else {
      throw Exception('failed to fetch arguments');
    }
  } catch (e) {
    rethrow;
  }
}

Future<List<prescriptionDetails>> getPatientsPrescriptions() async {
  try {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      'Authorization': 'Token $authToken',
    };

    final response = await http.get(
      Uri.parse("http://127.0.0.1:8000/prescriptions/patientsprescriptions/"),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> prescribedMedicationData = json.decode(response.body);
      print("patient pprescription ${prescribedMedicationData}");
      final List<prescriptionDetails> prescribedMeds = prescribedMedicationData
          .map((json) => prescriptionDetails.fromJson(json))
          .toList();
      return prescribedMeds;
    } else {
      throw Exception('failed to fetch arguments');
    }
  } catch (e) {
    rethrow;
  }
}

// Future<List<PrescribedMedication>> getPrescribedMedications() async {
//   try {
//     Map<String, String> headers = {
//       "Content-Type": "application/json",
//       'Authorization': 'Token $authToken',
//     };

//     final response = await http.get(
//       Uri.parse("http://127.0.0.1:8000/prescriptions/patientsprescriptions/"),
//       headers: headers,
//     );

//     if (response.statusCode == 200) {
//       final List<dynamic> prescribedMedicationData = json.decode(response.body);
//       final List<PrescribedMedication> prescribedMeds =
//           PrescribedMedication.map(
//               (json) => PrescribedMedication.fromJson(json)).toList();
//       return prescribedMeds;
//     } else {
//       throw Exception('failed to fetch arguments');
//     }
//   } catch (e) {
//     rethrow;
//   }
// }


// Future<List<MedicationForPrsescrition>> postMedicationForPrescription(
//     int? prescriptionId, int? mediactionid,
//     String? dosage, String? instructions, bool? ,or) async {
//   try {
//     Map<String, String> headers = {
//       "Content-Type": "application/json",
//       'Authorization': 'Token $authToken',
//     };

//     final response = await http.post(
//       Uri.parse("http://127.0.0.1:8000/prescriptions/doctorpostprescription/"),
//       headers: headers,
//       body: jsonEncode({
//         "doctor": doctor_id,
//         "patient": patient_id,
//         "instructions": instructions,
//         "diagnosis": diagnosis,
//       }),
//     );
//   } catch (e) {}
// }
