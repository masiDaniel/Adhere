class MedicineDetails {
  int? medicationId;
  String name;
  String? dosage;
  String? instructions;
  String images;

  MedicineDetails({
    required this.medicationId,
    required this.name,
    required this.dosage,
    required this.instructions,
    required this.images,
  });

  factory MedicineDetails.fromJson(Map<String, dynamic> json) {
    try {
      // print('Parsing JSON for MedicineDetails: $json');
      return MedicineDetails(
        medicationId: json['id'] ?? 0,
        name: json['name'] ?? '',
        dosage: json['dosage'] ?? '',
        instructions: json['instructions'] ?? '',
        images: json['images'] ?? '',
      );
    } catch (e) {
      print('Error parsing medicine details: $e');
      // Return a default instance or throw an error depending on your use case
      return MedicineDetails(
        medicationId: 0,
        name: '',
        dosage: '',
        instructions: '',
        images: '',
      );
    }
  }
}

class PostMedication {
  final String? name;
  final String? dosage;
  final String? instructions;
  PostMedication(this.name, this.dosage, this.instructions);

  Map<String, dynamic> toJson() {
    return {'name': name, 'dosage': dosage, 'instructions': instructions};
  }
}

class PrescribedMedication {
  final int? prescribedMedicationId; // Fixed naming convention
  final int? prescriptionId;
  final int? medicationId;
  final String? dosage;
  final String? instructions;
  final bool? morning;
  final bool? afternoon;
  final bool? evening;
  final int? duration;

  PrescribedMedication({
    required this.prescribedMedicationId,
    required this.prescriptionId,
    required this.medicationId,
    required this.dosage,
    required this.instructions,
    required this.morning,
    required this.afternoon,
    required this.evening,
    required this.duration,
  });

  factory PrescribedMedication.fromJson(Map<String, dynamic> json) {
    try {
      return PrescribedMedication(
        prescribedMedicationId: json['id'] as int?,
        prescriptionId: json['prescription'] as int?,
        medicationId: json['medication'] as int?,
        dosage: json['dosage'] as String?,
        instructions: json['instructions'] as String?,
        morning: json['morning'] as bool?,
        afternoon: json['afternoon'] as bool?,
        evening: json['evening'] as bool?,
        duration: json['duration'] as int?,
      );
    } catch (e) {
      print('Error parsing medicine details: $e');
      // Return a default instance or throw an error depending on your use case
      return PrescribedMedication(
        prescribedMedicationId: null,
        prescriptionId: null,
        medicationId: null,
        dosage: '',
        instructions: '',
        morning: false,
        afternoon: false,
        evening: false,
        duration: 0,
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': prescribedMedicationId,
      'prescription': prescriptionId,
      'medication': medicationId,
      'dosage': dosage,
      'instructions': instructions,
      'morning': morning,
      'afternoon': afternoon,
      'evening': evening,
      'duration': duration,
    };
  }
}
