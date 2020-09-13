/*
 * Created on Tue Aug 25 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import '../../utils/hex_color.dart';
import '../../quicksand_text.dart';

class AbsenceButton extends StatelessWidget {
  final String message, absencePublicId, color, splashColor, date;
  final bool motivated, master;

  AbsenceButton({
    this.message,
    this.absencePublicId,
    this.color,
    this.splashColor,
    this.motivated,
    this.date,
    this.master,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(
              color: HexColor(this.color),
            ),
          ),
          color: HexColor(this.color),
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(8.0),
          splashColor: HexColor(this.splashColor),
          onPressed: () {
            Navigator.of(context).pushNamed(
              '/teacher_absence_information',
              arguments: {
                'message': this.message,
                'motivated': this.motivated,
                'date': this.date,
                'absencePublicId': this.absencePublicId,
                'master': this.master,
              },
            );
          },
          child: QuicksandText(
            text: this.date,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: 'FFFFFF',
            height: 1.5,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
