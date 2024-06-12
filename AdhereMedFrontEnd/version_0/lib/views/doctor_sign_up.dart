import 'package:flutter/material.dart';
import 'package:version_0/components/custom_text_field.dart';
import 'package:version_0/components/sutom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:version_0/models/user.dart';
import 'package:version_0/services/doctor_sign_up_service.dart';

class doctorSignUpPage extends StatefulWidget {
  const doctorSignUpPage({super.key});

  @override
  State<doctorSignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<doctorSignUpPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final TextEditingController userTypeController = TextEditingController();
  final TextEditingController liscenseNumberController =
      TextEditingController();
  final TextEditingController specialtyController = TextEditingController();

  void _doctorUserUp() async {
    String first_name = firstNameController.text.trim();
    String last_name = lastNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String liscense_no = liscenseNumberController.text.trim();
    String specialty = specialtyController.text.trim();

    /// method to check if the email structure is valid
    bool isValidEmail(String email) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(email);
    }

    if (email.isNotEmpty &&
        password.isNotEmpty &&
        first_name.isNotEmpty &&
        last_name.isNotEmpty &&
        liscense_no.isNotEmpty &&
        specialty.isNotEmpty &&
        isValidEmail(email)) {
      UserSignUp? doctorSignUp = await fetchDoctorSignUp(
          first_name, last_name, email, password, liscense_no, specialty);

      if (doctorSignUp != null) {
        // Sign in successful, navigate to the dignup screen
        Navigator.pushNamed(context, '/loginpage');
      } else {
        // Show error messageif the sign in was unsuccesful
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('An error occured during signing in, try again later'),
        ));
      }
    } else {
      // Show error message if one or either of the fields in not inputed
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in all the fields in appropriate format'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 35,
              ),
              Text(
                "Sign Up",
                style: GoogleFonts.carterOne(
                  color: const Color(0xFF003A45),
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              CustomTestField(
                hintForTextField: "First Name",
                obscureInputedText: false,
                myController: firstNameController,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTestField(
                hintForTextField: "Last Name",
                obscureInputedText: false,
                myController: lastNameController,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTestField(
                hintForTextField: "Email",
                obscureInputedText: false,
                myController: emailController,
                onChanged: (value) {},
                suffixIcon: Icons.email,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTestField(
                hintForTextField: "Password",
                obscureInputedText: false,
                myController: passwordController,
                onChanged: (value) {},
                suffixIcon: Icons.password,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTestField(
                hintForTextField: "Password confirmation",
                obscureInputedText: false,
                myController: passwordConfirmationController,
                onChanged: (value) {},
                suffixIcon: Icons.password_rounded,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTestField(
                hintForTextField: "Liscense number",
                obscureInputedText: false,
                myController: liscenseNumberController,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTestField(
                hintForTextField: "Specialty",
                obscureInputedText: false,
                myController: specialtyController,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 25,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                CustomButton(
                    buttonText: 'Sign Up',
                    onPressed: _doctorUserUp,
                    width: 100,
                    height: 40,
                    color: const Color(0xFF003A45)),
              ]),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                thickness: 2,
                color: Color(0xFF003A45),
                endIndent: 100,
                indent: 100,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/loginpage');
                },
                child: const Text(
                  'Already have an account? log in',
                  style: TextStyle(
                      color: Color.fromARGB(255, 3, 3, 3), fontSize: 18),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: MediaQuery.of(context).size.height / 3,
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    image: DecorationImage(
                        image: AssetImage(
                          'assets/images/designPoster_2.png',
                        ),
                        fit: BoxFit.fill)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
