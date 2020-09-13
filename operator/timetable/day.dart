/*
 * Created on Tue Sep 01 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import './../../utils/hex_color.dart';
import './../../quicksand_text.dart';
import './../../main_button.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../../get_new_token.dart';
// import './send_message_form.dart';

class OperatorTimetableDay extends StatefulWidget {
  final String day;
  final int dayIndex;

  OperatorTimetableDay({this.day, this.dayIndex});
  @override
  _OperatorTimetableDayState createState() => _OperatorTimetableDayState();
}

class _OperatorTimetableDayState extends State<OperatorTimetableDay> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  List _hours;
  int messagesArrayLength;
  @override
  void initState() {
    // _hours = new List.filled(120, {}, growable: true);
    try {
      // sleep(const Duration(seconds: 2));
      getMessages();
      super.initState();
    } catch (e) {
      print('Loading content');
    }
  }

  Widget _body = CircularProgressIndicator();

  void getMessages() async {
    getNewToken();
    final storage = new FlutterSecureStorage();
    // print(widget.publicId);
    String schoolPublicId = await storage.read(key: 'school_public_id');
    String url =
        'http://localhost:5000/api/v1/timetable/all?school_public_id=' +
            schoolPublicId +
            '&day=' +
            widget.dayIndex.toString();
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
      _hours = jsonResponse['data']['hours'];
      setState(() {
        _body = pageBody();
      });
    }
  }

  void deleteHour(hourPublicId) async {
    getNewToken();
    final storage = new FlutterSecureStorage();
    String url =
        'http://localhost:5000/api/v1/timetable?timetable_class_public_id=' +
            hourPublicId;
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
    // print('Response body: ${response.body}');
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 200) {
      Navigator.of(context).pushNamed('/operator_timetable', arguments: '');
    }
  }

// "name": "Burcau Mihai",
  // "hours": [
  //     {
  //         "hour_public_id": "3597d5e7-a639-46ab-84c1-e87cf443aeb2",
  //         "time": "04:05:00",
  //         "grade": 10,
  //         "letter": "A",
  //         "subject_name": "Istorie"
  //     },

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor('f85568'),
        splashColor: HexColor('f53a50'),
        elevation: 0,
        child: Icon(Icons.add),
        onPressed: () async {
          if (await Vibration.hasVibrator()) {
            Vibration.vibrate(duration: 50);
          }
          Navigator.of(context).pushNamed('/operator_timetable_add_hour',
              arguments: {'dayIndex': widget.dayIndex});
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
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
      body: _body,
    );
  }

  Widget pageBody() {
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
              text: widget.day,
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
                    'Mai jos găsiți lista cu profesorii si orele în care predau:',
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: '7a6bee',
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  ...(_hours).map((hour) {
                    return teacherTimetable(
                        teacherName: hour['name'], hours: hour['hours']);
                  }).toList(),

                  // teacherTimetable(
                  //   teacherName: 'Fedus Robert',
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget teacherTimetable({String teacherName, List hours}) {
    return Column(
      children: <Widget>[
        QuicksandText(
          text: 'Prof. ' + teacherName,
          fontWeight: FontWeight.w700,
          fontSize: 23,
          color: '4d5061',
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 30),
        SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(
                label: QuicksandText(
                  text: 'Ora',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: '7a6bee',
                  textAlign: TextAlign.center,
                ),
              ),
              DataColumn(
                label: QuicksandText(
                  text: 'Clasa',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: '7a6bee',
                  textAlign: TextAlign.center,
                ),
              ),
              DataColumn(
                label: QuicksandText(
                  text: 'Materia',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: '7a6bee',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            rows: tableRows(hours),
          ),
        ),
        SizedBox(height: 50),
      ],
    );
  }

  List<DataRow> tableRows(hours) {
    return [
      for (int i = 0; i < hours.length; i++)
        DataRow(
          cells: [
            DataCell(
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                children: [
                  QuicksandText(
                    text: hours[i]['time'].split(':')[0] +
                        ':' +
                        hours[i]['time'].split(':')[1],
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: '4d5061',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              onTap: () {
                showAlertDialog(
                    context, 'Ștergeți ora', hours[i]['hour_public_id']);
              },
            ),
            DataCell(
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                children: [
                  QuicksandText(
                    text: hours[i]['grade'].toString() +
                        hours[i]['letter'].toString(),
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: '4d5061',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              onTap: () {
                showAlertDialog(
                    context, 'Ștergeți ora', hours[i]['hour_public_id']);
              },
            ),
            DataCell(
              Wrap(
                direction: Axis.horizontal,
                alignment: WrapAlignment.start,
                children: [
                  QuicksandText(
                    text: hours[i]['subject_name'],
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: '4d5061',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              onTap: () {
                showAlertDialog(
                    context, 'Ștergeți ora', hours[i]['hour_public_id']);
              },
            ),
          ],
        ),
    ];
  }

  void showAlertDialog(
      BuildContext context, String titleText, String hourPublicId) {
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
      onPressed: () {
        deleteHour(hourPublicId);
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
