import 'package:flutter/material.dart';
import 'package:version_0/models/medicine.dart';
import 'package:version_0/models/prescriptions.dart';
import 'package:version_0/services/fetch_medications.dart';

class PrescriptionDetailsPage extends StatefulWidget {
  final prescriptionDetails prescription;

  const PrescriptionDetailsPage({super.key, required this.prescription});

  @override
  State<PrescriptionDetailsPage> createState() =>
      _PrescriptionDetailsPageState();
}

class _PrescriptionDetailsPageState extends State<PrescriptionDetailsPage> {
  @override
  void initState() {
    super.initState();
    fetchMedicationsRevised();
  }

  @override
  Widget build(BuildContext context) {
    final List<PrescribedMedication> prescribedMedications =
        widget.prescription.prescribedMedications ?? [];
    String getMedicineNameById(int? id) {
      try {
        // Search for the medicine with the given id
        MedicineDetails medicine =
            medicinesTouseRevised!.firstWhere((med) => med.medicationId == id);
        return medicine.name; // Return the medicine's name
      } catch (e) {
        print('Medicine with id $id not found');
        return 'Unknown Medicine'; // Handle case when no medicine is found
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Diagnosis: ${widget.prescription.diagnosis ?? 'N/A'}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Text('Instructions: ${widget.prescription.instructions ?? 'N/A'}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            const Text('Prescribed Medications:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: prescribedMedications.length,
                itemBuilder: (context, index) {
                  final medication = prescribedMedications[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20), // Apply radius here
                    ),
                    color: const Color(0xFF066464), // Apply color to the Card
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        textColor: Colors.white,
                        title: Text(
                          'Medication Name: ${getMedicineNameById(medication.medicationId)}',
                        ),
                        subtitle: Text(
                          'Dosage: ${medication.dosage}\n'
                          'Instructions: ${medication.instructions}\n'
                          'Morning: ${medication.morning == true ? 'Yes' : 'No'}\n'
                          'Afternoon: ${medication.afternoon == true ? 'Yes' : 'No'}\n'
                          'Evening: ${medication.evening == true ? 'Yes' : 'No'}\n'
                          'Duration: ${medication.duration ?? 'N/A'} days',
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
    );
  }
}
