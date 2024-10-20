import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:version_0/models/medicine.dart';
import 'package:http/http.dart' as http;
import 'package:version_0/services/post_prescription_service.dart';
import 'package:version_0/services/user_log_in_service.dart';

class PrescriptionFormPage extends StatefulWidget {
  @override
  _PrescriptionFormPageState createState() => _PrescriptionFormPageState();
}

class _PrescriptionFormPageState extends State<PrescriptionFormPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _patientIdController = TextEditingController();
  final TextEditingController _patientDiagnosisController =
      TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  bool isPressedMorning = false;
  bool isPressedAfternoon = false;
  bool isPressedEvening = false;

  List<MedicineDetails> selectedMedicines = [];
  List<MedicineDetails> _medicines = [];
  List<String> _filteredMedicines = [];

  @override
  void initState() {
    super.initState();
    // _filteredMedicines.addAll(_medicines);
    _fetchMedications();
  }

  Map<String, String> headers = {
    "Content-Type": "application/json",
  };
  Future<void> _fetchMedications() async {
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
        print('Ressponse body ${response.body}');
        print('Response Status Code: ${response.statusCode}');

        setState(() {
          _medicines =
              data.map((item) => MedicineDetails.fromJson(item)).toList();
          print('MedicineDetails Objects: $_medicines');
          _filteredMedicines
              .addAll(_medicines.map((medicine) => medicine.name));
        });

        // print("the private variable ${_medicines}");
      } else {
        // If the request fails, handle the error (e.g., show an error message)
        print('Failed to fetch medications: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching medications: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // String baseUrl = 'http://127.0.0.1:8000';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Added a GlobalKey for form validation
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _patientNameController,
                decoration: const InputDecoration(labelText: 'Patient Name'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter patient name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _patientIdController,
                decoration: const InputDecoration(labelText: 'Patient ID'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter patients Id number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(labelText: 'Instructions'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter  prescription instructions';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _patientDiagnosisController,
                decoration: const InputDecoration(labelText: 'diagnosis'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the diagnosis';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String patientName = _patientNameController.text;
                    int? patientId = int.tryParse(_patientIdController.text);

                    String instructions = _instructionsController.text;
                    String diagnosis = _patientDiagnosisController.text;

                    // there is an issue here that needs to be sorted.
                    dynamic result = postPrescription(
                        userId, patientId, instructions, diagnosis);

                    print("the result is${result}");
                    // Show a SnackBar with a success message
                    if (result == 201) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '$patientName\'s Prescription submitted successfully!'),
                          duration: Duration(seconds: 2),
                        ),
                      );

                      _patientNameController.clear();
                      _patientIdController.clear();
                      _instructionsController.clear();
                      _patientDiagnosisController.clear();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              '$patientName\'s Prescription not submitted!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  }

                  // postPrescription(userId, patient, medication, dosage, instructions, created_at, images)
                },
                child: const Text('Submit Prescription'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
