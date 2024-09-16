from django.db import models
from accounts.models import Doctor, Patient

class Medication(models.Model):
    name = models.CharField(max_length=50)
    instructions = models.TextField()
    images = models.ImageField(upload_to='medication_images/', blank=True, null=True)

    def image_count(self):
        return self.medication_images.count()

    @property
    def can_add_image(self):
        return self.image_count() < 6

    def __str__(self):
        return self.name

class Prescription(models.Model):
    doctor = models.ForeignKey(Doctor, on_delete=models.CASCADE)
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE)
    instructions = models.TextField()
    diagnosis = models.TextField(null=True, default='Adhere')
    created_at = models.DateTimeField(auto_now_add=True)
    # created_at_date = models.DateField()

    class Meta:
        constraints = [
            # models.UniqueConstraint(fields=['doctor', 'patient'], name='unique_prescription_per_doctor_and_medication')
        ]

    def __str__(self):
        return f"Prescription from (Dr) { self.doctor.user.first_name} to (Ptn) {self.patient.user.first_name} created at {self.created_at}"

class PrescribedMedication(models.Model):
    prescription = models.ForeignKey(Prescription, on_delete=models.CASCADE)
    medication = models.ForeignKey(Medication, on_delete=models.CASCADE)
    dosage = models.CharField(max_length=50)
    instructions = models.TextField()
    morning = models.BooleanField(null=True, default=False)
    afternoon = models.BooleanField(null=True, default=False)
    evening = models.BooleanField(null=True, default=False)
    duration = models.IntegerField()

    class Meta:
        unique_together = ()

    def __str__(self):
        return f"{self.medication.name} for Prescription from (Dr) {self.prescription.doctor.user.first_name} to (Ptn) {self.prescription.patient.user.first_name}"
