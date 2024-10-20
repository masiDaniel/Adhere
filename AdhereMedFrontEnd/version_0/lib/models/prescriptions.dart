import 'package:version_0/models/medicine.dart';

class prescriptionDetails {
  final int? prescription_id;
  final int? doctor_id;
  final int? patient_id;
  final String? instructions;
  final String? diagnosis;
  final List<PrescribedMedication>? prescribedMedications;

  prescriptionDetails(
      {required this.prescription_id,
      required this.doctor_id,
      required this.patient_id,
      required this.instructions,
      required this.diagnosis,
      required this.prescribedMedications});

  factory prescriptionDetails.fromJson(Map<String, dynamic> json) {
    return prescriptionDetails(
      prescription_id: json['id'],
      doctor_id: json['doctor'],
      patient_id: json['patient'],
      instructions: json['instructions'],
      diagnosis: json['diagnosis'],
      prescribedMedications: (json['prescribed_medications'] as List<dynamic>?)
          ?.map(
              (medicationJson) => PrescribedMedication.fromJson(medicationJson))
          .toList(),
    );
  }

  Map<String, dynamic> tojson() {
    return {
      'id': prescription_id,
      'doctor': doctor_id,
      'patient': patient_id,
      'instructions': instructions,
      'diagnosis': diagnosis,
      'prescribed_medications':
          prescribedMedications?.map((med) => med.toJson()).toList(),
    };
  }
}

class DoctorPostPrescription {
  final int? prescription_id;
  final int? doctor_id;
  final int? patient_id;
  final String? instructions;
  final String? diagnosis;

  DoctorPostPrescription({
    required this.prescription_id,
    required this.doctor_id,
    required this.patient_id,
    required this.instructions,
    required this.diagnosis,
  });

  Map<String, dynamic> tojson() {
    return {
      'id': prescription_id,
      'doctor': doctor_id,
      'patient': patient_id,
      'instructions': instructions,
      'diagnosis': diagnosis,
    };
  }
}

class MedicationForPrsescrition {
  final int? prescription_id;
  final int? medication_id;
  final String? dosage;
  final String? instructions;
  bool moring;
  bool afternoon;
  bool evening;
  final int? duration;

  MedicationForPrsescrition(
      {required this.prescription_id,
      required this.medication_id,
      required this.dosage,
      required this.instructions,
      required this.duration,
      required this.moring,
      required this.afternoon,
      required this.evening});

  Map<String, dynamic> tojson() {
    return {
      "prescription": prescription_id,
      "medication": medication_id,
      "dosage": dosage,
      "instructions": instructions,
      "morning": moring,
      "afternoon": afternoon,
      "evening": evening,
      "duration": duration
    };
  }
}
