class MedicineDetails {
  late final String name;
  late final String dosage;
  late final String instructions;
  late final String images;

  MedicineDetails({
    required this.name,
    required this.dosage,
    required this.instructions,
    required this.images,
  });

  factory MedicineDetails.fromJson(Map<String, dynamic> json) {
    try {
      // print('Parsing JSON for MedicineDetails: $json');
      return MedicineDetails(
        name: json['name'] ?? '',
        dosage: json['dosage'] ?? '',
        instructions: json['instructions'] ?? '',
        images: json['images'] ?? '',
      );
    } catch (e) {
      print('Error parsing medicine details: $e');
      // Return a default instance or throw an error depending on your use case
      return MedicineDetails(
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
  final int? PrescribedmedicationId;
  final int? prescriptionId;
  final int? medicationId;
  final String? dosage;
  final String? instructions;
  final bool? morning;
  final bool? afternoon;
  final bool? evening;
  final int? duration;

  PrescribedMedication(
      this.PrescribedmedicationId,
      this.prescriptionId,
      this.medicationId,
      this.dosage,
      this.instructions,
      this.morning,
      this.afternoon,
      this.evening,
      this.duration);

  // factory PrescribedMedication.fromJson(Map<String, dynamic> json) {
  //   try {

  //     return PrescribedMedication(
  //       prescriptionmedicationId: json['id'] ?? '',
  //       prescriptionId: json['prescription'] ?? '',
  //       medication: json['medication'] ?? '',
  //       dosage: json['dosage'] ?? '',
  //       Instructions: json['instructions'] ?? '',
  //       morning: json['morning'] ?? '',
  //       afternoon: json['afternoon'] ?? '',
  //       evening: json['evening'] ?? '',

  //     );
  //   } catch (e) {
  //     print('Error parsing medicine details: $e');
  //     // Return a default instance or throw an error depending on your use case
  //     return PrescribedMedication(
  //       prescriptionmedicationId
  //       name: '',
  //       dosage: '',
  //       instructions: '',
  //       images: '',
  //     );
  //   }
  // }

  Map<String, dynamic> toJson() {
    return {
      'id': PrescribedmedicationId,
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
