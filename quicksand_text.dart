/*
 * Created on Fri Aug 21 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'utils/hex_color.dart';

class QuicksandText extends StatelessWidget {
  final String text;
  final double fontSize;
  final String color;
  final double height;
  var fontWeight;
  var textAlign;

  QuicksandText(
      {this.text,
      this.fontSize,
      this.color,
      this.height,
      this.fontWeight,
      this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.quicksand(
        fontWeight: this.fontWeight,
        fontSize: this.fontSize,
        color: HexColor(this.color),
        height: this.height,
      ),
      textAlign: this.textAlign,
    );
  }
}
