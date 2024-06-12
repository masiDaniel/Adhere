from django.contrib import admin
from accounts.models import CustomUser, Doctor, Patient

# Register your models here.
admin.site.register(CustomUser)
admin.site.register(Doctor)
admin.site.register(Patient)