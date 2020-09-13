/*
 * Created on Tue Sep 01 2020
 *
 * Copyright (c) 2020 Robert Feduș
*/

import 'package:flutter/material.dart';
import '../../utils/hex_color.dart';
import '../../quicksand_text.dart';
import '../../main_button.dart';
import '../../auth/form_field.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../../get_new_token.dart';

class ChangeEmailForm extends StatefulWidget {
  @override
  ChangeEmailFormState createState() {
    return ChangeEmailFormState();
  }
}

class ChangeEmailFormState extends State<ChangeEmailForm> {
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  String _email, _responseMessage;

  bool emptyField(String value) => value.length == 0 ? true : false;
  int _value = 1, _value2 = 1;

  String validateEmail(String value) {
    if (emptyField(value)) {
      return 'Te rugăm să completezi câmpul de mai sus';
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Te rugăm să introduci un e-mail corect';
    else {
      _email = value;
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
            text: 'Schimbați e-mail-ul',
            fontWeight: FontWeight.w700,
            fontSize: 25,
            color: 'FFFFFF',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: QuicksandText(
            text:
                'Pentru a vă schimba e-mail-ul contului dvs. Inkless, vă rugăm să introduceți e-mail-ul dorit în câmpul de mai jos. Veți primi un e-mail de confirmare la adresa nouă, în care veți găsi un cod pe care vă rugăm să îl introduceți în ecranul ce se va deschide.',
            fontWeight: FontWeight.w500,
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
          validate: validateEmail,
          keyboardType: TextInputType.emailAddress,
          obscureText: false,
          autocorrect: true,
          placeholder: 'E-mail',
        ),
        SizedBox(height: 20),
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
                // De aici in jos apare ceea ce se intampla cand apesi pe Confirma
                getNewToken();
                final storage = new FlutterSecureStorage();
                // print(widget.publicId);
                String url = 'http://localhost:5000/api/v1/email/email';
                String jwt = await storage.read(key: 'jwt');
                String userPublicId = await storage.read(key: 'public_id');
                var body = {
                  'email': _email,
                  'user_public_id': userPublicId,
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
                if (response.statusCode == 200) {}
                setState(() {
                  _responseMessage = jsonResponse['message'];
                });
                Navigator.of(context).pushNamed('/enter_email_code',
                    arguments: {'email': _email});
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
