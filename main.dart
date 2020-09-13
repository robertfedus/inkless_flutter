import 'package:flutter/material.dart';
import 'utils/hex_color.dart';

import 'operator/home/operator_home.dart';
import './teacher/home/teacher_home.dart';
import './route_generator.dart';
import './auth/welcome.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(
    Phoenix(
      child: Inkless(),
    ),
  );
}

class Inkless extends StatefulWidget {
  @override
  _InklessState createState() => _InklessState();
}

class _InklessState extends State<Inkless> {
  String _role;
  String _jwt;
  Widget _pageByRole;
  @override
  void initState() {
    super.initState();
    getStorage();
  }

  void getStorage() async {
    final storage = new FlutterSecureStorage();
    // await storage.deleteAll();
    String jwt = await storage.read(key: 'jwt');
    String role = await storage.read(key: 'role');

    // await storage.delete(key: 'jwt');
    // await storage.delete(key: 'role');

    setState(() {
      this._jwt = jwt;
      this._role = role;
    });
    // print(this._jwt);
    // print(this._role);
    if (this._role == 'operator') {
      setState(() {
        this._pageByRole = new OperatorHome();
      });
    } else if (this._role == 'profesor') {
      setState(() {
        this._pageByRole = new TeacherHome();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );

    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [const Locale('ro')],
      theme: ThemeData(
        scaffoldBackgroundColor: HexColor('F2F3F8'),
      ),
      home: this._role == null ? Welcome() : this._pageByRole,
      // initialRoute: this._role == null ? '/' : this._pageByRole,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
    // return MaterialApp(home: Operator());
  }
}
