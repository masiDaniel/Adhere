import 'package:flutter/material.dart';
import 'package:version_0/components/custom_text_field.dart';
import 'package:version_0/models/medicine.dart';
import 'package:version_0/models/prescriptions.dart';
import 'package:version_0/services/post_prescription_service.dart';
import 'package:version_0/services/user_log_in_service.dart';
import 'package:version_0/services/user_log_out_service.dart';
import 'package:version_0/views/prescription_details_age.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  List<prescriptionDetails> patientPrescriptions = [];

  @override
  void initState() {
    super.initState();
    fetchPatientsPrescriptions();
  }

  Future<void> fetchPatientsPrescriptions() async {
    List<prescriptionDetails> data = await getPatientsPrescriptions();
    setState(() {
      patientPrescriptions = data;
    });
  }

  List<PrescribedMedication> filterMedicationsByTime(
      List<PrescribedMedication> medications) {
    DateTime now = DateTime.now();
    String timeOfDay = now.hour >= 8 && now.hour < 10
        ? 'morning'
        : now.hour >= 13 && now.hour < 14
            ? 'afternoon'
            : now.hour >= 20 && now.hour < 21
                ? 'evening'
                : '';

    return medications.where((med) {
      if (timeOfDay == 'morning') return med.morning == true;
      if (timeOfDay == 'afternoon') return med.afternoon == true;
      if (timeOfDay == 'evening') return med.evening == true;
      return false;
    }).toList();
  }

  Future<void> _logout() async {
    try {
      await logoutUser();
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      print("error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String timeOfDay = now.hour >= 8 && now.hour < 10
        ? 'morning'
        : now.hour >= 13 && now.hour < 14
            ? 'afternoon'
            : now.hour >= 20 && now.hour < 21
                ? 'evening'
                : '${now.hour}:${now.minute}';

    // Filter the medications based on the time of day
    List<PrescribedMedication> filteredMedications = [];
    for (var prescription in patientPrescriptions) {
      var medications = prescription.prescribedMedications ?? [];
      filteredMedications.addAll(filterMedicationsByTime(medications));
    }

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            // Navigate to profile or another page
                          },
                          child: const CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/logo.jpeg'),
                            radius: 40,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Welcome back, $firstName",
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 20),
                        const Icon(Icons.notification_add),
                        const SizedBox(width: 20),
                        Tooltip(
                          message: 'Log Out',
                          child: IconButton(
                              onPressed: _logout,
                              icon: const Icon(Icons.logout)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    CustomTestField(
                      hintForTextField: 'search',
                      obscureInputedText: false,
                      myController: searchController,
                      onChanged: (value) {
                        print(value);
                      },
                      suffixIcon: Icons.search,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 450,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color.fromARGB(255, 181, 225, 228),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Medications for $timeOfDay',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 160, // Restrict height of scrollable row
                      child: filteredMedications.isEmpty
                          ? const Center(
                              child: Text('No medications for this time'))
                          : ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: filteredMedications.length,
                              itemBuilder: (context, index) {
                                final med = filteredMedications[index];
                                return Container(
                                  width: 250,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: Card(
                                    elevation: 5,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              'Name: ${med.medicationId ?? 'N/A'}'),
                                          Text(
                                              'Dosage: ${med.dosage ?? 'N/A'}'),
                                          Text(
                                              'Instructions: ${med.instructions ?? 'N/A'}'),
                                          Text(
                                              'Duration: ${med.duration ?? 'N/A'} days'),
                                          Text(
                                              'Prescription Id: ${med.prescriptionId ?? 'N/A'}'),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Current Prescriptions',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003A45)),
              ),
              const SizedBox(height: 10),
              // add chips to filter this data at real time.
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: patientPrescriptions.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true, // Restrict ListView's height
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: patientPrescriptions.length,
                        itemBuilder: (context, index) {
                          final prescription = patientPrescriptions[index];
                          if (prescription.diagnosis == null ||
                              prescription.instructions == null) {
                            return const ListTile(
                              title:
                                  Text('Error loading prescription details.'),
                              subtitle: Text('Please check the data source.'),
                            );
                          }
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PrescriptionDetailsPage(
                                    prescription: prescription,
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                tileColor:
                                    const Color.fromARGB(255, 57, 150, 142),
                                title: Text(
                                    'Diagnosis: ${prescription.diagnosis ?? 'N/A'}'),
                                subtitle: Text(
                                    'Instructions: ${prescription.instructions ?? 'N/A'}'),
                                trailing: const Icon(Icons.navigate_next),
                              ),
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
