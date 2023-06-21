import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonArrived extends StatelessWidget {
  const ButtonArrived({
  super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: MediaQuery.of(context).size.height / 13,
        width: MediaQuery.of(context).size.width / 5,
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.greenAccent
            ),
            borderRadius: const BorderRadius.all(Radius.circular(15))
        ),
        child: Center(
          child: Text(
            "Arrived",
            style: GoogleFonts.rubik(
                fontSize: 15,
                fontWeight: FontWeight.w500
            ),
          ),
        ),
      ),
    );
  }
}