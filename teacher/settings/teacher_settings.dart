/*
 * Created on Tue Sep 01 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import '../../quicksand_text.dart';
import '../../utils/hex_color.dart';
import '../../main_button.dart';
import '../../page_title.dart';
import '../drawer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class TeacherSettings extends StatefulWidget {
  @override
  _TeacherSettingsState createState() => _TeacherSettingsState();
}

class _TeacherSettingsState extends State<TeacherSettings> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget _body = CircularProgressIndicator();
  String _apiVersion;

  List<Map> _teachers;
  int teachersArrayLength;

  @override
  void initState() {
    _teachers = new List.filled(120, {}, growable: true);
    try {
      // sleep(const Duration(seconds: 2));
      getMOTD();
      super.initState();
    } catch (e) {
      print('Loading content');
    }
  }

  void getMOTD() async {
    // print(widget.publicId);
    String url = 'http://localhost:5000/api/v1/motd';
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var response = await http.get(
      url,
      headers: headers,
    );
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _apiVersion = jsonResponse['data']['api_version'];
        _body = body();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: TeacherDrawer(colored: 'setari')),
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
      body: _body,
    );
  }

  Widget body() {
    return Column(
      children: <Widget>[
        PageTitle(
          title: 'Setări',
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
          child: MainButton(
            background: '7a6bee',
            splashColor: '604eee',
            text: 'Cont',
            textColor: 'FFFFFF',
            click: () {
              Navigator.of(context)
                  .pushNamed('/teacher_account_settings', arguments: '');
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: MainButton(
            background: '7a6bee',
            splashColor: '604eee',
            text: 'Ajutor și suport',
            textColor: 'FFFFFF',
            click: () {
              Navigator.of(context)
                  .pushNamed('/help_and_support', arguments: '');
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: MainButton(
            background: '7a6bee',
            splashColor: '604eee',
            text: 'Despre noi',
            textColor: 'FFFFFF',
            click: () {
              Navigator.of(context).pushNamed('/about_us', arguments: '');
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: MainButton(
            background: '7a6bee',
            splashColor: '604eee',
            text: 'Ieși din cont',
            textColor: 'FFFFFF',
            click: () async {
              final storage = new FlutterSecureStorage();
              await storage.deleteAll();
              Phoenix.rebirth(context);
            },
          ),
        ),
        SizedBox(height: 150),
        QuicksandText(
          text: '1.0.0-' + _apiVersion,
          fontWeight: FontWeight.w700,
          fontSize: 15,
          color: '4d5061',
        ),
      ],
    );
  }
}
