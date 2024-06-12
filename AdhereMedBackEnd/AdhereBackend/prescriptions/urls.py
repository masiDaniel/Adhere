from django.urls import path

from prescriptions.serializers import PrescribedMedicationSerializer
from .views import DoctorPrescriptionListView, MedicationListAPIView, PatientPrescriptionListView, PrescribedMeicationsAPIView, PrescriptionCreateAPIView, PrescriptionList,createMedicationAPIView

urlpatterns = [
    path("doctorpostprescription/", PrescriptionCreateAPIView.as_view(), name="doctorpostprescription"),
    path('doctorsprescriptions/', DoctorPrescriptionListView.as_view(), name='doctor_prescriptions'),
    path('patientsprescriptions/', PatientPrescriptionListView.as_view(), name='patient_prescriptions'),
    path('postMedication/', createMedicationAPIView.as_view(), name='post_medications'),
    path('medications/', MedicationListAPIView.as_view(), name='medications-list'),
    path("prescribedMedicationsList/", PrescribedMeicationsAPIView.as_view(), name="prescribed_medication_list"),
    path('prescribedMedications/', PrescriptionList.as_view(), name='prescription-list'),

 

]