import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:parents/core/common/custom_phone_text_field.dart';
import 'package:parents/features/auth/auth_code_screen.dart';
import 'package:parents/features/auth/auth_screen.dart';
import 'package:parents/logic/login/bloc/login_bloc.dart';

import '../../core/common/custom_button.dart';
import '../../core/common/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _validatePhoneNumber(String? value) {
    if (value == null) {
      return 'The phone number does not entered';
    }
    if (value.length != 10) {
      return 'The phone number does not entered';
    } else {
      return null;
    }
  }

  void showSnackbar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    phoneController.dispose();

    super.dispose();
  }

  Box box = Hive.box('id');

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          if (state.response.data['res'] == 'OK') {
            print(state.response.data['session_id'] + " MY SESSION ID");
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AuthCodeScreen(
                          sessionId: state.response.data['session_id'],
                          phoneNumber: phoneController.text,
                        )));
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
        child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 21,
                        ),
                        Image.asset("assets/images/svg/pho4.png"),
                        const SizedBox(height: 2.67),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Login",
                              style: GoogleFonts.rubik(
                                  fontSize: 30, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Phone Number:",
                              style: GoogleFonts.rubik(
                                  fontSize: 14, fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        CustomPhoneTextField(
                          controller: phoneController,
                          validator: _validatePhoneNumber,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        CustomButton(
                            text: "Next",
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<LoginBloc>().add(GetSessionId(
                                      phoneController.text,
                                    ));
                              }
                            }),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account? ",
                                style: GoogleFonts.rubik(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                )),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const AuthScreen()));
                                },
                                child: Text("Register Now",
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
                ),
              )),
        ),
      ),
    );
  }
}
