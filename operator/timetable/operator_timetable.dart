/*
 * Created on Tue Sep 01 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import '../../utils/hex_color.dart';
import 'package:diagonal/diagonal.dart';

import '../../quicksand_text.dart';
import '../drawer.dart';
import 'package:vibration/vibration.dart';
import '../../page_title.dart';
import './day_button.dart';

class OperatorTimetable extends StatefulWidget {
  @override
  _OperatorTimetableState createState() => _OperatorTimetableState();
}

class _OperatorTimetableState extends State<OperatorTimetable> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: OperatorDrawer(colored: 'orarulScolii')),
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu, size: 40), // change this size and style
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        elevation: 0.0,
        backgroundColor: HexColor('7a6bee'),
        centerTitle: true,
        title: Column(
          children: [
            QuicksandText(
              text: 'INKLESS',
              fontWeight: FontWeight.w700,
              fontSize: 40,
              color: 'FFFFFF',
            ),
          ],
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    List<String> days = ['Luni', 'Marți', 'Miercuri', 'Joi', 'Vineri'];

    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: ListView(
        children: <Widget>[
          PageTitle(title: 'Orarul școlii'),
          SizedBox(height: 30),
          for (int i = 0; i < days.length; i++)
            DayButton(day: days[i], dayIndex: i + 1),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
