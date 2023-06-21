import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/common/custom_button.dart';
import '../home/home_screen.dart';

class TemporaryScreen extends StatefulWidget {
  final String sessionId;
  const TemporaryScreen({super.key, required this.sessionId});

  @override
  State<TemporaryScreen> createState() => _TemporaryScreenState();
}

class _TemporaryScreenState extends State<TemporaryScreen> {
  bool isChecked = false;
  TextEditingController phoneController = TextEditingController();

  void showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    phoneController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              stops: [
                0.1,
                0.2,
                0.9
              ],
              colors: [
                Color(0xFFE7FFE9),
                Color(0xFFF4FFF5),
                Color(0xFFFFFFFF),
              ])),
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 39,),
                    Image.asset("assets/images/svg/hegati_logo_final.png"),
                    const SizedBox(height: 29),
                    SizedBox(
                      width: 304,
                      child: Text(
                        "Thank you for register Higati!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rubik(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(height: 5,),
                    SizedBox(
                      width: 304,
                      child: Text(
                        "We are here to keep your children safe\nHave a good and safe day!",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.rubik(
                            fontSize: 14, fontWeight: FontWeight.w400),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),

                    CustomButton(
                        text: "Home Page",
                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => HomeScreen(sessionId: widget.sessionId,))
                          );
                        }),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
