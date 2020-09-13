/*
 * Created on Thu Aug 27 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import './../../utils/hex_color.dart';
import './../../quicksand_text.dart';
import './../../page_title.dart';
import './add_absence_form.dart';

class AddAbsence extends StatefulWidget {
  final String name, studentPublicId, subjectPublicId;
  AddAbsence({this.name, this.studentPublicId, this.subjectPublicId});
  @override
  _AddAbsenceState createState() => _AddAbsenceState();
}

class _AddAbsenceState extends State<AddAbsence> {
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
          PageTitle(title: 'Adăugați o absență nouă'),
          AddAbsenceForm(
              studentPublicId: widget.studentPublicId,
              subjectPublicId: widget.subjectPublicId),
        ],
      ),
    );
  }
}
