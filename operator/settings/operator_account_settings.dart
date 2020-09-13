import 'package:flutter/material.dart';
import './../../quicksand_text.dart';
import './../../utils/hex_color.dart';
import './../../main_button.dart';
import './../../page_title.dart';

class OperatorAccountSettings extends StatefulWidget {
  @override
  _OperatorAccountSettingsState createState() =>
      _OperatorAccountSettingsState();
}

class _OperatorAccountSettingsState extends State<OperatorAccountSettings> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          PageTitle(title: 'Cont'),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: MainButton(
              background: 'F36878',
              splashColor: 'FA6DD9',
              text: 'Schimbați parola',
              textColor: 'FFFFFF',
              click: () {
                Navigator.of(context)
                    .pushNamed('/change_password', arguments: '');
              },
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: MainButton(
              background: 'F36878',
              splashColor: 'FA6DD9',
              text: 'Schimbați e-mail-ul',
              textColor: 'FFFFFF',
              click: () {
                Navigator.of(context).pushNamed('/change_email', arguments: '');
              },
            ),
          ),
        ],
      ),
    );
  }
}
