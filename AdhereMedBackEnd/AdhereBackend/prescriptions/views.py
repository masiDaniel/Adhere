import binascii
from django.http import JsonResponse
from rest_framework import status, generics
from rest_framework.response import Response
from rest_framework.views import APIView
from .serializers import MedicaionSerializer, PrescribedMedicationSerializer, PrescriptionSerializer, PrescribedMedication
from .models import Medication, PrescribedMedication, Prescription
from django.core.files.base import ContentFile
from base64 import b64decode

class PrescriptionCreateAPIView(APIView):
    def post(self, request, *args, **kwargs):
        #copy of the data
        prescription_data = request.data.copy() 

        # Extract and remove images data from request data
        images_data = prescription_data.pop('images', [])

        serializer = PrescriptionSerializer(data=request.data, context={'request': request})
        if serializer.is_valid():
            serializer.save()
            prescription = serializer.save()
            # Process and save images
            for image_data in images_data:
                filename = image_data.get('filename')
                image_data_base64 = image_data.get('data')
              
                try:
                     # Decode Base64 image data
                    image_data_decoded = b64decode(image_data_base64)
                    # Save image to prescription
                    prescription.images.create(
                        filename=filename,
                        image=ContentFile(image_data_decoded, name=filename)
                    )
                except binascii.Error as e:
                    # Handle incorrect padding error
                    return JsonResponse({'error': 'Incorrect padding in Base64 encoded image data'}, status=status.HTTP_400_BAD_REQUEST)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    

class DoctorPrescriptionListView(APIView):

    def get(self, request):

        doctor = request.user.doctor

        prescriptions = Prescription.objects.filter(doctor=doctor)

        serializer = PrescriptionSerializer(prescriptions, many=True)

        return Response(serializer.data, status=status.HTTP_200_OK)

class PatientPrescriptionListView(APIView):

    def get(self, request):

        patient = request.user.patient

        prescriptions = Prescription.objects.filter(patient=patient)

        serializer = PrescriptionSerializer(prescriptions, many=True)

        return Response(serializer.data, status=status.HTTP_200_OK)


class createMedicationAPIView(APIView):

    def post(self, request):
        serializer =   MedicaionSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class MedicationListAPIView(APIView):
    def get(self, request):
        queryset = Medication.objects.all()

        serialzer = MedicaionSerializer(queryset, many=True)

        return Response(serialzer.data, status=status.HTTP_200_OK)
    
class PrescribedMeicationsAPIView(APIView):

    def post(self, request):
        serializer = PrescribedMedicationSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def get(self, request):
       
        queryset = PrescribedMedication.objects.all()
        serializer = PrescribedMedicationSerializer(queryset, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
class PrescriptionList(generics.ListAPIView):
    #this should be handeled seaperately
    queryset = Prescription.objects.all()
    serializer_class = PrescriptionSerializer

    def post(self, request):
        serializer = PrescribedMedicationSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
