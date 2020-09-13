/*
 * Created on Thu Aug 27 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import '../../utils/hex_color.dart';
import '../../quicksand_text.dart';
import '../drawer.dart';
import 'package:vibration/vibration.dart';
import '../../page_title.dart';
import './teacher_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../../get_new_token.dart';

class OperatorTeachers extends StatefulWidget {
  @override
  _OperatorTeachersState createState() => _OperatorTeachersState();
}

class _OperatorTeachersState extends State<OperatorTeachers> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  Widget _body = CircularProgressIndicator();

  List<Map> _teachers;
  int teachersArrayLength;

  @override
  void initState() {
    _teachers = new List.filled(120, {}, growable: true);
    try {
      // sleep(const Duration(seconds: 2));
      getTeachers();
      super.initState();
    } catch (e) {
      print('Loading content');
    }
  }

  void getTeachers() async {
    getNewToken();
    final storage = new FlutterSecureStorage();
    // print(widget.publicId);
    String schoolPublicId = await storage.read(key: 'school_public_id');
    String url = 'http://localhost:5000/api/v1/teacher?school_public_id=' +
        schoolPublicId;
    String jwt = await storage.read(key: 'jwt');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + jwt
    };
    var response = await http.get(
      url,
      headers: headers,
    );
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (int i = 0; i < jsonResponse['data']['teachers'].length; i++) {
        Map currentElementMap = new Map();
        var currentElement = jsonResponse['data']['teachers'][i];
        currentElementMap['public_id'] = currentElement['user_public_id'];
        currentElementMap['first_name'] = currentElement['first_name'];
        currentElementMap['last_name'] = currentElement['last_name'];
        currentElementMap['username'] = currentElement['username'];

        _teachers[i] = currentElementMap;
      }
      setState(() {
        _body = body();
        teachersArrayLength = jsonResponse['data']['teachers'].length;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: OperatorDrawer(colored: 'profesori')),
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor('f85568'),
        splashColor: HexColor('f53a50'),
        elevation: 0,
        child: Icon(Icons.add),
        onPressed: () async {
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 50);
          }
          Navigator.of(context)
              .pushNamed('/operator_register_teacher', arguments: '');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        shape: CircularNotchedRectangle(),
        color: HexColor('7a6bee'),
        child: Container(
          height: 30.0,
        ),
      ),
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
    return Padding(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
      child: ListView(
        children: <Widget>[
          PageTitle(title: 'Profesori'),
          SizedBox(height: 30),
          for (int i = 0; i < _teachers.length; i++)
            _teachers[i]['last_name'] != null
                ? TeacherButton(
                    name: _teachers[i]['last_name'] +
                        ' ' +
                        _teachers[i]['first_name'],
                    username: _teachers[i]['username'])
                : SizedBox(
                    height: 10,
                  ),
          SizedBox(height: 30),
        ],
      ),
    );
  }
}
