/*
 * Created on Tue Aug 25 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import './../../page_title.dart';
import 'package:flutter/material.dart';
import './../../utils/hex_color.dart';
import './../../quicksand_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../../get_new_token.dart';
import 'package:vibration/vibration.dart';
import './subject_button.dart';

class TeacherStudentSubjects extends StatefulWidget {
  final String userPublicId;

  TeacherStudentSubjects({this.userPublicId});
  @override
  _TeacherStudentSubjectsState createState() => _TeacherStudentSubjectsState();
}

class _TeacherStudentSubjectsState extends State<TeacherStudentSubjects> {
  List<Map> _subjects;
  int subjectsArrayIndex = 0;
  // _marks2 se refera la notele din semestrul 2
  int subjectsLength = 0;
  @override
  void initState() {
    _subjects = new List.filled(100, {}, growable: true);
    try {
      // sleep(const Duration(seconds: 2));
      super.initState();
      getSubjects();
    } catch (e) {
      print('Loading content');
    }
  }

  void getSubjects() async {
    getNewToken();
    final storage = new FlutterSecureStorage();
    String classPublicId = await storage.read(key: 'master_class_public_id');

    String url =
        'http://localhost:5000/api/v1/classes/subjects?class_public_id=' +
            classPublicId;
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
      int subjectsIndex = 0;

      setState(() {
        subjectsLength = jsonResponse['data']['subjects'].length;
      });
      for (int i = 0; i < jsonResponse['data']['subjects'].length; i++) {
        Map currentElementMap = new Map();
        var currentElement = jsonResponse['data']['subjects'][i];
        currentElementMap['subject_public_id'] =
            currentElement['subject_public_id'];
        currentElementMap['subject_name'] = currentElement['name'];

        _subjects[subjectsIndex] = currentElementMap;
        subjectsIndex++;
      }
      setState(() {
        subjectsArrayIndex = subjectsIndex;
      });
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
          // Navigator.of(context).pushNamed('/teacher_add_mark', arguments: {
          //   'studentPublicId': widget.userPublicId,
          //   'subjectPublicId': widget.subjectPublicId
          // });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        // notchMargin: 5,
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
            PageTitle(title: 'Materii'),
            SizedBox(height: 25),
            for (int i = 0; i < subjectsArrayIndex; i++)
              SubjectButton(
                subjectName: _subjects[i]['subject_name'],
                userPublicId: widget.userPublicId,
                subjectPublicId: _subjects[i]['subject_public_id'],
              ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
