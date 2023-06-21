import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/global_variables.dart';

// ignore: must_be_immutable
class CustomTextField extends StatefulWidget {
  TextEditingController controller;
  String? Function(String?)? validator;
  CustomTextField({Key? key, required this.controller,this.validator}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: false,
      inputFormatters: <TextInputFormatter>[
        LengthLimitingTextInputFormatter(25),
      ],
      controller: widget.controller,
      validator: widget.validator,
      decoration: const InputDecoration(
        alignLabelWithHint: false,
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: GlobalVariables.greyFocusTextField, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: GlobalVariables.greyFocusTextField, width: 1.0),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        filled: true,
        fillColor: GlobalVariables.whiteColor,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: GlobalVariables.whiteColor, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
