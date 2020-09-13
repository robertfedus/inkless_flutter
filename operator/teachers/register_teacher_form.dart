/*
 * Created on Fri Aug 21 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import './../../utils/hex_color.dart';
import './../../quicksand_text.dart';
import './../../main_button.dart';
import './../../auth/form_field.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../../get_new_token.dart';

class RegisterTeacherForm extends StatefulWidget {
  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterTeacherForm> {
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  bool _showNewPassword = false;
  bool _switchValue = false;
  String _lastName, _firstName, _teacherPassword, _teacherUsername;
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
  int _value = 1, _value2 = 1;

  void registerStudent() async {
    getNewToken();
    final storage = new FlutterSecureStorage();
    // print(widget.publicId);
    String url = 'http://localhost:5000/api/v1/auth/register?role=profesor';
    String schoolShortName = await storage.read(key: 'school_short_name');
    String jwt = await storage.read(key: 'jwt');
    var body = {
      'last_name': _lastName,
      'first_name': _firstName,
      'school': schoolShortName,
      'class_grade': grades[_value - 1],
      'class_letter': letters[_value2 - 1],
      'master': !_switchValue,
    };
    var bodyEncoded = json.encode(body);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + jwt
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
        _teacherPassword = jsonResponse['data']['password'];
        _showNewPassword = true;
        _teacherUsername = jsonResponse['data']['username'];
      });
    }
  }

  bool emptyField(String value) => value.length == 0 ? true : false;

  String validateLastName(String value) {
    if (emptyField(value)) {
      return 'Te rugăm să completezi câmpul de mai sus';
    }

    if (value.length < 3)
      return 'Numele trebuie să conțină minim 3 caractere';
    else {
      setState(() {
        _lastName = value;
      });

      return null;
    }
  }

  String validateFirstName(String value) {
    if (emptyField(value)) {
      return 'Te rugăm să completezi câmpul de mai sus';
    }

    if (value.length < 3)
      return 'Numele trebuie să conțină minim 3 caractere';
    else {
      setState(() {
        _firstName = value;
      });

      return null;
    }
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
        Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 70,
          color: HexColor('7a6bee'),
          child: QuicksandText(
            text: 'Cont nou de profesor',
            fontWeight: FontWeight.w700,
            fontSize: 25,
            color: 'FFFFFF',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: QuicksandText(
            text:
                'Pentru a crea un cont nou de profesor, vă rugăm să completați câmpurile de mai jos, precum și clasa la care profesorul va fi diriginte.',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            height: 1.6,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AuthFormField(
          validate: validateLastName,
          keyboardType: TextInputType.name,
          obscureText: false,
          autocorrect: true,
          placeholder: 'Nume',
        ),
        SizedBox(height: 15),
        AuthFormField(
          validate: validateFirstName,
          keyboardType: TextInputType.name,
          obscureText: false,
          autocorrect: true,
          placeholder: 'Prenume',
        ),
        SizedBox(height: 20),
        Row(
          children: <Widget>[
            Expanded(
              child: dropdown(grades, 1),
            ),
            SizedBox(width: 20),
            Expanded(
              child: dropdown(letters, 2),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Switch(
              value: _switchValue,
              onChanged: switchValueHandler,
              activeColor: Colors.green,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: QuicksandText(
                text: 'Profesorul nu e diriginte la nicio clasă',
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: '4D5061',
              ),
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

                // Aici vine request
                registerStudent();
                setState(() {
                  _showNewPassword = true;
                });
              }
            },
          ),
        ),
        _showNewPassword
            ? Column(
                children: <Widget>[
                  QuicksandText(
                    text: 'Numele de utilizator al profesorului:',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: 'f85568',
                    textAlign: TextAlign.center,
                  ),
                  QuicksandText(
                    text: _teacherUsername,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: '4d5061',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  QuicksandText(
                    text: 'Parola profesorului:',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: 'f85568',
                    textAlign: TextAlign.center,
                  ),
                  QuicksandText(
                    text: _teacherPassword,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: '4d5061',
                    textAlign: TextAlign.center,
                  ),
                ],
              )
            : SizedBox.shrink()
      ],
    );
  }

  Widget dropdown(items, dropdownNumber) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: HexColor('7a6bee'), borderRadius: BorderRadius.circular(10)),
      child: DropdownButtonFormField(
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.white,
          dropdownColor: HexColor('7a6bee'),
          value: dropdownNumber == 1 ? _value : _value2,
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
              if (dropdownNumber == 1)
                _value = value;
              else
                _value2 = value;
            });
          }),
    );
  }
}
