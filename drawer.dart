import 'package:flutter/material.dart';
import './utils/hex_color.dart';

import 'quicksand_text.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  final String appTitle = 'INKLESS';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final String title;

  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('INKLESS'),
      ),
      body: Center(
        child: QuicksandText(
          text: 'MENIU',
          fontWeight: FontWeight.w700,
          fontSize: 40,
          color: '7A6DD9',
        ),
      ),
      drawer: Drawer(
        child: buildListView(context),
      ),
      // ignore: empty_statements
    );
  }

  Container buildListView(context) {
    var onTap;
    return Container(
      color: HexColor('7a6bee'),
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text: 'Meniu',
                fontWeight: FontWeight.w700,
                fontSize: 45,
                color: 'FFFFFF',
              ),
            ),
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text: 'Acasă',
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: 'FFFFFF',
              ),
            ),
            onTap: () {
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text: 'Mesaje trimise',
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: 'FFFFFF',
              ),
            ),
            onTap: () {
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text: 'Orarul școlii',
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: 'FFFFFF',
              ),
            ),
            onTap: () {
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text: 'Profesori',
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: 'FFFFFF',
              ),
            ),
            onTap: () {
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Padding(
              padding: EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 25.0),
              child: QuicksandText(
                text: 'Setări',
                fontWeight: FontWeight.w700,
                fontSize: 25,
                color: 'FFFFFF',
              ),
            ),
            onTap: () {
              // Then close the drawer
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
