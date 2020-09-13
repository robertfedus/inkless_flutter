/*
 * Created on Thu Aug 27 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import '../../utils/hex_color.dart';

import '../../quicksand_text.dart';
import './../drawer.dart';
import '../../page_title.dart';
import 'collapse_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../get_new_token.dart';
import 'package:vibration/vibration.dart';

class TeacherTests extends StatefulWidget {
  @override
  _TeacherTestsState createState() => _TeacherTestsState();
}

class _TeacherTestsState extends State<TeacherTests> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Map> _tests;
  int testsArrayLength;

  @override
  void initState() {
    _tests = new List.filled(120, {}, growable: true);
    try {
      // sleep(const Duration(seconds: 2));
      super.initState();
      getMessages();
    } catch (e) {
      print('Loading content');
    }
  }

  void getMessages() async {
    getNewToken();
    final storage = new FlutterSecureStorage();
    // print(widget.publicId);
    String senderPublicId = await storage.read(key: 'public_id');
    String url =
        'http://localhost:5000/api/v1/test/sender?teacher_user_public_id=' +
            senderPublicId;
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
        testsArrayLength = jsonResponse['data']['tests'].length;
      });
      for (int i = 0; i < jsonResponse['data']['tests'].length; i++) {
        Map currentElementMap = new Map();
        var currentElement = jsonResponse['data']['tests'][i];
        currentElementMap['public_id'] = currentElement['public_id'];
        currentElementMap['time'] = currentElement['due'];
        currentElementMap['message'] = currentElement['message'];
        currentElementMap['class'] = currentElement['class_grade'].toString() +
            currentElement['class_letter'];

        _tests[i] = currentElementMap;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: TeacherDrawer(colored: 'tests')),
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
          Navigator.of(context)
              .pushNamed('/teacher_add_test', arguments: {'dayIndex': 5});
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
        leading: IconButton(
          icon: Icon(Icons.menu, size: 40), // change this size and style
          onPressed: () => _scaffoldKey.currentState.openDrawer(),
        ),
        elevation: 0.0,
        backgroundColor: HexColor('7a6bee'),
        centerTitle: true,
        title: Column(
          children: [
            QuicksandText(
              text: 'INKLESS',
              fontWeight: FontWeight.w700,
              fontSize: 40,
              color: 'FFFFFF',
            ),
          ],
        ),
      ),
      body: body(),
    );
  }

  Widget body() {
    try {
      return ListView(
        children: <Widget>[
          PageTitle(title: 'Teste'),
          SizedBox(height: 20),
          for (int i = 0; i < testsArrayLength; i++)
            message(
              destination: _tests[i]['class'],
              date: _tests[i]['time'].split('T')[0],
              text: _tests[i]['class'],
              testPublicId: _tests[i]['public_id'],
            ),
        ],
      );
    } catch (e) {
      print('Loading content...');
    }
  }

  Widget message(
      {String date, String text, String destination, String testPublicId}) {
    return Column(
      children: <Widget>[
        QuicksandText(
          text: date,
          fontWeight: FontWeight.w400,
          fontSize: 15,
          color: 'f85568',
        ),
        CollapseButton(
          text: text,
          color: '7a6bee',
          splashColor: '7a6bee',
          destination: destination,
          testPublicId: testPublicId,
        )
      ],
    );
  }
}
