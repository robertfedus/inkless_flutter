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

class AbsenceInformation extends StatefulWidget {
  final String message, date, absencePublicId;
  final bool motivated, master;

  AbsenceInformation(
      {this.message,
      this.motivated,
      this.date,
      this.absencePublicId,
      this.master});
  @override
  _AbsenceInformationState createState() => _AbsenceInformationState();
}

class _AbsenceInformationState extends State<AbsenceInformation> {
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
          PageTitle(title: 'Absență'),
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
                  text: 'Motivată:',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: '7a6bee',
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                child: QuicksandText(
                  height: 1.6,
                  text: widget.motivated ? 'da' : 'nu',
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                  color: '4d5061',
                ),
              ),
            ],
          ),
          SizedBox(height: 150),
          widget.master == true
              ? GestureDetector(
                  onTap: () {
                    showAlertDialog(context, 'Motivați absența');
                  },
                  child: QuicksandText(
                    text: 'Motivați absența',
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: 'f85568',
                    textAlign: TextAlign.center,
                  ),
                )
              : SizedBox.shrink(),
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
        String url = 'http://localhost:5000/api/v1/absence?absence_public_id=' +
            widget.absencePublicId +
            '&field=motivated';
        String jwt = await storage.read(key: 'jwt');
        Map<String, String> headers = {
          'Content-type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer ' + jwt
        };
        var body = {'value': true};
        var bodyEncoded = json.encode(body);

        var response =
            await http.patch(url, headers: headers, body: bodyEncoded);
        // print('Response status: ${response.statusCode}');
        // print('Response body: ${response.body}');
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
