/*
 * Created on Tue Sep 01 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import './../../utils/hex_color.dart';
import './../../quicksand_text.dart';
import './../../main_button.dart';
import 'dart:async';
import './../../page_title.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../../get_new_token.dart';

class AddTestForm extends StatefulWidget {
  final int dayIndex;

  AddTestForm({this.dayIndex});

  @override
  AddTestFormState createState() {
    return AddTestFormState();
  }
}

class AddTestFormState extends State<AddTestForm> {
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  String _dateTime, _errorMessage;
  bool emptyField(String value) => value.length == 0 ? true : false;
  int dropdownValue = 1;

  List<Map> _classes;
  List<String> _classesNames;
  int messagesArrayLength;

  @override
  void initState() {
    _classes = new List.filled(120, {}, growable: true);
    _classesNames = new List.filled(50, '', growable: true);
    try {
      // sleep(const Duration(seconds: 2));
      super.initState();
      getClasses();
    } catch (e) {
      print('Loading content');
    }
  }

  void getClasses() async {
    getNewToken();
    final storage = new FlutterSecureStorage();
    // print(widget.publicId);
    String teacherPublicId = await storage.read(key: 'public_id');
    String url =
        'http://localhost:5000/api/v1/teacher/classes?teacher_public_id=' +
            teacherPublicId;
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
      for (int i = 0; i < jsonResponse['data']['classes'].length; i++) {
        Map currentElementMap = new Map();
        var currentElement = jsonResponse['data']['classes'][i];
        currentElementMap['public_id'] = currentElement['class_public_id'];
        currentElementMap['name'] =
            currentElement['grade'].toString() + currentElement['letter'];
        currentElementMap['subjectPublicId'] =
            currentElement['subject_public_id'];

        _classesNames[i] = currentElementMap['name'];

        _classes[i] = currentElementMap;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PageTitle(
          title: 'Adaugă test',
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: QuicksandText(
            text:
                'Pentru a anunța un test nou, vă rugăm să selectați clasa și data.',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        QuicksandText(
          text: 'Clasa',
          fontWeight: FontWeight.w400,
          fontSize: 18,
          color: '4D5061',
          height: 1.6,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        dropdown(items: _classesNames),
        SizedBox(height: 30),
        MainButton(
          background: '7a6bee',
          splashColor: '604eee',
          text: _dateTime != null ? _dateTime.toString() : 'Data',
          textColor: 'FFFFFF',
          click: () {
            showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2020),
              lastDate: DateTime(2021),
              builder: (BuildContext context, Widget child) {
                return Theme(
                  data: ThemeData.light().copyWith(
                    primaryColor: HexColor('7a6bee'),
                    accentColor: HexColor('f85568'),
                    colorScheme: ColorScheme.light(primary: HexColor('7a6bee')),
                    buttonTheme:
                        ButtonThemeData(textTheme: ButtonTextTheme.primary),
                  ),
                  child: child,
                );
              },
            ).then(
              (date) {
                if (date != null) {
                  var dateTime = DateTime.parse(date.toString());

                  setState(() {
                    _dateTime =
                        "${dateTime.year}-${dateTime.month}-${dateTime.day}";
                    _errorMessage = null;
                  });
                }
              },
            );
          },
        ),
        SizedBox(height: 30),
        _errorMessage != null
            ? Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: QuicksandText(
                  text: _errorMessage,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: 'f85568',
                  textAlign: TextAlign.center,
                ),
              )
            : SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: MainButton(
            background: '7a6bee',
            splashColor: '604eee',
            text: 'Confirmă',
            click: () async {
              if (_dateTime == null) {
                setState(() {
                  _errorMessage =
                      'Te rugăm să selectezi o dată calendaristică pentru nota introdusă';
                });

                return 0;
              }
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
                print(_dateTime);
                print(_classes[dropdownValue - 1]);

                getNewToken();
                final storage = new FlutterSecureStorage();
                // print(widget.publicId);
                String url = 'http://localhost:5000/api/v1/test';
                String teacherPublicId = await storage.read(key: 'public_id');
                String jwt = await storage.read(key: 'jwt');
                var body = {
                  'date': _dateTime,
                  'teacher_user_public_id': teacherPublicId,
                  'class_public_id': _classes[dropdownValue - 1]['public_id'],
                  'subject_public_id': _classes[dropdownValue - 1]
                      ['subjectPublicId'],
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
                    Navigator.pushReplacementNamed(context, '/teacher_home');
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

  Widget dropdown({items}) {
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
          value: dropdownValue,
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
                dropdownValue = value;
              },
            );
          }),
    );
  }
}
