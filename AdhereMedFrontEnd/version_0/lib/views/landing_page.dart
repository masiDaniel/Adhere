import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:version_0/components/sutom_button.dart';

class landingPage extends StatelessWidget {
  const landingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  ),
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/designPoster_2.png',
                      ),
                      fit: BoxFit.fill)),
            ),
            const SizedBox(
              height: 60,
            ),
            Text(
              'A trusted',
              style: GoogleFonts.dmSerifDisplay(
                  fontSize: 50, color: const Color.fromARGB(255, 6, 148, 177)),
            ),
            Text(
              'Medical Service Platform.',
              style: GoogleFonts.prompt(
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'We\'ll Focus on the small things, so that you don\'t !\n'
                'From timely updates and reminders, '
                'to adequate health services',
                style: GoogleFonts.outfit(
                    // fontSize: 22,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomButton(
                  buttonText: 'Sign Up',
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signuppage');
                  },
                  width: 100,
                  height: 50,
                  color: const Color(0xFF003A45),
                ),
                CustomButton(
                  buttonText: 'Log In',
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/loginpage');
                  },
                  width: 100,
                  height: 50,
                  color: const Color(0xFF003A45),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Are you a doctor intrested in joining AdhereMed?',
              style: TextStyle(
                  fontSize: 16, color: Color.fromARGB(255, 7, 52, 88)),
            ),
            CustomButton(
              buttonText: 'Continue',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/doctorSignUp');
              },
              width: 130,
              height: 50,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ],
        ),
      ),
    );
  }
}
