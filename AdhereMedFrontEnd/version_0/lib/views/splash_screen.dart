import 'package:flutter/material.dart';

class splashScreen extends StatelessWidget {
  const splashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //navigate to homepage after 5 secs
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/landingpage');
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: ClipOval(
          child: Container(
            width: 200,
            height: 200,
            child: Image.asset(
              'assets/images/splash.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
