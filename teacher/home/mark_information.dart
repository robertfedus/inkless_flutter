/*
 * Created on Thu Aug 27 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import './../../utils/hex_color.dart';
import './../../quicksand_text.dart';
import './../../page_title.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../../get_new_token.dart';

class MarkInformation extends StatefulWidget {
  final String value, message, date, markPublicId;
  final bool thesis;

  MarkInformation(
      {this.value, this.message, this.thesis, this.date, this.markPublicId});
  @override
  _MarkInformationState createState() => _MarkInformationState();
}

class _MarkInformationState extends State<MarkInformation> {
  bool _showNewPassword = false;
  bool _showClassChange = false;
  int _value = 1, _value2 = 1; // dropdown value

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: HexColor('7a6bee'),
        centerTitle: true,
        title: QuicksandText(
          text: 'INKLESS',
          fontWeight: FontWeight.w700,
          fontSize: 40,
          color: 'FFFFFF',
        ),
      ),
      body: ListView(
        children: <Widget>[
          PageTitle(title: 'Nota ${widget.value}'),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: QuicksandText(
              height: 1.6,
              text: 'Dată:',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: '7a6bee',
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: QuicksandText(
              height: 1.6,
              text: widget.date,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: '4d5061',
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: QuicksandText(
              height: 1.6,
              text: 'Mesaj:',
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: '7a6bee',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: QuicksandText(
              height: 1.6,
              text: widget.message,
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: '4d5061',
            ),
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(10),
                child: QuicksandText(
                  height: 1.6,
                  text: 'Teză:',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: '7a6bee',
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: QuicksandText(
                  height: 1.6,
                  text: widget.thesis ? 'da' : 'nu',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: '4d5061',
                ),
              ),
            ],
          ),
          SizedBox(height: 150),
          GestureDetector(
            onTap: () {
              showAlertDialog(context, 'Ștergeți nota');
            },
            child: QuicksandText(
              text: 'Ștergeți nota',
              fontWeight: FontWeight.w700,
              fontSize: 12,
              color: 'f85568',
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }

  void showAlertDialog(BuildContext context, String titleText) {
    Widget cancelButton = FlatButton(
      splashColor: HexColor('f53a50'),
      child: QuicksandText(
        text: 'Nu',
        fontWeight: FontWeight.w700,
        fontSize: 17,
        color: 'FFFFFF',
        height: 1.5,
        textAlign: TextAlign.center,
      ),
      onPressed: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );
    Widget continueButton = FlatButton(
      splashColor: HexColor('f53a50'),
      child: QuicksandText(
        text: 'Da',
        fontWeight: FontWeight.w700,
        fontSize: 17,
        color: 'FFFFFF',
        height: 1.5,
        textAlign: TextAlign.center,
      ),
      onPressed: () async {
        getNewToken();
        final storage = new FlutterSecureStorage();
        // print(widget.publicId);
        String url = 'http://localhost:5000/api/v1/mark?mark_public_id=' +
            widget.markPublicId;
        String jwt = await storage.read(key: 'jwt');
        Map<String, String> headers = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + jwt
        };
        var response = await http.delete(
          url,
          headers: headers,
        );
        // print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
        var jsonResponse = jsonDecode(response.body);
        if (response.statusCode == 200) {
          Navigator.pushReplacementNamed(context, '/teacher_home');
        }

        // Navigator.of(context, rootNavigator: true).pop('dialog');
      },
    );

    AlertDialog alert = AlertDialog(
      backgroundColor: HexColor('f85568'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      title: QuicksandText(
        text: titleText,
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: 'FFFFFF',
        height: 1.5,
      ),
      content: QuicksandText(
        text: 'Sigur doriți să faceți asta?',
        fontWeight: FontWeight.w500,
        fontSize: 17,
        color: 'FFFFFF',
        height: 1.5,
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
