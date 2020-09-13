/*
 * Created on Fri Aug 21 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import './utils/hex_color.dart';
import './quicksand_text.dart';

class MainButton extends StatelessWidget {
  final String background;
  final String splashColor;
  final String text;
  final String textColor;
  final Function click;

  MainButton({
    this.background,
    this.splashColor,
    this.text,
    this.click,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FlatButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
          side: BorderSide(
            color: HexColor(this.background),
          ),
        ),
        color: HexColor(this.background),
        textColor: Colors.white,
        disabledColor: Colors.grey,
        disabledTextColor: Colors.black,
        padding: EdgeInsets.all(8.0),
        splashColor: HexColor(this.splashColor),
        onPressed: this.click,
        child: QuicksandText(
          text: this.text,
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: this.textColor is String ? this.textColor : 'FFFFFF',
          height: 1.5,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
