import 'package:flutter/material.dart';
import './quicksand_text.dart';
import './utils/hex_color.dart';

class PageTitle extends StatelessWidget {
  final String title;

  PageTitle({this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 70,
      color: HexColor('7a6bee'),
      child: QuicksandText(
        text: this.title,
        fontWeight: FontWeight.w700,
        fontSize: 25,
        color: 'FFFFFF',
      ),
    );
  }
}
