from django.contrib import admin

from prescriptions.models import Medication, Prescription, PrescribedMedication

# Register your models here.
admin.site.register(Prescription)
admin.site.register(Medication)
admin.site.register(PrescribedMedication)