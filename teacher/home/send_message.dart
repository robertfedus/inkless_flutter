/*
 * Created on Thu Aug 27 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';
import '../../utils/hex_color.dart';
import '../../quicksand_text.dart';
import '../../page_title.dart';
import './send_message_form.dart';

class SendMessage extends StatefulWidget {
  final String studentPublicId;
  SendMessage({this.studentPublicId});
  @override
  _SendMessageState createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {
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
          PageTitle(title: 'Trimiteți un mesaj'),
          SendMessageForm(
            studentPublicId: widget.studentPublicId,
          ),
        ],
      ),
    );
  }
}
