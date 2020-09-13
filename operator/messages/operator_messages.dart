/*
 * Created on Thu Aug 27 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import '../../utils/hex_color.dart';
import 'package:diagonal/diagonal.dart';

import '../../quicksand_text.dart';
import '../drawer.dart';
import 'package:vibration/vibration.dart';
import './../../page_title.dart';
import './collapse_button.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../../get_new_token.dart';

class OperatorMessages extends StatefulWidget {
  @override
  _OperatorMessagesState createState() => _OperatorMessagesState();
}

class _OperatorMessagesState extends State<OperatorMessages> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<Map> _messages;
  int messagesArrayLength;

  @override
  void initState() {
    _messages = new List.filled(120, {}, growable: true);
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
        'http://localhost:5000/api/v1/message/sender?sender_public_id=' +
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
        messagesArrayLength = jsonResponse['data']['messages'].length;
      });
      for (int i = 0; i < jsonResponse['data']['messages'].length; i++) {
        Map currentElementMap = new Map();
        var currentElement = jsonResponse['data']['messages'][i];
        currentElementMap['public_id'] = currentElement['public_id'];
        currentElementMap['time'] = currentElement['time'];
        currentElementMap['message'] = currentElement['message'];
        currentElementMap['receiver_name'] =
            currentElement['receiver_last_name'] +
                ' ' +
                currentElement['receiver_first_name'];

        _messages[i] = currentElementMap;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(child: OperatorDrawer(colored: 'mesajeTrimise')),
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
      body: body(),
    );
  }

  Widget body() {
    try {
      return ListView(
        children: <Widget>[
          PageTitle(title: 'Mesaje trimise'),
          SizedBox(height: 20),
          for (int i = 0; i < messagesArrayLength; i++)
            message(
              destination: _messages[i]['receiver_name'],
              date: _messages[i]['time'].split('T')[0],
              text: _messages[i]['message'],
              messagePublicId: _messages[i]['public_id'],
            ),
        ],
      );
    } catch (e) {
      print('Loading content...');
    }
  }

  Widget message(
      {String date, String text, String destination, String messagePublicId}) {
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
          messagePublicId: messagePublicId,
        )
      ],
    );
  }
}
