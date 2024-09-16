import 'package:flutter/material.dart';
import 'package:version_0/views/Doctors_view.dart';
import 'package:version_0/views/home_page.dart';
import 'package:version_0/views/landing_page.dart';
import 'package:version_0/views/prescription_form.dart';
import 'package:version_0/views/profile_page.dart';
import 'package:version_0/views/sign_in.dart';
import 'package:version_0/views/sign_up.dart';
import 'package:version_0/views/doctor_sign_up.dart';
import 'package:version_0/views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AdhereMed',
      initialRoute: '/',
      routes: {
        '/': (context) => const splashScreen(),
        '/home': (context) => HomePage(),
        '/signuppage': (context) => const SignUpPage(),
        '/loginpage': (context) => LogInPage(),
        '/profile': (context) => const UserProfilePage(),
        '/prescriptionform': (context) => PrescriptionFormPage(),
        '/landingpage': (context) => const landingPage(),
        '/doctorspage': (context) => const DoctorsPage(),
        '/doctorSignUp': (context) => const doctorSignUpPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
