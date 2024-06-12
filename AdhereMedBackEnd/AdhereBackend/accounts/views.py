from django.contrib.auth import authenticate, login, logout
from .serializers import AccountSerializer, DoctorSerializer, MessageSerializer, PatientSerializer
from knox.models import AuthToken
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from rest_framework.decorators import permission_classes
from rest_framework import status
from rest_framework.response import Response
from .models import CustomUser
from rest_framework.authtoken.models import Token

# Create your views here.

# Create your views here.
class LoginApIView(APIView):
    """
    handles User activities such as Login and Logout
    """
    permission_classes = [AllowAny]

    # TODO restrict these get request to users who are authenticated
    def get(self, request, *args, **kwargs):
        """
        Handles loging out of the user
        """
        logout(request)
        return Response({"message": "logged out succesfully."}, status=status.HTTP_200_OK)

    def post(self, request, *args, **kwargs):
        """
        Handles log in of the user
        """
        
        email = request.data.get("email")
        password = request.data.get("password")
        print(email, password)
        user = authenticate(username=email, password=password)

        # if user exists
        if user:
            # Check if the user is a doctor
            if hasattr(user, 'doctor'):
                doctor_serializer = DoctorSerializer(user.doctor)
                data = doctor_serializer.data
                data['user_type'] = 'doctor'
                # Check if the user is a patient
            elif hasattr(user, 'patient'):
                patient_serializer = PatientSerializer(user.patient)
                data = patient_serializer.data
                data['user_type'] = 'patient'
            # If neither doctor nor patient, treat as regular user
            else:
                account_serializer = AccountSerializer(user)
                data = account_serializer.data
                data['user_type'] = 'user'
            

            login(request, user)

            # Generate token for the user
            # token, created = Token.objects.get_or_create(user=user)

            # Add token to response data
            data['token'] = AuthToken.objects.create(user=user)[1]
            print(data['token'])
            
            return Response(data, status=status.HTTP_200_OK)
        # user doesn't exist
        else:
            data = {
                "message": "Invalid User Credentials",
                }
            serializer = MessageSerializer(data)
            return Response(serializer.data, status=status.HTTP_403_FORBIDDEN)


class RegisterUsersAPIView(APIView):
    """
    Handles Registration of Users (Doctors and Patients)
    """
    permission_classes = [AllowAny]

    def post(self, request, *args, **kwargs):
        """
        Handles registration of Users (Doctors and Patients)
        """
        user_data = {
            "first_name": request.data.get("first_name"),
            "last_name": request.data.get("last_name"),
            "email": request.data.get("email"),
            "password": request.data.get("password"),
        }
        # making the username same as the email
        user_data['username'] = request.data.get("email")

        # Extract doctor-specific or patient-specific data based on the user type
        if request.data.get("user_type") == "doctor":
            doctor_data = {
                "license_number": request.data.get("license_number"),
                "specialty": request.data.get("specialty")
            }
            user_data['doctor'] = doctor_data
        elif request.data.get("user_type") == "patient":
            patient_data = {
                "identification_number": request.data.get("identification_number"),
                "date_of_birth": request.data.get("date_of_birth")
            }
            user_data['patient'] = patient_data

        serializer = AccountSerializer(data=user_data)
        if serializer.is_valid():
            serializer.save()
            message = "User successfully registered."
            return Response({"message": message}, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



