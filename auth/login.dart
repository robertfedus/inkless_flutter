/*
 * Created on Fri Aug 21 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import './../quicksand_text.dart';
import './../utils/hex_color.dart';
import './login_form.dart';

class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: HexColor('7a6bee'),
        elevation: 0,
        title: QuicksandText(
          text: 'Autentificare',
          fontWeight: FontWeight.w700,
          fontSize: 30,
          color: 'FFFFFF',
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}
