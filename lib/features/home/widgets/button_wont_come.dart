import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ButtonWontCome extends StatelessWidget {
  final int? index;
  const ButtonWontCome({
  super.key, required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        print(index);
      },
      child: Container(
        height: MediaQuery.of(context).size.height / 13,
        width: MediaQuery.of(context).size.width / 5,
        decoration: BoxDecoration(
            border: Border.all(
              color: Colors.orangeAccent,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(15))
        ),
        child: Center(
          child: Text(
            "Won't\n come\n today",
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