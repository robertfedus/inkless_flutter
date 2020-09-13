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

// import './send_message_form.dart';

class TeacherInformation extends StatefulWidget {
  final String name, username;

  TeacherInformation({this.name, this.username});
  @override
  _TeacherInformationState createState() => _TeacherInformationState();
}

class _TeacherInformationState extends State<TeacherInformation> {
  bool _showNewPassword = false;
  bool _showAddClass = false;
  bool _showRemoveClass = false;
  List<int> dropdownValues = [1, 1, 1, 1, 1];
  String _newPassword;
  Widget _body = CircularProgressIndicator();

  List<Map> _subjects;

  List<String> _subjectsNames;

  @override
  void initState() {
    _subjects = new List.filled(50, {}, growable: true);
    _subjectsNames = new List.filled(50, '', growable: true);
    try {
      // sleep(const Duration(seconds: 2));
      getSubjects();
      super.initState();
    } catch (e) {
      print('Loading content');
    }
  }

  void getSubjects() async {
    getNewToken();
    final storage = new FlutterSecureStorage();
    // print(widget.publicId);
    String url = 'http://localhost:5000/api/v1/subjects';
    String jwt = await storage.read(key: 'jwt');
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ' + jwt
    };
    var response = await http.get(
      url,
      headers: headers,
    );
    // print('Response status: ${response.statusCode}');
    // print('Response body: ${response.body}');
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      for (int i = 0; i < jsonResponse['data']['subjects'].length; i++) {
        Map currentElementMap = new Map();
        var currentElement = jsonResponse['data']['subjects'][i];
        currentElementMap['public_id'] = currentElement['public_id'];
        currentElementMap['name'] = currentElement['name'];

        _subjectsNames[i] = currentElementMap['name'];

        _subjects[i] = currentElementMap;
      }
      setState(() {});
    }
  }

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
      body: body(),
    );
  }

  Widget body() {
    return SafeArea(
      child: ListView(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            height: 70,
            color: HexColor('7a6bee'),
            child: QuicksandText(
              text: 'Prof. ' + widget.name,
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
                    'Ce doriți să faceți? Dumneavoastră aveți control asupra contului profesorului.',
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
                              text: 'Noua parolă a profesorului:',
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
                  text: 'Asociați o clasă nouă',
                  option: 'addClass',
                  color: '7a6bee',
                  splashColor: '604eee',
                  displayDialog: false,
                ),
                this._showAddClass
                    ? Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(15),
                            child: QuicksandText(
                              text:
                                  'Te rugăm să selectezi numarul și litera clasei dorite, precum și materia predată:',
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: 'f85568',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                dropdown(grades, 0),
                                dropdown(letters, 1),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(15),
                            child: dropdown(_subjectsNames, 2),
                          ),
                          actionButton(
                            context: context,
                            text: 'Asociați o clasă nouă',
                            option: 'addClass',
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
                  text: 'Disocierea unei clase cu profesorul',
                  option: 'removeClass',
                  color: '7a6bee',
                  splashColor: '604eee',
                  displayDialog: false,
                ),
                this._showRemoveClass
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
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                dropdown(grades, 3),
                                dropdown(letters, 4),
                              ],
                            ),
                          ),
                          actionButton(
                            context: context,
                            text: 'Disocierea unei clase cu profesorul',
                            option: 'removeClass',
                            color: 'f85568',
                            splashColor: 'f53a50',
                            displayDialog: true,
                          ),
                        ],
                      )
                    : SizedBox.shrink(),
                SizedBox(height: 30),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              showAlertDialog(
                  context, 'Ștergeți contul profesorului', 'deleteAccount');
            },
            child: QuicksandText(
              text: 'Ștergeți contul profesorului',
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

  Widget dropdown(items, dropdownNumber) {
    /*
    0, 1, 2: grade, letter si subject la asociere
    3, 4: grade, letter la disociere
    */
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: HexColor('7a6bee'), borderRadius: BorderRadius.circular(10)),
      child: DropdownButton(
          iconEnabledColor: Colors.white,
          iconDisabledColor: Colors.white,
          dropdownColor: HexColor('7a6bee'),
          value: dropdownValues[dropdownNumber],
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
              dropdownValues[dropdownNumber] = value;
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
            if (option == 'addClass')
              setState(() {
                this._showAddClass = true;
              });
            if (option == 'removeClass')
              setState(() {
                this._showRemoveClass = true;
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
          // print('Response body: ${response.body}');
          var jsonResponse = jsonDecode(response.body);
          if (response.statusCode == 200) {
            setState(() {
              _newPassword = jsonResponse['data']['password'];
              _showNewPassword = true;
            });
          }
        } else if (option == 'addClass') {
          // AICI ARE LOC REQUEST DE ASOCIERE CLASA
          String classGrade = grades[dropdownValues[0] - 1];
          String classLetter = letters[dropdownValues[1] - 1];
          String teacherUsername = widget.username;
          String subjectPublicId =
              _subjects[dropdownValues[2] - 1]['public_id'];
          getNewToken();
          final storage = new FlutterSecureStorage();
          // print(widget.publicId);
          String url = 'http://localhost:5000/api/v1/teacher';
          String schoolPublicId = await storage.read(key: 'school_public_id');
          String jwt = await storage.read(key: 'jwt');
          var body = {
            'teacher_username': teacherUsername,
            'school_public_id': schoolPublicId,
            'class_grade': classGrade,
            'class_letter': classLetter,
            'subject_public_id': subjectPublicId
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
            Navigator.pushReplacementNamed(context, '/operator_teachers');
          }
          setState(() {
            this._showAddClass = true;
          });
        } else if (option == 'removeClass') {
          String teacherUsername = widget.username;
          String classGrade = grades[dropdownValues[3] - 1];
          String classLetter = letters[dropdownValues[4] - 1];

          print(teacherUsername);
          print(classGrade);
          print(classLetter);

          getNewToken();
          final storage = new FlutterSecureStorage();
          String schoolPublicId = await storage.read(key: 'school_public_id');
          String url =
              'http://localhost:5000/api/v1/teacher?teacher_username=$teacherUsername&school_public_id=$schoolPublicId&class_grade=$classGrade&class_letter=$classLetter';
          String jwt = await storage.read(key: 'jwt');

          Map<String, String> headers = {
            'Content-type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ' + jwt,
          };
          var response = await http.delete(
            url,
            headers: headers,
          );
          // print('Response status: ${response.statusCode}');
          // print('Response body: ${response.body}');
          var jsonResponse = jsonDecode(response.body);
          if (response.statusCode == 200) {
            Navigator.pushReplacementNamed(context, '/operator_teachers');
          }
        }
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
