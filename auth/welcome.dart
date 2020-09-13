/*
 * Created on Fri Aug 21 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/material.dart';

import './../utils/hex_color.dart';
import './../quicksand_text.dart';
import './../logo.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: BottomAppBar(
            color: Colors.transparent,
            child: IntrinsicHeight(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(
                            color: HexColor('7a6bee'),
                          ),
                        ),
                        color: HexColor('7a6bee'),
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        splashColor: HexColor('604eee'),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/register',
                              arguments: 'Hello from first page');
                        },
                        child: QuicksandText(
                          text: 'Înregistrare',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: 'FFFFFF',
                          height: 1.5,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    SizedBox(height: 7),
                    SizedBox(
                      width: double.infinity,
                      child: FlatButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                          side: BorderSide(
                            color: HexColor('f85568'),
                          ),
                        ),
                        color: HexColor('f85568'),
                        textColor: Colors.white,
                        disabledColor: Colors.grey,
                        disabledTextColor: Colors.black,
                        padding: EdgeInsets.all(8.0),
                        splashColor: HexColor('f53a50'),
                        onPressed: () {
                          Navigator.of(context).pushNamed('/login',
                              arguments: 'Hello from first page');
                        },
                        child: QuicksandText(
                          text: 'Autentificare',
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          color: 'FFFFFF',
                          height: 1.5,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            elevation: 0,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Logo(),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
            child: QuicksandText(
              text: 'By Noname',
              fontWeight: FontWeight.w400,
              fontSize: 25,
              color: '4D5061',
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(
            height: 100,
          ),
          Center(
            child: QuicksandText(
              text: 'Bine ai venit',
              fontWeight: FontWeight.w700,
              fontSize: 30,
              color: '4D5061',
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: QuicksandText(
                text:
                    'Pentru a intra în contul dvs. apăsați pe “Autentificare”. Dacă sunteți părinte și nu aveți cont, apăsați pe “Înregistrare”.',
                fontWeight: FontWeight.w400,
                fontSize: 17,
                color: '4D5061',
                height: 1.5,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
