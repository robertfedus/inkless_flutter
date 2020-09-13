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
import './absence_button.dart';
import 'package:vibration/vibration.dart';
import './../../page_title.dart';

class TeacherStudentAbsences extends StatefulWidget {
  final String name, username, userPublicId, subjectPublicId;
  final bool master;

  TeacherStudentAbsences(
      {this.name,
      this.username,
      this.userPublicId,
      this.subjectPublicId,
      this.master});
  @override
  _TeacherStudentAbsencesState createState() => _TeacherStudentAbsencesState();
}

class _TeacherStudentAbsencesState extends State<TeacherStudentAbsences> {
  List<Map> _absences;
  List<Map> _absences2;
  int _semester = 1, absencesArrayIndex = 0;
  String _semester1Average = '0', _semester2Average = '0';
  // _marks2 se refera la notele din semestrul 2
  int marksLength = 0;
  @override
  void initState() {
    _absences = new List.filled(100, {}, growable: true);
    _absences2 = new List.filled(100, {}, growable: true);
    try {
      // sleep(const Duration(seconds: 2));
      super.initState();
      getAbsences();
    } catch (e) {
      print('Loading content');
    }
  }

  int absencesIndex = 0, absences2Index = 0;

  void getAbsences() async {
    getNewToken();
    final storage = new FlutterSecureStorage();

    String url =
        'http://localhost:5000/api/v1/absence/absences?student_public_id=${widget.userPublicId}&subject_public_id=${widget.subjectPublicId}';
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
        marksLength = jsonResponse['data']['absences'].length;
      });
      for (int i = 0; i < jsonResponse['data']['absences'].length; i++) {
        Map currentElementMap = new Map();
        var currentElement = jsonResponse['data']['absences'][i];
        currentElementMap['motivated'] = currentElement['motivated'];
        currentElementMap['date'] = currentElement['date'].split('T')[0];
        currentElementMap['absence_public_id'] = currentElement['public_id'];
        currentElementMap['message'] = currentElement['message'];

        if (!currentElement['semester']) {
          _absences[absencesIndex] = currentElementMap;
          absencesIndex++;
        } else {
          _absences2[absences2Index] = currentElementMap;
          absences2Index++;
        }
      }
      setState(() {
        absencesArrayIndex = absencesIndex;
      });
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
          Navigator.of(context).pushNamed('/teacher_add_absence', arguments: {
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
            PageTitle(title: 'Absențe'),
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
                      absencesArrayIndex = absencesIndex;
                    else
                      absencesArrayIndex = absences2Index;
                  });
                },
              ),
            ),
            SizedBox(height: 25),
            for (int i = 0; i < absencesArrayIndex; i++)
              _semester == 1
                  ? AbsenceButton(
                      message: _absences[i]['message'],
                      absencePublicId: _absences[i]['absence_public_id'],
                      color: _absences[i]['motivated'] ? '7a6bee' : 'f85568',
                      splashColor:
                          _absences[i]['motivated'] ? 'f53a50' : '604eee',
                      motivated: _absences[i]['motivated'],
                      date: _absences[i]['date'],
                      master: widget.master,
                    )
                  : AbsenceButton(
                      message: _absences2[i]['message'],
                      absencePublicId: _absences2[i]['absence_public_id'],
                      color: _absences2[i]['motivated'] ? '7a6bee' : 'f85568',
                      splashColor:
                          _absences2[i]['motivated'] ? 'f53a50' : '604eee',
                      motivated: _absences2[i]['motivated'],
                      date: _absences2[i]['date'],
                      master: widget.master,
                    ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
