/*
 * Created on Mon Aug 24 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import './../quicksand_text.dart';
import './../utils/hex_color.dart';

class TeacherDrawer extends StatefulWidget {
  final String colored;

  TeacherDrawer({this.colored});

  @override
  _TeacherDrawerState createState() => _TeacherDrawerState();
}

class _TeacherDrawerState extends State<TeacherDrawer> {
  var colors = {
    'acasa': 'ffffff',
    'masterClass': 'ffffff',
    'tests': 'ffffff',
    'mesajeTrimise': 'ffffff',
    'orar': 'ffffff',
    'setari': 'ffffff',
  };

  void handleColorChange(mapKey) {
    setState(() {
      colors[mapKey] = 'f85568';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor('7a6bee'),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0.0, 40.0, 10.0, 25.0),
            child: Container(
              color: HexColor('7a6bee'),
              child: ListTile(
                title: Padding(
                  padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
                  child: QuicksandText(
                    text: 'Meniu',
                    fontWeight: FontWeight.w700,
                    fontSize: 45,
                    color: 'FFFFFF',
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text: 'Acasă',
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: widget.colored == 'acasa' ? 'f85568' : 'ffffff',
              ),
            ),
            onTap: () {
              this.handleColorChange(widget.colored);
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/teacher_home', arguments: '');
            },
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text: 'Clasa dvs.',
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: widget.colored == 'masterClass' ? 'f85568' : 'ffffff',
              ),
            ),
            onTap: () {
              this.handleColorChange(widget.colored);
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamed('/teacher_master_class', arguments: '');
            },
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text: 'Teste',
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: widget.colored == 'tests' ? 'f85568' : 'ffffff',
              ),
            ),
            onTap: () {
              this.handleColorChange(widget.colored);
              Navigator.pop(context);
              Navigator.of(context).pushNamed('/teacher_tests', arguments: '');
            },
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text: 'Mesaje trimise',
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: widget.colored == 'mesajeTrimise' ? 'f85568' : 'ffffff',
              ),
            ),
            onTap: () {
              this.handleColorChange(widget.colored);
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamed('/teacher_messages', arguments: '');
              // Then close the drawer
            },
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text: 'Orar',
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: widget.colored == 'orar' ? 'f85568' : 'ffffff',
              ),
            ),
            onTap: () {
              this.handleColorChange(widget.colored);
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamed('/teacher_timetable', arguments: '');
            },
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text: 'Setări',
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: widget.colored == 'setari' ? 'f85568' : 'ffffff',
              ),
            ),
            onTap: () {
              this.handleColorChange(widget.colored);
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamed('/teacher_settings', arguments: '');
            },
          )
        ],
      ),
    );
  }
}
