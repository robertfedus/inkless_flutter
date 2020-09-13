/*
 * Created on Fri Aug 21 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */
import 'dart:async';
import 'package:flutter/material.dart';
import './../utils/hex_color.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import './../quicksand_text.dart';
import './../main_button.dart';
import './form_field.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() {
    return LoginFormState();
  }
}

class LoginFormState extends State<LoginForm> {
  final storage = new FlutterSecureStorage();
  final _formKey = GlobalKey<FormState>();
  String _errorMessage;

  bool _autoValidate = false;
  String _username = '', _password = '';

  bool emptyField(String value) => value.length == 0 ? true : false;

  String validateUsername(String value) {
    if (emptyField(value)) {
      return 'Te rugăm să completezi câmpul de mai sus';
    }
    setState(() {
      this._username = value;
    });
    return null;
  }

  String validatePassword(String value) {
    if (emptyField(value)) {
      return 'Te rugăm să completezi câmpul de mai sus';
    } else {
      setState(() {
        this._password = value;
      });

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: QuicksandText(
            text:
                'Pentru a vă conecta la contul dvs. Inkless, vă rugăm sa completați câmpurile de mai jos',
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
          validate: validateUsername,
          keyboardType: TextInputType.name,
          obscureText: false,
          autocorrect: true,
          placeholder: 'Nume de utilizator',
        ),
        SizedBox(height: 15),
        AuthFormField(
          validate: validatePassword,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          autocorrect: false,
          placeholder: 'Parolă',
        ),
        SizedBox(height: 15),
        Container(
          alignment: Alignment.topLeft,
          child: QuicksandText(
            fontSize: 14,
            text: 'Ți-ai uitat parola?',
            color: 'f85568',
          ),
        ),
        SizedBox(height: 20),
        _errorMessage != null
            ? QuicksandText(
                fontSize: 15,
                text: _errorMessage,
                color: 'f85568',
              )
            : SizedBox.shrink(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: MainButton(
            background: '7a6bee',
            splashColor: '604eee',
            text: 'Confirmă',
            click: () async {
              if (_formKey.currentState.validate()) {
                // If the form is valid, display a Snackbar.
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
                var url = 'http://localhost:5000/api/v1/auth/login';
                var body = {
                  'username': this._username,
                  'password': this._password
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
                // print('Response body: ${response.body}');
                var jsonResponse = jsonDecode(response.body);
                if (response.statusCode == 200) {
                  // await storage.delete(key: 'jwt');
                  print(jsonResponse);
                  await storage.write(
                    key: 'jwt',
                    value: jsonResponse['data']['jwt'],
                  );
                  await storage.write(
                    key: 'public_id',
                    value: jsonResponse['data']['public_id'],
                  );
                  await storage.write(
                    key: 'role',
                    value: jsonResponse['data']['role'],
                  );
                  if (jsonResponse['data']['school_public_id'] != null)
                    await storage.write(
                      key: 'school_public_id',
                      value: jsonResponse['data']['school_public_id'],
                    );
                  await storage.write(
                    key: 'refresh_token',
                    value: jsonResponse['data']['refresh_token'],
                  );
                  String name = jsonResponse['data']['last_name'] +
                      ' ' +
                      jsonResponse['data']['first_name'];
                  await storage.write(
                    key: 'name',
                    value: name,
                  );
                  if (jsonResponse['data']['school_short_name'] != null)
                    await storage.write(
                      key: 'school_short_name',
                      value: jsonResponse['data']['school_short_name'],
                    );

                  if (jsonResponse['data']['teacher_master_class_public_id'] !=
                      null)
                    await storage.write(
                        key: 'master_class_public_id',
                        value: jsonResponse['data']
                            ['teacher_master_class_public_id']);

                  Phoenix.rebirth(context);
                } else {
                  setState(() {
                    _errorMessage = jsonResponse['message'];
                  });
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
