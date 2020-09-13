/*
 * Created on Tue Aug 25 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import './../../utils/toggle_widget.dart';
import 'package:flutter/material.dart';
import './../../utils/hex_color.dart';
import './../../quicksand_text.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../../get_new_token.dart';
import './mark_button.dart';
import 'package:vibration/vibration.dart';

class TeacherStudentInformation extends StatefulWidget {
  final String name, username, userPublicId, subjectPublicId;

  TeacherStudentInformation(
      {this.name, this.username, this.userPublicId, this.subjectPublicId});
  @override
  _TeacherStudentInformationState createState() =>
      _TeacherStudentInformationState();
}

class _TeacherStudentInformationState extends State<TeacherStudentInformation> {
  List<Map> _marks;
  List<Map> _marks2;
  int _semester = 1, marksArrayIndex = 0;
  String _semester1Average = '0', _semester2Average = '0';
  // _marks2 se refera la notele din semestrul 2
  int marksLength = 0;
  @override
  void initState() {
    _marks = new List.filled(100, {}, growable: true);
    _marks2 = new List.filled(100, {}, growable: true);
    try {
      // sleep(const Duration(seconds: 2));
      super.initState();
      getMarks();
    } catch (e) {
      print('Loading content');
    }
  }

  int marksIndex = 0, marks2Index = 0;

  void getMarks() async {
    getNewToken();
    final storage = new FlutterSecureStorage();

    String url =
        'http://localhost:5000/api/v1/mark/marks?student_public_id=${widget.userPublicId}&subject_public_id=${widget.subjectPublicId}';
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
      setState(() {
        marksLength = jsonResponse['data']['marks'].length;
      });
      for (int i = 0; i < jsonResponse['data']['marks'].length; i++) {
        Map currentElementMap = new Map();
        var currentElement = jsonResponse['data']['marks'][i];
        currentElementMap['value'] = currentElement['value'].toString();
        currentElementMap['message'] = currentElement['message'];
        currentElementMap['thesis'] = currentElement['thesis'];
        currentElementMap['date'] = currentElement['date'].split('T')[0];
        currentElementMap['mark_public_id'] = currentElement['public_id'];

        if (!currentElement['semester']) {
          _marks[marksIndex] = currentElementMap;
          marksIndex++;
        } else {
          _marks2[marks2Index] = currentElementMap;
          marks2Index++;
        }
      }
      setState(() {
        marksArrayIndex = marksIndex;
      });

      _semester1Average = calculateAverage(_marks, 1).toStringAsFixed(2);
      _semester2Average = calculateAverage(_marks2, 2).toStringAsFixed(2);
    }
  }

  double calculateAverage(List marks, int semester) {
    bool hasThesis = false;
    int marksSum = 0, thesis, marksNumber = 0, marksLength;
    if (semester == 1)
      marksLength = marksIndex;
    else
      marksLength = marks2Index;

    for (int i = 0; i < marksLength; i++) {
      if (marks[i]['thesis']) {
        hasThesis = true;
        thesis = int.parse(marks[i]['value']);
      } else {
        marksSum += int.parse(marks[i]['value']);
        marksNumber++;
      }
    }

    if (hasThesis && marksLength == 1) return thesis * 1.0;

    if (hasThesis) {
      return (3 * (marksSum / marksNumber) + thesis) / 4;
    } else {
      return marksSum / marksNumber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor('f85568'),
        splashColor: HexColor('f53a50'),
        elevation: 0,
        child: Icon(Icons.add),
        onPressed: () async {
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 50);
          }
          Navigator.of(context).pushNamed('/teacher_add_mark', arguments: {
            'studentPublicId': widget.userPublicId,
            'subjectPublicId': widget.subjectPublicId
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        // notchMargin: 5,
        shape: CircularNotchedRectangle(),
        color: HexColor('7a6bee'),
        child: Container(
          height: 30.0,
        ),
      ),
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
      body: Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 70,
              color: HexColor('7a6bee'),
              child: QuicksandText(
                text: 'Note',
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: 'FFFFFF',
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/teacher_student_absences', arguments: {
                      'studentPublicId': widget.userPublicId,
                      'subjectPublicId': widget.subjectPublicId
                    });
                  },
                  child: QuicksandText(
                    text: 'Vedeți absențele',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: 'f85568',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 30),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context)
                        .pushNamed('/teacher_send_message', arguments: {
                      'studentPublicId': widget.userPublicId,
                      'subjectPublicId': widget.subjectPublicId
                    });
                  },
                  child: QuicksandText(
                    text: 'Trimiteți mesaj',
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    color: 'f85568',
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(50, 30, 50, 0),
              child: ToggleWidget(
                cornerRadius: 25,
                initialLabel: 0,
                activeBgColor: HexColor('7a6bee'),
                activeTextColor: 'f85568',
                inactiveBgColor: HexColor('7a6bee'),
                inactiveTextColor: 'ffffff',
                labels: ['Semestrul 1', 'Semestrul 2'],
                onToggle: (index) {
                  setState(() {
                    _semester = index + 1;

                    if (index == 0)
                      marksArrayIndex = marksIndex;
                    else
                      marksArrayIndex = marks2Index;
                  });
                },
              ),
            ),
            SizedBox(height: 25),
            Center(
              child: _semester != null
                  ? QuicksandText(
                      text: _semester == 1
                          ? 'Media $_semester1Average'
                          : 'Media $_semester2Average',
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                      color: '4d5061',
                    )
                  : SizedBox.shrink(),
            ),
            // Container(
            //   margin: const EdgeInsets.only(top: 15, bottom: 15),
            //   alignment: Alignment.center,
            //   width: double.infinity,
            //   child: QuicksandText(
            //     text: 'Prof. diriginte: Fedus Robert',
            //     fontWeight: FontWeight.w700,
            //     fontSize: 20,
            //     color: '7a6bee',
            //   ),
            // ),
            SizedBox(height: 25),
            for (int i = 0; i < marksArrayIndex; i++)
              _semester == 1
                  ? MarkButton(
                      value: _marks[i]['value'],
                      message: _marks[i]['message'],
                      markPublicId: _marks[i]['mark_public_id'],
                      color: _marks[i]['thesis'] ? 'f85568' : '7a6bee',
                      splashColor: _marks[i]['thesis'] ? 'f53a50' : '604eee',
                      thesis: _marks[i]['thesis'],
                      date: _marks[i]['date'],
                    )
                  : MarkButton(
                      value: _marks2[i]['value'],
                      message: _marks2[i]['message'],
                      markPublicId: _marks2[i]['mark_public_id'],
                      color: _marks2[i]['thesis'] ? 'f85568' : '7a6bee',
                      splashColor: _marks2[i]['thesis'] ? 'f53a50' : '604eee',
                      thesis: _marks2[i]['thesis'],
                      date: _marks2[i]['date'],
                    ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
