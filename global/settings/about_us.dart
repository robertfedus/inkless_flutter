/*
 * Created on Tue Sep 01 2020
 *
 * Copyright (c) 2020 Robert Feduș
*/

import 'package:flutter/material.dart';
import './../../quicksand_text.dart';
import './../../utils/hex_color.dart';
import './../../page_title.dart';

class AboutUs extends StatelessWidget {
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
      body: ListView(
        children: <Widget>[
          PageTitle(title: 'Despre noi'),
          Padding(
            padding: EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 25.0),
            child: QuicksandText(
              text:
                  'Noi suntem Tech Lion, o echipă formată din doi liceeni pasionați de tehnologie si programare: Vincu Alexandra si Feduș Robert.',
              fontWeight: FontWeight.w700,
              fontSize: 22,
              height: 1.6,
              color: '7A6DD9',
            ),
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text:
                    'Alexandra se ocupă de menținerea, dezvoltarea și design-ul estetic al aplicației de mobil in cadrul proiectului Inkless. Alexandra nu a mai profesat in domeniu, iar Inkless reprezintă prima ei aplicație. Este pasionată de editare, design și bineînțeles de programare. Aceasta a descoperit recent lumea IT-ului si a prezentat un interes ridicat pentru dezvoltarea proiectului Inkless. Este dornică de a aduce proiectele echipei Tech Lion la un nivel înalt si are încredere în munca si dedicarea echipei.',
                fontWeight: FontWeight.w400,
                fontSize: 22,
                height: 1.6,
                color: '7A6DD9',
              ),
            ),
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text:
                    'Robert este responsabil de site-urile Web, de server și de bazele de date, precum și de arhitectura aplicației de mobil. A început programarea și dezvoltarea site-urilor web în mai 2019 și de atunci s-a îndrăgostit de tehnologiile și limbajele de programare implicate în acest domeniu. Robert a creat o multitudine de aplicații și site-uri la nivel profesional, în ciuda vârstei sale. E pasionat și determinat cu privire la ideile mărețe ale proiectului Inkless.',
                fontWeight: FontWeight.w400,
                fontSize: 22,
                height: 1.6,
                color: '7A6DD9',
              ),
            ),
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text:
                    'Tech Lion promite actualizări și îmbunătățiri constante în ceea ce privesc aplicațiile web și de mobil, pentru o experiență placută si ușoară. Un tip de experiență garantat de Tech Lion în toate proiectele viitoare.',
                fontWeight: FontWeight.w400,
                fontSize: 22,
                height: 1.6,
                color: '7A6DD9',
              ),
            ),
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text:
                    'Pentru mai multe informații/cereri de aplicații și site-uri, contactați-ne la e-mailul admin@inkless.ro.',
                fontWeight: FontWeight.w400,
                fontSize: 22,
                height: 1.6,
                color: '7A6DD9',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
