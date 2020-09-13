/*
 * Created on Mon Aug 24 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import '../../utils/hex_color.dart';
import 'package:diagonal/diagonal.dart';

import '../../quicksand_text.dart';
import '../drawer.dart';
import './collapse_button.dart';
import 'package:vibration/vibration.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../../get_new_token.dart';

class OperatorHome extends StatefulWidget {
  @override
  _OperatorHomeState createState() => _OperatorHomeState();
}

class _OperatorHomeState extends State<OperatorHome> {
  Map _classes = {'data': '0'};
  String _userName; // Not username!

  @override
  void initState() {
    try {
      super.initState();
      getClasses();
    } catch (e) {
      print('Loading content');
    }
  }

  void getClasses() async {
    getNewToken();
    final storage = new FlutterSecureStorage();
    String name = await storage.read(key: 'name');
    setState(() {
      _userName = name;
    });

    String jwt = await storage.read(key: 'jwt');
    String schoolPublicId = await storage.read(key: 'school_public_id');
    String url = 'http://localhost:5000/api/v1/classes?school_public_id=' +
        schoolPublicId;
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
      Map classes = {
        '5': [],
        '6': [],
        '7': [],
        '8': [],
        '9': [],
        '10': [],
        '11': [],
        '12': [],
      };
      for (int i = 0; i < jsonResponse['data'].length; i++) {
        var currentElement = jsonResponse['data'][i];

        Map oneClass = {};

        oneClass['letter'] = currentElement['letter'];
        oneClass['public_id'] = currentElement['public_id'];

        String currentElementGrade = currentElement['grade'].toString();
        classes[currentElementGrade].add(oneClass);
      }
      setState(() {
        this._classes = classes;
      });
    }
  }

  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
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
                  .pushNamed('/operator_add_class', arguments: '');
            },
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomAppBar(
            // notchMargin: 5,
            shape: CircularNotchedRectangle(),
            color: HexColor('7a6bee'),
            child: Container(
              height: 30.0,
            ),
          ),
          drawer: Drawer(child: OperatorDrawer(colored: 'acasa')),
          key: _scaffoldKey,
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
          body: body()),
    );
  }

  Widget body() {
    try {
      return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: ListView(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 35),
              child: Diagonal(
                clipHeight: 70.0,
                child: Container(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(30, 0, 30, 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image(
                          height: 200,
                          image: AssetImage(
                            'assets/teacher.png',
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            QuicksandText(
                              text: 'Bine ați revenit,',
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: 'FFFFFF',
                            ),
                            QuicksandText(
                              text: _userName,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: 'FFFFFF',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  height: 250,
                  width: MediaQuery.of(context).size.width,
                  color: HexColor('7a6bee'),
                ),
              ),
            ),
            for (var key in this._classes.keys)
              int.parse(key) % 2 == 0
                  ? CollapseButton(
                      text: 'Clasa a ' + key + '-a',
                      color: '7a6bee',
                      splashColor: '604eee',
                      grade: key,
                      classes: this._classes[key],
                    )
                  : CollapseButton(
                      text: 'Clasa a ' + key + '-a',
                      color: 'f85568',
                      splashColor: 'f53a50',
                      grade: key,
                      classes: this._classes[key],
                    )
          ],
        ),
      );
    } catch (e) {
      print('Loading content...');
    }
  }
}
