/*
 * Created on Fri Aug 21 2020
 *
 * Copyright (c) 2020 Robert Feduș
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import './../utils/hex_color.dart';
import 'package:google_fonts/google_fonts.dart';
import './../quicksand_text.dart';
import './../main_button.dart';
import './form_field.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterForm extends StatefulWidget {
  @override
  RegisterFormState createState() {
    return RegisterFormState();
  }
}

class RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  bool _autoValidate = false;
  bool _switchValue = false;
  String _password;

  bool emptyField(String value) => value.length == 0 ? true : false;

  String validateName(String value) {
    if (emptyField(value)) {
      return 'Te rugăm să completezi câmpul de mai sus';
    }

    if (value.length < 3)
      return 'Numele trebuie să conțină minim 3 caractere';
    else
      return null;
  }

  String validateEmail(String value) {
    if (emptyField(value)) {
      return 'Te rugăm să completezi câmpul de mai sus';
    }

    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Te rugăm să introduci un e-mail corect';
    else
      return null;
  }

  String validatePassword(String value) {
    if (emptyField(value)) {
      return 'Te rugăm să completezi câmpul de mai sus';
    }

    if (value.length < 6)
      return 'Parola trebuie să conțină minim 6 caractere';
    else {
      setState(() {
        _password = value;
      });
      return null;
    }
  }

  String validatePasswordConfirmation(String value) {
    if (emptyField(value)) {
      return 'Te rugăm să completezi câmpul de mai sus';
    }

    if (_password != null && _password == value)
      return null;
    else {
      return 'Cele două parole nu coincid';
    }
  }

  void switchValueHandler(value) {
    setState(() {
      _switchValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          child: QuicksandText(
            text:
                'Pentru a crea un cont nou de părinte sau tutore legal, vă rugăm sa completați câmpurile de mai jos',
            fontWeight: FontWeight.w700,
            fontSize: 18,
            color: '4D5061',
            textAlign: TextAlign.center,
          ),
        ),
        Form(
          autovalidate: _autoValidate,
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: formUI(),
          ),
        ),
      ],
    );
  }

  Widget formUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AuthFormField(
          validate: validateName,
          keyboardType: TextInputType.name,
          obscureText: false,
          autocorrect: true,
          placeholder: 'Nume',
        ),
        SizedBox(height: 15),
        AuthFormField(
          validate: validateName,
          keyboardType: TextInputType.name,
          obscureText: false,
          autocorrect: true,
          placeholder: 'Prenume',
        ),
        SizedBox(height: 15),
        AuthFormField(
          validate: validateEmail,
          keyboardType: TextInputType.emailAddress,
          obscureText: false,
          autocorrect: true,
          placeholder: 'E-mail',
        ),
        SizedBox(height: 15),
        AuthFormField(
          validate: validateName,
          keyboardType: TextInputType.name,
          obscureText: false,
          autocorrect: true,
          placeholder: 'Nume de utilizator',
        ),
        SizedBox(height: 15),
        AuthFormField(
          validate: validatePassword,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          autocorrect: false,
          placeholder: 'Parolă',
        ),
        SizedBox(height: 15),
        AuthFormField(
          validate: validatePasswordConfirmation,
          keyboardType: TextInputType.visiblePassword,
          obscureText: true,
          autocorrect: false,
          placeholder: 'Confirmă parola',
        ),
        SizedBox(height: 15),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Switch(
              value: _switchValue,
              onChanged: switchValueHandler,
              activeColor: Colors.green,
            ),
            Flexible(
              fit: FlexFit.loose,
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.quicksand(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: HexColor('4D5061'),
                    height: 1.5,
                  ),
                  children: <TextSpan>[
                    TextSpan(text: 'Am citit și sunt de acord cu '),
                    TextSpan(
                      text: 'politica de confidențialitate ',
                      style: TextStyle(
                        color: HexColor('f85568'),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final url = 'https://inkless.ro/';
                          if (await canLaunch(url)) {
                            await launch(
                              url,
                              forceSafariVC: false,
                            );
                          }
                        },
                    ),
                    TextSpan(text: 'și cu '),
                    TextSpan(
                      text: 'termenii și condițiile de utilizare ',
                      style: TextStyle(
                        color: HexColor('f85568'),
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          final url = 'https://inkless.ro/';
                          if (await canLaunch(url)) {
                            await launch(
                              url,
                              forceSafariVC: false,
                            );
                          }
                        },
                    ),
                    TextSpan(text: 'Inkless'),
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: MainButton(
              background: '7a6bee',
              splashColor: '604eee',
              text: 'Confirmă',
              click: () {
                if (_formKey.currentState.validate() && _switchValue) {
                  FocusScope.of(context).unfocus();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    backgroundColor: HexColor('f85568'),
                    content: QuicksandText(
                      text: 'Se încarcă...',
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: 'FFFFFF',
                    ),
                  ));
                }
              }),
        ),
      ],
    );
  }
}
