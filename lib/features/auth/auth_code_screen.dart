import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parents/features/auth/temporary_screen.dart';
import 'package:parents/features/home/home_screen.dart';
import 'package:parents/logic/sms/bloc/sms_bloc.dart';
import '../../core/common/custom_button.dart';
import '../../core/common/custom_text_field.dart';

class AuthCodeScreen extends StatefulWidget {
  final String sessionId;
  final String? phoneNumber;
  const AuthCodeScreen({super.key, required this.sessionId, this.phoneNumber});

  @override
  State<AuthCodeScreen> createState() => _AuthCodeScreenState();
}

class _AuthCodeScreenState extends State<AuthCodeScreen> {
  bool isChecked = false;
  TextEditingController smsController = TextEditingController();

  void showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    smsController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SmsBloc, SmsState>(
      listener: (context, state) {
        if (state is SmsSuccess) {
          if (state.response.data['res'] == 'OK') {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => TemporaryScreen(
                          sessionId: widget.sessionId,
                        )));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content:
                    Text("The code entered is incorrect, please try again")));
          }
        }
      },
      child: Container(
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
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [Icon(Icons.navigate_next)],
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Phone number\nVerification",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.rubik(
                              fontSize: 30, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    Row(
                      children: [
                        Text(
                          "Verification code has been sent to the number \n${widget.phoneNumber}",
                          textAlign: TextAlign.left,
                          style: GoogleFonts.rubik(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Enter verification code:",
                          textAlign: TextAlign.right,
                          style: GoogleFonts.rubik(
                              fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    CustomTextField(
                      controller: smsController,
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomButton(
                        text: "Next",
                        onTap: () {
                          context.read<SmsBloc>().add(
                              GetRes(widget.sessionId, smsController.text));
                        }),
                    const SizedBox(
                      height: 21,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Didn't receive a code? ",
                            style: GoogleFonts.rubik(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            )),
                        GestureDetector(
                            onTap: () {},
                            child: Text("Send again",
                                style: GoogleFonts.rubik(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    decoration: TextDecoration.underline,
                                    color: Colors.blueAccent))),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
