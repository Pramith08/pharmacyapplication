import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:google_fonts/google_fonts.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final double width;
  final TextInputType keyboardType;
  final Function(String) onChange;
  final Function()? onTap;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.width,
    required this.onChange,
    required this.keyboardType,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: width,
      decoration: const BoxDecoration(
        color: Color(0xffFFFFFF),
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: TextField(
        onTap: onTap,
        onChanged: onChange,
        keyboardType: keyboardType,
        focusNode: null,
        cursorColor: const Color(0xFF042A3B),
        style: GoogleFonts.lato(
          color: Color(0xff272343),
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        controller: controller,
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(8),
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Color(0xFF3E3F43),
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 2,
              color: Colors.red,
            ),
            borderRadius: BorderRadius.all(
              Radius.circular(5),
            ),
          ),
          hintText: hintText,
          hintStyle: GoogleFonts.lato(
            color: Color(0xFF666B70),
            fontSize: 15,
          ),
          labelStyle: GoogleFonts.lato(
            color: Color(0xFF666B70),
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}
