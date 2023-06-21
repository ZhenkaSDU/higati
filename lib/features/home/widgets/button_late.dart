import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonLate extends StatelessWidget {
  const ButtonLate({
  super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: MediaQuery.of(context).size.height / 13,
        width: MediaQuery.of(context).size.width / 5,
        decoration: const BoxDecoration(
            color: Colors.yellowAccent,
            borderRadius: BorderRadius.all(Radius.circular(15))
        ),
        child: Center(
          child: Text(
            "Late",
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