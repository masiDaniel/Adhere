from rest_framework import serializers
from .models import Medication, PrescribedMedication, Prescription


class PrescribedMedicationSerializer(serializers.ModelSerializer):
    class Meta:
        model = PrescribedMedication
        fields = ['id', 'prescription', 'medication', 'dosage', 'instructions', 'morning', 'afternoon', 'evening', 'duration']

    def create(self, validated_data):
        prescribedMeds = PrescribedMedication.objects.create(**validated_data)

        return prescribedMeds
    

class PrescriptionSerializer(serializers.ModelSerializer):
    prescribed_medications = PrescribedMedicationSerializer(many=True, read_only=True, source='prescribedmedication_set')

    class Meta:
        model = Prescription
        fields = ['id', 'doctor', 'patient', 'instructions', 'diagnosis', 'prescribed_medications']
        read_only_fields = ['id', 'created_at']

    def create(self, validated_data):
        # Extract the authenticated doctor from the request
        doctor = self.context['request'].user.doctor
        # Assign the doctor to the prescription
        validated_data['doctor'] = doctor
        # Create the prescription
        prescription = Prescription.objects.create(**validated_data)
        return prescription
    
class MedicaionSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medication
        fields = ['id', 'name', 'instructions', 'images']

    def create(self, validated_data):
        medication = Medication.objects.create(**validated_data)
        return medication
    

