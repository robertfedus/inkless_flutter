/*
 * Created on Thu Aug 27 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import './../../utils/hex_color.dart';
import './../../quicksand_text.dart';
import './../../main_button.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../../get_new_token.dart';
import './../../main_button.dart';
import './../../auth/form_field.dart';

class AddMarkForm extends StatefulWidget {
  final String studentPublicId, subjectPublicId;

  AddMarkForm({this.studentPublicId, this.subjectPublicId});

  @override
  AddMarkFormState createState() {
    return AddMarkFormState();
  }
}

class AddMarkFormState extends State<AddMarkForm> {
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false, _switchValue = false;
  int _dropdownValue = 1;
  var _dateTime;
  String _message, _errorMessage;

  List<String> marks = ['10', '9', '8', '7', '6', '5', '4', '3', '2', '1'];
  bool emptyField(String value) => value.length == 0 ? true : false;

  String validateMessage(String value) {
    setState(() {
      _message = value;
    });

    return null;
  }

  void switchValueHandler(value) {
    setState(() {
      _switchValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: QuicksandText(
            text:
                'Pentru a adăuga o notă nouă, vă rugăm să selectați nota și data, și să scrieți un mesaj descriptiv notei (mesajul este opțional)',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: '4D5061',
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
    var storage = new FlutterSecureStorage();

    return Column(
      children: <Widget>[
        dropdown(marks),
        SizedBox(height: 30),
        MainButton(
          background: '7a6bee',
          splashColor: '604eee',
          text: _dateTime != null ? _dateTime.toString() : 'Dată',
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
        AuthFormField(
          validate: validateMessage,
          keyboardType: TextInputType.multiline,
          obscureText: false,
          autocorrect: true,
          placeholder: 'Mesaj',
        ),
        SizedBox(height: 30),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Switch(
              value: _switchValue,
              onChanged: switchValueHandler,
              activeColor: Colors.green,
            ),
            QuicksandText(
              text: 'Nota e teză',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: 'f85568',
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
        SizedBox(height: 100),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: MainButton(
            background: 'f85568',
            splashColor: 'f53a50',
            text: 'Confirmă',
            click: () async {
              if (_formKey.currentState.validate()) {
                FocusScope.of(context).unfocus();
                if (_dateTime == null) {
                  setState(() {
                    _errorMessage =
                        'Te rugăm să selectezi o dată calendaristică pentru nota introdusă';
                  });

                  return 0;
                }
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
                final storage = new FlutterSecureStorage();
                String teacherPublicId = await storage.read(key: 'public_id');
                Map<String, dynamic> body = {
                  'teacher_public_id': teacherPublicId,
                  'student_public_id': widget.studentPublicId,
                  'subject_public_id': widget.subjectPublicId,
                  'message': _message,
                  'value': marks[_dropdownValue - 1],
                  'date': _dateTime,
                };
                String thesis = _switchValue.toString();

                getNewToken();
                String jwt = await storage.read(key: 'jwt');
                var url = 'http://localhost:5000/api/v1/mark?thesis=' + thesis;

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
                  Navigator.of(context).pop();
                } else {
                  print('ERROR');
                }
              }
            },
          ),
        ),
      ],
    );
  }

  Widget dropdown(items) {
    return Container(
      alignment: Alignment.center,
      height: 47,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: HexColor('7a6bee'), borderRadius: BorderRadius.circular(25)),
      child: DropdownButtonFormField(
          decoration: InputDecoration.collapsed(hintText: ''),
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.white,
          dropdownColor: HexColor('7a6bee'),
          value: _dropdownValue,
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
            setState(() {
              _dropdownValue = value;
            });
          }),
    );
  }
}
