import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void getNewToken() async {
  var storage = new FlutterSecureStorage();

  String refresh_token = await storage.read(key: 'refresh_token');
  String jwt = await storage.read(key: 'jwt');

  String url = 'http://localhost:5000/api/v1/auth/refresh?jwt=' +
      jwt +
      '&refresh_token=' +
      refresh_token;
  Map<String, String> headers = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
  };
  var response = await http.get(
    url,
    headers: headers,
  );
  // print('Response status: ${response.statusCode}');
  // print('Response body: ${response.body}');
  var jsonResponse = jsonDecode(response.body);
  if (response.statusCode == 200) {
    // jstonResponse['data'];
    await storage.write(key: 'jwt', value: jsonResponse['data']['jwt']);
  }
}
