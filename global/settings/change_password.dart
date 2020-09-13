/*
 * Created on Tue Sep 01 2020
 *
 * Copyright (c) 2020 Robert Feduș
*/

import 'package:flutter/material.dart';
import '../../utils/hex_color.dart';
import '../../quicksand_text.dart';
import 'change_password_form.dart';

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: HexColor('7a6bee'),
        centerTitle: true,
        title: QuicksandText(
          text: 'INKLESS',
          fontWeight: FontWeight.w700,
          fontSize: 40,
          color: 'FFFFFF',
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ChangePasswordForm(),
            ],
          ),
        ),
      ),
    );
  }
}