/*
 * Created on Tue Aug 25 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import './../../utils/hex_color.dart';
import './../../quicksand_text.dart';
import './../../main_button.dart';
import 'student_button.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../../get_new_token.dart';

class ClassStudentsList extends StatefulWidget {
  final String classLetter, classGrade, publicId;

  ClassStudentsList({this.classLetter, this.classGrade, this.publicId});
  @override
  _ClassStudentsListState createState() => _ClassStudentsListState();
}

class _ClassStudentsListState extends State<ClassStudentsList> {
  List<Map> _students;
  int studentsLength = 0;
  @override
  void initState() {
    _students = new List.filled(100, {}, growable: true);
    try {
      // sleep(const Duration(seconds: 2));
      super.initState();
      getStudents();
    } catch (e) {
      print('Loading content');
    }
  }

  void getStudents() async {
    getNewToken();
    final storage = new FlutterSecureStorage();
    // print(widget.publicId);
    String url =
        'http://localhost:5000/api/v1/classes/students?class_public_id=' +
            widget.publicId;
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
      setState(() {
        studentsLength = jsonResponse['data']['students'].length;
      });
      for (int i = 0; i < jsonResponse['data']['students'].length; i++) {
        Map currentElementMap = new Map();
        var currentElement = jsonResponse['data']['students'][i];
        currentElementMap['name'] =
            currentElement['last_name'] + ' ' + currentElement['first_name'];
        // print(_students[i]['name']);
        currentElementMap['user_public_id'] = currentElement['user_public_id'];
        currentElementMap['username'] = currentElement['username'];

        _students[i] = currentElementMap;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor('f85568'),
        splashColor: HexColor('f53a50'),
        elevation: 0,
        child: Icon(Icons.add),
        onPressed: () async {
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 50);
          }
          Navigator.of(context).pushNamed('/operator_register_student',
              arguments: {'classPublicId': widget.publicId});
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
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 70,
              color: HexColor('7a6bee'),
              child: QuicksandText(
                text: widget.classGrade + ' ' + widget.classLetter,
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: 'FFFFFF',
              ),
            ),
            // Container(
            //   margin: const EdgeInsets.only(top: 15, bottom: 15),
            //   alignment: Alignment.center,
            //   width: double.infinity,
            //   child: QuicksandText(
            //     text: 'Prof. diriginte: Fedus Robert',
            //     fontWeight: FontWeight.w700,
            //     fontSize: 20,
            //     color: '7a6bee',
            //   ),
            // ),
            SizedBox(height: 25),
            for (int i = 0; i < studentsLength; i++)
              _students[i] != {}
                  ? StudentButton(
                      name: _students[i]['name'],
                      username: _students[i]['username'],
                      publicId: _students[i]['user_public_id'],
                    )
                  : SizedBox(height: 10),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
