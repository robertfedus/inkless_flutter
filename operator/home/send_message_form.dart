/*
 * Created on Thu Aug 27 2020
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

class SendMessageForm extends StatefulWidget {
  String studentPublicId;

  SendMessageForm({this.studentPublicId});

  @override
  SendMessageFormState createState() {
    return SendMessageFormState();
  }
}

class SendMessageFormState extends State<SendMessageForm> {
  final _formKey = GlobalKey<FormState>();

  String _message;
  bool _autoValidate = false;
  bool _showNewPassword = false;

  bool emptyField(String value) => value.length == 0 ? true : false;

  String validateName(String value) {
    if (emptyField(value)) {
      return 'Te rugăm să completezi câmpul de mai sus';
    }

    if (value.length < 3)
      return 'Mesajul trebuie să conțină minim 3 caractere';
    else {
      setState(() {
        _message = value;
      });

      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Form(
          autovalidate: _autoValidate,
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 25.0),
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
          validate: validateName,
          keyboardType: TextInputType.name,
          obscureText: false,
          autocorrect: true,
          placeholder: 'Mesaj',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: MainButton(
            background: 'f85568',
            splashColor: 'f53a50',
            text: 'Trimiteți',
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
                final storage = new FlutterSecureStorage();
                // print(widget.publicId);
                String url = 'http://localhost:5000/api/v1/message';
                String senderPublicId = await storage.read(key: 'public_id');
                String jwt = await storage.read(key: 'jwt');
                var body = {
                  'message': _message,
                  'sender_public_id': senderPublicId,
                  'receiver_public_id': widget.studentPublicId,
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
                }
              }
            },
          ),
        ),
      ],
    );
  }
}
