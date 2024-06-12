import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:version_0/components/sutom_button.dart';
import 'package:version_0/models/medicine.dart';
import 'package:http/http.dart' as http;
import 'package:version_0/models/prescriptions.dart';
import 'package:version_0/services/user_log_in_service.dart';

class PrescriptionDetailPage extends StatefulWidget {
  final int? prescriptionId;

  PrescriptionDetailPage({required this.prescriptionId});

  @override
  State<PrescriptionDetailPage> createState() => _PrescriptionDetailPageState();
}

class _PrescriptionDetailPageState extends State<PrescriptionDetailPage> {
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

  Future<void> postMedicationDetails() async {
    try {
      final List<Future<void>> postRequests = [];

      for (var medicine in selectedMedicines) {
        final medication = MedicationForPrsescrition(
          prescription_id: widget.prescriptionId,
          // problem here
          medication_id: 2,
          dosage: medicine.dosage,
          instructions: medicine.instructions,
          moring: isPressedMorning,
          afternoon: isPressedAfternoon,
          evening: isPressedEvening,
          duration: 5,
        );

        final headersWithToken = {
          ...headers,
          'Authorization': 'Token $authToken',
        };

        postRequests.add(http.post(
          Uri.parse('http://127.0.0.1:8000/prescriptions/medications/'),
          headers: headersWithToken,
          body: jsonEncode(medication.tojson()),
        ));
      }

      await Future.wait(postRequests);

      setState(() {
        selectedMedicines.clear();
        isPressedMorning = false;
        isPressedAfternoon = false;
        isPressedEvening = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Medication details submitted successfully.'),
      ));
    } catch (e) {
      print('Error posting medication details: $e');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to submit medication details. Please try again.'),
      ));
    }
  }

  void onSubmitPressed() {
    postMedicationDetails();
  }

  @override
  Widget build(BuildContext context) {
    String baseUrl = 'http://127.0.0.1:8000';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Details'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
                'Loading details for prescription ID: ${widget.prescriptionId}...'),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search Medications',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _filteredMedicines = _medicines
                      .where((medicine) => medicine.name
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .map((medicine) => medicine.name)
                      .toList();
                });
              },
            ),
            const SizedBox(height: 16),
            _filteredMedicines.isEmpty
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Text("Medication not found"),
                  )
                : SizedBox(
                    height: 200,
                    child: ListView.builder(
                        itemCount: _filteredMedicines.length,
                        itemBuilder: (context, index) {
                          final medicine = _filteredMedicines[index];
                          return CheckboxListTile(
                              title: Text(medicine),
                              value: selectedMedicines
                                  .any((element) => element.name == medicine),
                              onChanged: (value) {
                                setState(() {
                                  if (value!) {
                                    selectedMedicines.add(MedicineDetails(
                                        name: medicine,
                                        dosage: '',
                                        instructions: '',
                                        images: ''));
                                  } else {
                                    selectedMedicines.removeWhere(
                                        (element) => element.name == medicine);
                                  }
                                });
                              });
                        }),
                  ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 16,
                ),
                const Text('Selected medicines:'),
                selectedMedicines.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('No medicines selected yet'),
                      )
                    : SizedBox(
                        width: 800,
                        height: 300,
                        child: ListView.builder(
                            itemCount: selectedMedicines.length,
                            itemBuilder: (context, index) {
                              final selectedMedicine = selectedMedicines[index];
                              print(
                                  'Image URL: ${baseUrl + selectedMedicine.images}');
                              print('Base URL: $baseUrl');
                              print('Image Path: ${selectedMedicine.images}');

                              // Concatenate base URL and image path to form the complete image URL
                              String imageUrl =
                                  baseUrl + selectedMedicine.images;
                              print('Complete Image URL: $imageUrl');
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      height: 200,
                                      width: 250,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            10), // Adjust the radius as needed
                                        child: Column(
                                          children: [
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(
                                                  10), // Adjust the radius as needed
                                              child: Container(
                                                color: const Color.fromARGB(
                                                    255, 20, 166, 211),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child:
                                                      (selectedMedicine.images)
                                                              .isNotEmpty
                                                          ? Image.network(
                                                              baseUrl +
                                                                  selectedMedicine
                                                                      .images,
                                                              height: 160,
                                                              width: 250,
                                                              fit: BoxFit.cover,
                                                            )
                                                          : Image.asset(
                                                              'assets/images/logo.jpeg', // Path to placeholder image
                                                              height: 160,
                                                              width: 250,
                                                              fit: BoxFit.cover,
                                                            ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 4,
                                            ),
                                            Text(
                                              selectedMedicine.name,
                                              style: const TextStyle(
                                                  color: Color.fromARGB(
                                                      255, 0, 0, 0)),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Expanded(
                                        flex: 2,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 5,
                                            ),

                                            // there is an issue with the inputs for these, set state is not working to my advantage
                                            //  alsp how will i get the input from the input forms to my service?

                                            TextFormField(
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedMedicines[index]
                                                      .dosage = value;
                                                });
                                              },
                                              decoration: const InputDecoration(
                                                labelText: 'Dosage',
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            TextFormField(
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedMedicines[index]
                                                      .instructions = value;
                                                });
                                              },
                                              decoration: const InputDecoration(
                                                labelText: 'Instructions',
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),

                                            // add a boolean for each drug to indicate moring afternoon or evening
                                            const SizedBox(
                                              height: 35,
                                            ),
                                            SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        // Toggle the value of isPressed
                                                        isPressedMorning =
                                                            !isPressedMorning;
                                                      });
                                                    },
                                                    child: Material(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      elevation: 5,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        child: Container(
                                                          height: 60,
                                                          width: 70,
                                                          color:
                                                              isPressedMorning
                                                                  ? Colors.blue
                                                                  : Colors.grey,
                                                          child: const Center(
                                                            child: Text(
                                                              'Morning',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        // Toggle the value of isPressed
                                                        isPressedAfternoon =
                                                            !isPressedAfternoon;
                                                      });
                                                    },
                                                    child: Material(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      elevation: 5,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        child: Container(
                                                          height: 60,
                                                          width: 70,
                                                          color:
                                                              isPressedAfternoon
                                                                  ? Colors.blue
                                                                  : Colors.grey,
                                                          child: const Center(
                                                            child: Text(
                                                              'Afternoon',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),

                                                  // shoiuld have a clickale widget that turns bluewhen pressed but normally is grey
                                                  GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        // Toggle the value of isPressed
                                                        isPressedEvening =
                                                            !isPressedEvening;
                                                      });
                                                    },
                                                    child: Material(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                      elevation: 5,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        child: Container(
                                                          height: 60,
                                                          width: 70,
                                                          color:
                                                              isPressedEvening
                                                                  ? Colors.blue
                                                                  : Colors.grey,
                                                          child: const Center(
                                                            child: Text(
                                                              'evening',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        )),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                  ],
                                ),
                              );
                            }),
                      )
              ],
            ),
            CustomButton(
                buttonText: "submit",
                onPressed: onSubmitPressed,
                width: 100,
                height: 40,
                color: const Color(0xFF003A45)),
          ],
        ),
        // Replace the above line with actual logic to fetch and display prescription details using the prescriptionId
      ),
    );
  }
}
