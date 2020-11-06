import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Contador de Pessoas",
      home: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Pessoas 0",
              style: GoogleFonts.balooBhaina(
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
            Text(
              "Pode entrar",
              style: GoogleFonts.balooBhaina(
                fontStyle: FontStyle.italic,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
