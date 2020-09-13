/*
 * Created on Tue Sep 01 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import './../../utils/hex_color.dart';
import 'package:google_fonts/google_fonts.dart';
import './../../quicksand_text.dart';
import './../../main_button.dart';
import './../../auth/form_field.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
import './../../page_title.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../../get_new_token.dart';

class AddHourForm extends StatefulWidget {
  final int dayIndex;

  AddHourForm({this.dayIndex});

  @override
  AddHourFormState createState() {
    return AddHourFormState();
  }
}

class AddHourFormState extends State<AddHourForm> {
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  int _teachersArrayLength = 0;
  bool emptyField(String value) => value.length == 0 ? true : false;
  // Valori default pentru dropdown
  List<int> dropdownValues = [1, 1, 1, 1, 1, 1];

  // List<int> minutes = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35]

  List<String> grades = [
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
  ];

  List<String> letters = [
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  List<Map> _teachers;
  List<Map> _subjects;
  List<String> _teachersNames;
  List<String> _subjectsNames;
  int messagesArrayLength;

  @override
  void initState() {
    _teachers = new List.filled(120, {}, growable: true);
    _subjects = new List.filled(50, {}, growable: true);
    _teachersNames = new List.filled(120, '', growable: true);
    _subjectsNames = new List.filled(50, '', growable: true);
    try {
      // sleep(const Duration(seconds: 2));
      super.initState();
      getTeachers();
      getSubjects();
    } catch (e) {
      print('Loading content');
    }
  }

  void getSubjects() async {
    getNewToken();
    final storage = new FlutterSecureStorage();
    // print(widget.publicId);
    String url = 'http://localhost:5000/api/v1/subjects';
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
      for (int i = 0; i < jsonResponse['data']['subjects'].length; i++) {
        Map currentElementMap = new Map();
        var currentElement = jsonResponse['data']['subjects'][i];
        currentElementMap['public_id'] = currentElement['public_id'];
        currentElementMap['name'] = currentElement['name'];

        _subjectsNames[i] = currentElementMap['name'];

        _subjects[i] = currentElementMap;
      }
      setState(() {});
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
      setState(() {
        _teachersArrayLength = jsonResponse['data']['teachers'].length;
      });
      for (int i = 0; i < jsonResponse['data']['teachers'].length; i++) {
        Map currentElementMap = new Map();
        var currentElement = jsonResponse['data']['teachers'][i];
        currentElementMap['public_id'] = currentElement['user_public_id'];
        currentElementMap['name'] =
            currentElement['last_name'] + ' ' + currentElement['first_name'];
        _teachersNames[i] = currentElementMap['name'];
        _teachers[i] = currentElementMap;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PageTitle(
          title: 'Adaugă oră',
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: QuicksandText(
            text:
                'Pentru a adăuga o nouă oră în orar, vă rugăm să alegeți profesorul, ora din zi la care va preda, precum și materia predată.',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: '4D5061',
            height: 1.6,
            textAlign: TextAlign.center,
          ),
        ),
        Form(
          autovalidate: _autoValidate,
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: formUI(),
          ),
        ),
      ],
    );
  }

  Widget formUI() {
    var minutes = new List<String>.generate(60, (i) => '$i');
    var hours = new List<String>.generate(24, (i) => '$i');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        QuicksandText(
          text: 'Profesorul care predă',
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: '4D5061',
          height: 1.6,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        dropdown(items: _teachersNames, dropdownNumber: 2),
        SizedBox(height: 30),
        QuicksandText(
          text: 'Materia predată',
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: '4D5061',
          height: 1.6,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        dropdown(items: _subjectsNames, dropdownNumber: 5),
        SizedBox(height: 30),
        QuicksandText(
          text: 'Clasa la care se predă',
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: '4D5061',
          height: 1.6,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        Row(
          children: <Widget>[
            Expanded(
              child: dropdown(items: grades, dropdownNumber: 0),
            ),
            SizedBox(width: 20),
            Expanded(
              child: dropdown(items: letters, dropdownNumber: 1),
            ),
          ],
        ),
        SizedBox(height: 30),
        QuicksandText(
          text: 'Ora din zi și minutul din zi',
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: '4D5061',
          height: 1.6,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        Row(
          children: <Widget>[
            Expanded(
              child: dropdown(items: hours, dropdownNumber: 3),
            ),
            SizedBox(width: 20),
            Text(
              ':',
              style: TextStyle(fontSize: 25),
            ),
            SizedBox(width: 20),
            Expanded(
              child: dropdown(items: minutes, dropdownNumber: 4),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: MainButton(
            background: '7a6bee',
            splashColor: '604eee',
            text: 'Confirmă',
            click: () async {
              if (_formKey.currentState.validate()) {
                FocusScope.of(context).unfocus();
                Scaffold.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: HexColor('f85568'),
                    content: QuicksandText(
                      text: 'Se încarcă...',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: 'FFFFFF',
                    ),
                  ),
                );

                await new Future.delayed(const Duration(seconds: 2));
                String teacherPublicId =
                    _teachers[dropdownValues[2] - 1]['public_id'];
                String subjectPublicId =
                    _subjects[dropdownValues[5] - 1]['public_id'];
                String classGrade = grades[dropdownValues[0] - 1];
                String classLetter = letters[dropdownValues[1] - 1];
                String hour = hours[dropdownValues[3] - 1];
                String minute = minutes[dropdownValues[4] - 1];

                getNewToken();
                final storage = new FlutterSecureStorage();
                // print(widget.publicId);
                String url = 'http://localhost:5000/api/v1/timetable';
                String schoolPublicId =
                    await storage.read(key: 'school_public_id');
                String jwt = await storage.read(key: 'jwt');
                var body = {
                  'school_public_id': schoolPublicId,
                  'teacher_public_id': teacherPublicId,
                  'time': hour + ':' + minute,
                  'class_grade': classGrade,
                  'class_letter': classLetter,
                  'subject_public_id': subjectPublicId,
                  'day': widget.dayIndex,
                };
                var bodyEncoded = json.encode(body);
                Map<String, String> headers = {
                  'Content-type': 'application/json',
                  'Accept': 'application/json',
                  'Authorization': 'Bearer ' + jwt,
                };
                var response = await http.post(
                  url,
                  body: bodyEncoded,
                  headers: headers,
                );
                // print('Response status: ${response.statusCode}');
                // print('Response body: ${response.body}');
                var jsonResponse = jsonDecode(response.body);
                if (response.statusCode == 200) {
                  setState(() {
                    Navigator.pushReplacementNamed(context, '/operator_home');
                  });
                  setState(() {});
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget dropdown({items, dropdownNumber}) {
    // dropdownNumber 0 si 1 se refera la numarul, litera clasei.
    // dropdownNumber 2 se refera la profesor
    // 5 - subjects
    // ora - 3, minutul - 4

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: HexColor('7a6bee'), borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonFormField(
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.white,
          dropdownColor: HexColor('7a6bee'),
          value: dropdownValues[dropdownNumber],
          items: [
            for (int i = 0; i < items.length; i++)
              DropdownMenuItem(
                child: QuicksandText(
                  text: items[i],
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: 'FFFFFF',
                  textAlign: TextAlign.center,
                ),
                value: i + 1,
              ),
          ],
          onChanged: (value) {
            setState(
              () {
                dropdownValues[dropdownNumber] = value;
              },
            );
          }),
    );
  }
}
