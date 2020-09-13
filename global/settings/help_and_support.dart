/*
 * Created on Tue Sep 01 2020
 *
 * Copyright (c) 2020 Robert Feduș
*/

import 'package:flutter/material.dart';
import './../../quicksand_text.dart';
import './../../utils/hex_color.dart';
import './../../page_title.dart';

class HelpAndSupport extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: HexColor('F2F3F8'),
      appBar: AppBar(
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
      body: Column(
        children: <Widget>[
          PageTitle(title: 'Ajutor și suport'),
          Padding(
            padding: EdgeInsets.fromLTRB(1, 10, 10, 10),
            child: QuicksandText(
              text: 'Cu ce vă putem ajuta?',
              fontWeight: FontWeight.w700,
              fontSize: 25,
              color: '7A6DD9',
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(30, 10, 10, 10),
            child: QuicksandText(
              height: 1.5,
              text:
                  'Trimiteți un e-mail către admin@inkless.ro și vom reveni cu un mesaj! :)',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: '7A6DD9',
            ),
          ),
        ],
      ),
    );
  }
}
