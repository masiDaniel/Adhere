import 'package:flutter/material.dart';
import 'package:version_0/models/medicine.dart';
import 'package:version_0/models/prescriptions.dart';

class PrescriptionDetailsPage extends StatelessWidget {
  final prescriptionDetails prescription;

  const PrescriptionDetailsPage({Key? key, required this.prescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<PrescribedMedication> prescribedMedications =
        prescription.prescribedMedications ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Prescription Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Diagnosis: ${prescription.diagnosis ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            Text('Instructions: ${prescription.instructions ?? 'N/A'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Text('Prescribed Medications:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: prescribedMedications.length,
                itemBuilder: (context, index) {
                  final medication = prescribedMedications[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                          'Medication ID: ${medication.medicationId ?? 'N/A'}'),
                      subtitle: Text(
                        'Dosage: ${medication.dosage}\n'
                        'Instructions: ${medication.instructions}\n'
                        'Morning: ${medication.morning == true ? 'Yes' : 'No'}\n'
                        'Afternoon: ${medication.afternoon == true ? 'Yes' : 'No'}\n'
                        'Evening: ${medication.evening == true ? 'Yes' : 'No'}\n'
                        'Duration: ${medication.duration ?? 'N/A'} days',
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
