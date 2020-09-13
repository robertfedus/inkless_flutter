/*
 * Created on Tue Sep 01 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import './../../utils/hex_color.dart';
import './../../quicksand_text.dart';
import './add_test_form.dart';

class AddTest extends StatefulWidget {
  final String name;
  final int dayIndex;

  AddTest({this.name, this.dayIndex});
  @override
  _AddTestState createState() => _AddTestState();
}

class _AddTestState extends State<AddTest> {
  List<String> grades = [
    'V',
    'VI',
    'VII',
    'VIII',
    'IX',
    'X',
    'XI',
    'XII',
  ];

  List<String> letters = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

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
              AddTestForm(dayIndex: widget.dayIndex),
            ],
          ),
        ),
      ),
    );
  }
}
