/*
 * Created on Mon Aug 24 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import './../quicksand_text.dart';
import './../utils/hex_color.dart';

class OperatorDrawer extends StatefulWidget {
  final String colored;

  OperatorDrawer({this.colored});

  @override
  _OperatorDrawerState createState() => _OperatorDrawerState();
}

class _OperatorDrawerState extends State<OperatorDrawer> {
  var colors = {
    'acasa': 'ffffff',
    'mesajeTrimise': 'ffffff',
    'orarulScolii': 'ffffff',
    'profesori': 'ffffff',
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
              Navigator.of(context).pushNamed('/operator_home', arguments: '');
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
                  .pushNamed('/operator_messages', arguments: '');
              // Then close the drawer
            },
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text: 'Orarul școlii',
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: widget.colored == 'orarulScolii' ? 'f85568' : 'ffffff',
              ),
            ),
            onTap: () {
              this.handleColorChange(widget.colored);
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamed('/operator_timetable', arguments: '');
            },
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text: 'Profesori',
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: widget.colored == 'profesori' ? 'f85568' : 'ffffff',
              ),
            ),
            onTap: () {
              // Then close the drawer
              this.handleColorChange(widget.colored);
              Navigator.pop(context);
              Navigator.of(context)
                  .pushNamed('/operator_teachers', arguments: '');
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
                  .pushNamed('/operator_settings', arguments: '');
            },
          )
        ],
      ),
    );
  }
}
