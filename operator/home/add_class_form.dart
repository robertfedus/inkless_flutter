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

class AddClassForm extends StatefulWidget {
  @override
  AddClassFormState createState() {
    return AddClassFormState();
  }
}

class AddClassFormState extends State<AddClassForm> {
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  int _value = 1, _value2 = 1;

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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: QuicksandText(
            text:
                'Pentru a adăuga o clasă nouă, vă rugăm să selectați numărul și litera clasei:',
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
                getNewToken();
                String school_public_id =
                    await storage.read(key: 'school_public_id');
                String jwt = await storage.read(key: 'jwt');
                var url =
                    'http://localhost:5000/api/v1/classes?school_public_id=' +
                        school_public_id;
                var body = {
                  'grade': grades[_value - 1],
                  'letter': letters[_value2 - 1]
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
                  Navigator.pushReplacementNamed(context, '/operator_home');
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
