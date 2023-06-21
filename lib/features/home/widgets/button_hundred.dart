import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HundredButton extends StatelessWidget {
  final String text;
  const HundredButton(this.text, {
  super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      width: 56,
      decoration: const BoxDecoration(
        color: Colors.redAccent,
        shape: BoxShape.circle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.call, size: 16, color: Colors.white),
          Text(
            text,
            style: GoogleFonts.rubik(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white
            ),
          ),
        ],
      ),
    );
  }
}