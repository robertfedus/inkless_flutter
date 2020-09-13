/*
 * Created on Fri Aug 21 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import './../utils/hex_color.dart';

class AuthFormField extends StatelessWidget {
  final Function validate;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool autocorrect;
  final String placeholder;

  AuthFormField({
    this.validate,
    this.keyboardType,
    this.obscureText,
    this.autocorrect,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: this.obscureText,
      autocorrect: this.autocorrect ? true : false,
      cursorColor: HexColor('7a6bee'),
      keyboardType: this.keyboardType,
      decoration: InputDecoration(
        hintText: this.placeholder,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: HexColor('7a6bee')),
        ),
      ),
      validator: this.validate,
    );
  }
}
