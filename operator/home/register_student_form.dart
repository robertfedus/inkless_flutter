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

class RegisterStudentForm extends StatefulWidget {
  String classPublicId;

  RegisterStudentForm({this.classPublicId});

  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterStudentForm> {
  final _formKey = GlobalKey<FormState>();
  String _lastName, _firstName, _studentPassword, _studentUsername;

  void registerStudent() async {
    getNewToken();
    final storage = new FlutterSecureStorage();
    // print(widget.publicId);
    String url = 'http://localhost:5000/api/v1/auth/register?role=elev';
    String schoolShortName = await storage.read(key: 'school_short_name');
    var body = {
      'last_name': _lastName,
      'first_name': _firstName,
      'school': schoolShortName,
      'class_public_id': widget.classPublicId,
    };
    var bodyEncoded = json.encode(body);
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    var response = await http.post(
      url,
      body: bodyEncoded,
      headers: headers,
    );
    // print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      setState(() {
        _studentPassword = jsonResponse['data']['password'];
        _showNewPassword = true;
        _studentUsername = jsonResponse['data']['username'];
      });
    }
  }

  bool _autoValidate = false;
  bool _showNewPassword = false;

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
            text: 'Cont nou de elev',
            fontWeight: FontWeight.w700,
            fontSize: 25,
            color: 'FFFFFF',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: QuicksandText(
            text:
                'Pentru a crea un cont nou de elev, vă rugăm sa completați câmpurile de mai jos. Elevul va intra automat în clasa selectată.',
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
                registerStudent();
              }
            },
          ),
        ),
        _showNewPassword
            ? Column(
                children: <Widget>[
                  QuicksandText(
                    text: 'Numele de utilizator al elevului:',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: 'f85568',
                    textAlign: TextAlign.center,
                  ),
                  QuicksandText(
                    text: _studentUsername,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: '4d5061',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  QuicksandText(
                    text: 'Parola elevului:',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: 'f85568',
                    textAlign: TextAlign.center,
                  ),
                  QuicksandText(
                    text: _studentPassword,
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
}
