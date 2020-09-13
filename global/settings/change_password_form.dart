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

class ChangePasswordForm extends StatefulWidget {
  @override
  ChangePasswordFormState createState() {
    return ChangePasswordFormState();
  }
}

class ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;

  bool emptyField(String value) => value.length == 0 ? true : false;
  int _value = 1, _value2 = 1;
  String _currentPassword, _newPassword, _responseMessage;

  String validatePassword(String value) {
    if (emptyField(value)) {
      return 'Te rugăm să completezi câmpul de mai sus';
    }
    _currentPassword = value;
    return null;
  }

  String validateNewPassword(String value) {
    if (emptyField(value)) {
      return 'Te rugăm să completezi câmpul de mai sus';
    }
    if (value.length < 6) return 'Parola trebuie să conțină minim 6 caractere';
    _newPassword = value;
    return null;
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
            text: 'Schimbați parola',
            fontWeight: FontWeight.w700,
            fontSize: 25,
            color: 'FFFFFF',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: QuicksandText(
            text:
                'Pentru a vă schimba parola contului dvs. Inkless, vă rugăm să introduceți parola actuală, precum si parola dorită în câmpurile de mai jos:',
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
          validate: validatePassword,
          keyboardType: TextInputType.name,
          obscureText: true,
          autocorrect: false,
          placeholder: 'Parola actuală',
        ),
        SizedBox(height: 15),
        AuthFormField(
          validate: validateNewPassword,
          keyboardType: TextInputType.name,
          obscureText: true,
          autocorrect: false,
          placeholder: 'Parola dorită',
        ),
        SizedBox(height: 20),
        _responseMessage != null
            ? Center(
                child: QuicksandText(
                  text: _responseMessage,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: 'f85568',
                ),
              )
            : SizedBox.shrink(),
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
                String url = 'http://localhost:5000/api/v1/auth/password/user';
                String jwt = await storage.read(key: 'jwt');
                var body = {
                  'old_password': _currentPassword,
                  'new_password': _newPassword,
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
                print('Response body: ${response.body}');
                var jsonResponse = jsonDecode(response.body);
                if (response.statusCode == 200) {}
                setState(() {
                  _responseMessage = jsonResponse['message'];
                });
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
