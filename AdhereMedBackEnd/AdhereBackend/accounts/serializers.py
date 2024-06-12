from accounts.models import CustomUser, Doctor, Patient
from rest_framework import serializers


class DoctorSerializer(serializers.ModelSerializer):
    user_id = serializers.IntegerField(source='user.id', read_only=True)
    first_name = serializers.CharField(source='user.first_name', read_only=True)
    last_name = serializers.CharField(source='user.last_name', read_only=True)

    class Meta:
        model = Doctor
        fields = ['user_id','first_name', 'last_name','license_number', 'specialty', ]

class PatientSerializer(serializers.ModelSerializer):
    user_id = serializers.IntegerField(source='user.id', read_only=True)
    first_name = serializers.CharField(source='user.first_name', read_only=True)
    last_name = serializers.CharField(source='user.last_name', read_only=True)

    class Meta:
        model = Patient
        fields = ['user_id','first_name', 'last_name','identification_number', 'date_of_birth']


class AccountSerializer(serializers.ModelSerializer): 

    doctor = DoctorSerializer(required=False)
    patient = PatientSerializer(required=False)

    class Meta:
        model = CustomUser
        fields = ['id', 'password', 'last_login', 'username', 'first_name',
                  'last_name', 'date_joined', 'email', 'profile_pic', 'doctor', 'patient'
                  ]
        
        extra_kwargs = {
            "password": {"write_only": True}
        }

    def create(self, validated_data):
        """
        Creates a new user profile from the request's data
        """
        doctor_data = validated_data.pop('doctor', None)
        patient_data = validated_data.pop('patient', None)
        
        account = CustomUser(**validated_data)
        account.set_password(account.password)
        account.save()

        if doctor_data:
            Doctor.objects.create(user=account, **doctor_data)
        
        if patient_data:
            Patient.objects.create(user=account, **patient_data)
        


        # user_profile = UserProfileModel.objects.create(account=account, **validated_data)
        return account
    
    def update(self, instance, validated_data):
        """
        Updates a user's profile from the request's data
        """
        instance.set_password(instance.password)
        validated_data["password"] = instance.password
        return super().update(instance, validated_data)

class MessageTokenSerializer(serializers.Serializer):
    message = serializers.CharField(max_length=100)
    token = serializers.CharField(max_length=100)

class MessageSerializer(serializers.Serializer):
    message = serializers.CharField(max_length=100)

