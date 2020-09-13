/*
 * Created on Thu Aug 27 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import './../../utils/hex_color.dart';
import './../../quicksand_text.dart';
import './../../main_button.dart';
import './add_class_form.dart';

class AddClass extends StatefulWidget {
  final String name;

  AddClass({this.name});
  @override
  _AddClassState createState() => _AddClassState();
}

class _AddClassState extends State<AddClass> {
  bool _showNewPassword = false;
  bool _showClassChange = false;
  int _value = 1, _value2 = 1; // dropdown value

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
      body: ListView(
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 70,
            color: HexColor('7a6bee'),
            child: QuicksandText(
              text: 'Adăugați o clasă nouă',
              fontWeight: FontWeight.w700,
              fontSize: 25,
              color: 'FFFFFF',
            ),
          ),
          AddClassForm(),
        ],
      ),
    );
  }
}
