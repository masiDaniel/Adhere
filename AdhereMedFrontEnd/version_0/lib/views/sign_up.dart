import 'package:flutter/material.dart';
import 'package:version_0/components/custom_text_field.dart';
import 'package:version_0/components/sutom_button.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:version_0/models/user.dart';
import 'package:version_0/services/user_sign_up_service.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmationController =
      TextEditingController();
  final TextEditingController userTypeController = TextEditingController();
  final TextEditingController identificationNumberController =
      TextEditingController();
  final TextEditingController uniqueNumberController = TextEditingController();

  void _signUserUp() async {
    String first_name = firstNameController.text.trim();
    String last_name = lastNameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String identification_no = identificationNumberController.text.trim();
    String date_of_birth = uniqueNumberController.text.trim();

    /// method to check if the email structure is valid
    bool isValidEmail(String email) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(email);
    }

    if (email.isNotEmpty &&
        password.isNotEmpty &&
        first_name.isNotEmpty &&
        last_name.isNotEmpty &&
        identification_no.isNotEmpty &&
        date_of_birth.isNotEmpty &&
        isValidEmail(email)) {
      try {
        UserSignUp? userSignUp = await fetchUserSignUp(first_name, last_name,
            email, password, identification_no, date_of_birth);
        // print(userSignUp);
        if (userSignUp != null) {
          // Sign up successful, navigate to the login page
          Navigator.pushNamed(context, '/loginpage');
        } else {
          // Show error message if the sign up was unsuccessful
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'An error occurred during sign up. Please try again later.'),
          ));
        }
      } catch (e) {
        // Show error message if an exception occurs during sign up
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Sign up failed: $e'),
        ));
      }
    } else {
      // Show error message if one or more fields are empty or email is invalid
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill in all fields correctly.'),
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
                hintForTextField: "first name",
                obscureInputedText: false,
                myController: firstNameController,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTestField(
                hintForTextField: "last name",
                obscureInputedText: false,
                myController: lastNameController,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTestField(
                hintForTextField: "email name",
                obscureInputedText: false,
                myController: emailController,
                onChanged: (value) {},
                suffixIcon: Icons.email,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTestField(
                hintForTextField: "password",
                obscureInputedText: true,
                myController: passwordController,
                onChanged: (value) {},
                suffixIcon: Icons.password,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTestField(
                hintForTextField: "password confirmation",
                obscureInputedText: true,
                myController: passwordConfirmationController,
                onChanged: (value) {},
                suffixIcon: Icons.password_rounded,
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTestField(
                hintForTextField: "identification number",
                obscureInputedText: false,
                myController: identificationNumberController,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 10,
              ),
              CustomTestField(
                hintForTextField: "date of birth",
                obscureInputedText: false,
                myController: uniqueNumberController,
                onChanged: (value) {},
              ),
              const SizedBox(
                height: 25,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                CustomButton(
                    buttonText: 'Sign Up',
                    onPressed: _signUserUp,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                    style: TextStyle(
                        color: Color.fromARGB(255, 3, 3, 3), fontSize: 18),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/loginpage');
                    },
                    child: const Text(
                      ' log in',
                      style: TextStyle(color: Color(0xFF003A45)),
                    ),
                  ),
                ],
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
