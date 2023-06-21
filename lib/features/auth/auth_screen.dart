import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:parents/core/common/custom_phone_text_field.dart';
import 'package:parents/features/auth/auth_code_screen.dart';
import 'package:parents/features/login/login_screen.dart';
import 'package:parents/logic/auth/bloc/auth_bloc.dart';

import '../../core/common/custom_button.dart';
import '../../core/common/custom_text_field.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isChecked = false;
  TextEditingController phoneController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? _validateName(String? value) {
    if (value == null) {
      return 'The phone number does not entered';
    } else {
      return null;
    }
  }

  String? _validatePhoneNumber(String? value) {
    if (value == null) {
      return 'Phone number is mandatory  and must contain 10 digits';
    }
    if (value.length != 10) {
      return 'Phone number is mandatory  and must contain 10 digits';
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
    nameController.dispose();

    super.dispose();
  }

  Box box = Hive.box('id');

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          if (state.response.data['res'] == 'OK' && isChecked) {
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
                          height: 20,
                        ),
                        Image.asset("assets/images/svg/pho4.png"),
                        const SizedBox(height: 2),
                        SizedBox(
                          width: 304,
                          child: Text(
                            "Welcome",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.rubik(
                                fontSize: 30, fontWeight: FontWeight.w500),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          width: 304,
                          child: Text(
                            "Full Name:",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.rubik(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                            width: 304,
                            child: CustomTextField(
                              controller: nameController,
                              validator: _validateName,
                            )),
                        const SizedBox(height: 21),
                        SizedBox(
                          width: 304,
                          child: Text(
                            "Phone Number:",
                            textAlign: TextAlign.right,
                            style: GoogleFonts.rubik(
                                fontSize: 14, fontWeight: FontWeight.w400),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SizedBox(
                            width: 304,
                            child: CustomPhoneTextField(
                              controller: phoneController,
                              validator: _validatePhoneNumber,
                            )),
                        const SizedBox(
                          height: 60,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "I agree to the \n",
                              style: GoogleFonts.rubik(
                                  fontSize: 14, fontWeight: FontWeight.w500),
                            ),
                            GestureDetector(
                                onTap: () {},
                                child: Text(
                                  "Terms of Use\n",
                                  style: GoogleFonts.rubik(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      decoration: TextDecoration.underline,
                                      color: Colors.blueAccent),
                                )),
                            Text(
                              " and \n",
                              style: GoogleFonts.rubik(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            GestureDetector(
                                onTap: () {},
                                child: Text("Privacy\nPolicy",
                                    style: GoogleFonts.rubik(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        decoration: TextDecoration.underline,
                                        color: Colors.blueAccent))),
                            Transform.scale(
                              scale: 1.3,
                              child: Checkbox(
                                activeColor: Colors.greenAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                checkColor: Colors.white,
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value!;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        CustomButton(
                            text: "Register",
                            onTap: () {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthBloc>().add(GetSessionId(
                                    phoneController.text, nameController.text));
                              }
                            }),
                        const SizedBox(
                          height: 21,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Have an Account? ",
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
                                              const LoginScreen()));
                                },
                                child: Text("Login",
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
