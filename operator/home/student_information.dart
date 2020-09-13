/*
 * Created on Tue Aug 25 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import './../../utils/hex_color.dart';
import './../../quicksand_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../../get_new_token.dart';
import './send_message_form.dart';

class StudentInformation extends StatefulWidget {
  final String name, username, publicId;

  StudentInformation({this.name, this.username, this.publicId});
  @override
  _StudentInformationState createState() => _StudentInformationState();
}

class _StudentInformationState extends State<StudentInformation> {
  bool _showNewPassword = false;
  bool _showClassChange = false;
  bool _showSendMessage = false;
  String _newPassword;
  int _value = 1, _value2 = 1; // dropdown value

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
      body: SafeArea(
        child: ListView(
          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 70,
              color: HexColor('7a6bee'),
              child: QuicksandText(
                text: widget.name,
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: 'FFFFFF',
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              alignment: Alignment.center,
              width: double.infinity,
              child: Padding(
                padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: QuicksandText(
                  text:
                      'Ce doriți să faceți? Dumneavoastră aveți control asupra contului elevului.',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: '7a6bee',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  actionButton(
                      context: context,
                      text: 'Generați o parolă nouă',
                      option: 'password',
                      color: '7a6bee',
                      splashColor: '604eee',
                      displayDialog: true),
                  this._showNewPassword
                      ? Container(
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: <Widget>[
                              QuicksandText(
                                text: 'Noua parolă a elevului:',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: 'f85568',
                                textAlign: TextAlign.center,
                              ),
                              QuicksandText(
                                text: _newPassword,
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: '4d5061',
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ))
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 30,
                  ),
                  actionButton(
                    context: context,
                    text: 'Schimbați clasa',
                    option: 'changeClass',
                    color: '7a6bee',
                    splashColor: '604eee',
                    displayDialog: false,
                  ),
                  this._showClassChange
                      ? Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(15),
                              child: QuicksandText(
                                text:
                                    'Te rugăm să selectezi numarul și litera clasei dorite:',
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                                color: 'f85568',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(15),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  dropdown(grades, 1),
                                  dropdown(letters, 2),
                                ],
                              ),
                            ),
                            actionButton(
                              context: context,
                              text: 'Schimbați clasa',
                              option: 'changeClass',
                              color: 'f85568',
                              splashColor: 'f53a50',
                              displayDialog: true,
                            ),
                          ],
                        )
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 30,
                  ),
                  actionButton(
                      context: context,
                      text: 'Trimiteți un mesaj',
                      option: 'message',
                      color: '7a6bee',
                      splashColor: '604eee',
                      displayDialog: false),
                  this._showSendMessage
                      ? SendMessageForm(studentPublicId: widget.publicId)
                      : SizedBox.shrink(),
                  SizedBox(
                    height: 60,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                showAlertDialog(
                    context, 'Ștergeți contul elevului', 'deleteAccount');
              },
              child: QuicksandText(
                text: 'Ștergeți contul elevului',
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: 'f85568',
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget dropdown(items, dropdownNumber) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: HexColor('7a6bee'), borderRadius: BorderRadius.circular(10)),
      child: DropdownButton(
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

  Widget actionButton(
      {context, text, option, color, splashColor, displayDialog}) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: FlatButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(
              color: HexColor(color),
            ),
          ),
          color: HexColor(color),
          textColor: Colors.white,
          disabledColor: Colors.grey,
          disabledTextColor: Colors.black,
          padding: EdgeInsets.all(8.0),
          splashColor: HexColor(splashColor),
          onPressed: () {
            // Navigator.of(context).pushNamed('/operator_student_information',
            //     arguments: {'name': this.name});
            if (option == 'changeClass')
              setState(() {
                this._showClassChange = true;
              });
            if (option == 'message')
              setState(() {
                this._showSendMessage = true;
              });
            if (displayDialog) showAlertDialog(context, text, option);
          },
          child: QuicksandText(
            text: text,
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: 'FFFFFF',
            height: 1.5,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  void showAlertDialog(BuildContext context, String titleText, String option) {
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
        if (option == 'password') {
          getNewToken();
          final storage = new FlutterSecureStorage();
          // print(widget.publicId);
          String url =
              'http://localhost:5000/api/v1/auth/password/operator/user';
          var jwt = await storage.read(key: 'jwt');
          var body = {'user_username': widget.username};
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
          if (response.statusCode == 200) {
            setState(() {
              _newPassword = jsonResponse['data']['password'];
              _showNewPassword = true;
            });
          }

          setState(() {
            this._showNewPassword = true;
          });
        } else if (option == 'changeClass') {
          setState(() {
            this._showClassChange = true;
          });
          getNewToken();
          final storage = new FlutterSecureStorage();
          // print(widget.publicId);
          String url = 'http://localhost:5000/api/v1/student/class';
          var jwt = await storage.read(key: 'jwt');
          var schoolPublicId = await storage.read(key: 'school_public_id');

          var body = {
            'grade': grades[_value - 1],
            'letter': letters[_value2 - 1],
            'student_public_id': widget.publicId,
            'school_public_id': schoolPublicId,
          };
          var bodyEncoded = json.encode(body);
          Map<String, String> headers = {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + jwt
          };
          var response = await http.patch(
            url,
            body: bodyEncoded,
            headers: headers,
          );
          // print('Response status: ${response.statusCode}');
          // print('Response body: ${response.body}');
          var jsonResponse = jsonDecode(response.body);
          if (response.statusCode == 200) {
            Navigator.pushReplacementNamed(context, '/operator_home');
          }
        }
        Navigator.of(context, rootNavigator: true).pop('dialog');
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
