/*
 * Created on Tue Sep 01 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import '../../utils/hex_color.dart';
import '../../quicksand_text.dart';

class DayButton extends StatelessWidget {
  final String day;
  final int dayIndex;

  DayButton({this.day, this.dayIndex});

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
              color: HexColor('7a6bee'),
            ),
          ),
          color: HexColor('7a6bee'),
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(8.0),
          splashColor: HexColor('604eee'),
          onPressed: () {
            Navigator.of(context).pushNamed('/teacher_timetable_day',
                arguments: {'day': this.day, 'dayIndex': this.dayIndex});
          },
          child: QuicksandText(
            text: this.day,
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
