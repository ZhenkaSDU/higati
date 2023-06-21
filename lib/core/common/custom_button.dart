import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  final Color? shadowColor;
  CustomButton({Key? key, required this.text, required this.onTap,this.color, this.shadowColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: const LinearGradient(
            begin: FractionalOffset.centerLeft,
            end: FractionalOffset.centerRight,
            stops: [0.1, 0.8],
            colors: [
              Color(0xff37F9A7),
              Color(0xffA9F9B1),
            ]),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),

          gradient: const LinearGradient(
              begin: FractionalOffset.centerLeft,
              end: FractionalOffset.centerRight,
              stops: [0.1, 0.9],
              colors: [
                Color(0xffA9F9B1),
                Color(0xff37F9A7),
              ]),
        ),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color == null ? Colors.transparent : color,
            // backgroundColor: Colors.transparent,
            shadowColor: color == null ? Colors.transparent : shadowColor,
            minimumSize: const Size(double.infinity,56),
          ),
          child: Text(text,style: GoogleFonts.rubik(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black
          ),),
        ),
      ),
    );
  }
}
