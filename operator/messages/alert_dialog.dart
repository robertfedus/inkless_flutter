import 'package:flutter/material.dart';
import './../../quicksand_text.dart';
import './../../utils/hex_color.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import './../../get_new_token.dart';

void showAlertDialog(
    BuildContext context, String titleText, String messagePublicId) {
  Widget cancelButton = FlatButton(
    splashColor: HexColor('f53a50'),
    child: QuicksandText(
      text: 'Nu',
      fontWeight: FontWeight.w700,
      fontSize: 17,
      color: 'FFFFFF',
      height: 1.5,
      textAlign: TextAlign.center,
    ),
    onPressed: () {
      Navigator.of(context, rootNavigator: true).pop('dialog');
    },
  );
  Widget continueButton = FlatButton(
    splashColor: HexColor('f53a50'),
    child: QuicksandText(
      text: 'Da',
      fontWeight: FontWeight.w700,
      fontSize: 17,
      color: 'FFFFFF',
      height: 1.5,
      textAlign: TextAlign.center,
    ),
    onPressed: () async {
      getNewToken();
      final storage = new FlutterSecureStorage();
      // print(widget.publicId);
      String senderPublicId = await storage.read(key: 'public_id');
      String url = 'http://localhost:5000/api/v1/message?message_public_id=' +
          messagePublicId +
          '&sender_public_id=' +
          senderPublicId;
      String jwt = await storage.read(key: 'jwt');
      Map<String, String> headers = {
        'Content-type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer ' + jwt
      };
      var response = await http.delete(
        url,
        headers: headers,
      );
      // print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      var jsonResponse = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, '/operator_home');
      }

      // Navigator.of(context, rootNavigator: true).pop('dialog');
    },
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: HexColor('f85568'),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(25.0),
      ),
    ),
    title: QuicksandText(
      text: titleText,
      fontWeight: FontWeight.w700,
      fontSize: 20,
      color: 'FFFFFF',
      height: 1.5,
    ),
    content: QuicksandText(
      text: 'Sigur doriți să faceți asta?',
      fontWeight: FontWeight.w500,
      fontSize: 17,
      color: 'FFFFFF',
      height: 1.5,
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
