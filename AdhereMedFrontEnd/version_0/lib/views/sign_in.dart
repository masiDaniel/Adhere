import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:version_0/components/custom_text_field.dart';
import 'package:version_0/components/sutom_button.dart';
import 'package:version_0/models/user.dart';
import 'package:version_0/services/user_log_in_service.dart';

class LogInPage extends StatefulWidget {
  LogInPage({super.key});

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final String type = 'doctor';

  void _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    bool isValidEmail(String email) {
      final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      return emailRegex.hasMatch(email);
    }

    if (email.isNotEmpty && password.isNotEmpty && isValidEmail(email)) {
      UserLogin? userlogin = await fetchUserSignIn(email, password);
      print(userType);

      if (userlogin != null) {
        //navigate to the homepage screen if sign in is succesfull
        if (userType == "patient") {
          Navigator.pushNamed(context, '/home');
        } else if (userType == "doctor") {
          Navigator.pushNamed(context, '/doctorspage');
        }
      } else {
        // Show error message if the sign-in was unsuccessful
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Invalid email or password'),
        ));
      }
    } else {
      // Show error message if one or both of the fields are not inputted or email format is invalid
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please enter a valid email and password'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFFFFFFF),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/splash.png',
                      ),
                      fit: BoxFit.fill)),
            ),
            const SizedBox(
              height: 30,
            ),
            Text('Login',
                style: GoogleFonts.permanentMarker(
                  color: const Color(0xFF003A45),
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(
              height: 15,
            ),
            CustomTestField(
                hintForTextField: 'Email',
                obscureInputedText: false,
                myController: _emailController,
                onChanged: (value) {}),
            const SizedBox(
              height: 15,
            ),
            CustomTestField(
              hintForTextField: 'Password',
              obscureInputedText: true,
              myController: _passwordController,
              onChanged: (value) {},
              suffixIcon: Icons.visibility,
            ),
            const SizedBox(
              height: 15,
            ),
            CustomButton(
                buttonText: "Login",
                onPressed: _signIn,
                width: 100,
                height: 40,
                color: const Color(0xFF003A45)),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Dont have an account?',
                  style: TextStyle(
                      color: Color.fromARGB(255, 3, 3, 3), fontSize: 18),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/signuppage');
                  },
                  child: const Text(
                    ' Create one',
                    style: TextStyle(color: Color(0xFF003A45)),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            const Text('Or Continue with'),
            const Divider(
              thickness: 3,
              color: Color(0xFF003A45),
              endIndent: 100,
              indent: 100,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    child: Image.asset('assets/images/googleIcon.png'),
                  ),
                  Container(
                    height: 80,
                    width: 80,
                    child: Image.asset('assets/images/appleIcon.png'),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
