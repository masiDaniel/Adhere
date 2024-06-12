import 'package:flutter/material.dart';

class CustomTestField extends StatefulWidget {
  final String hintForTextField;
  final bool obscureInputedText;
  final IconData? suffixIcon;
  final TextEditingController myController;

  const CustomTestField({
    super.key,
    required this.hintForTextField,
    required this.obscureInputedText,
    required this.myController,
    this.suffixIcon,
    required Null Function(dynamic value) onChanged,
  });

  @override
  State<CustomTestField> createState() => _CustomTestFieldState();
}

class _CustomTestFieldState extends State<CustomTestField> {
  late bool _obscureinputtext;

  @override
  void initState() {
    super.initState();
    _obscureinputtext = widget.obscureInputedText;
  }

  void _toogleToObscureText() {
    setState(() {
      _obscureinputtext = !_obscureinputtext;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: TextField(
        controller: widget.myController,
        obscureText: _obscureinputtext,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.black),
            borderRadius: BorderRadius.circular(50.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromARGB(255, 2, 194, 241),
            ),
            borderRadius: BorderRadius.circular(40.0),
          ),
          fillColor: const Color.fromARGB(255, 254, 255, 255),
          filled: true,
          hintText: widget.hintForTextField,
          suffixIcon: widget.suffixIcon != Null
              ? IconButton(
                  onPressed: _toogleToObscureText,
                  icon: Icon(
                    widget.suffixIcon,
                    color: Colors.black,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
