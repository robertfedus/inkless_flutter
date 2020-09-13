import 'package:flutter/material.dart';
import './../../quicksand_text.dart';
import './../../utils/hex_color.dart';
import './alert_dialog.dart';

class CollapseButton extends StatefulWidget {
  @override
  _CollapseButtonState createState() => new _CollapseButtonState();
  final String text, color, splashColor, destination, testPublicId;

  CollapseButton({
    this.text,
    this.color,
    this.splashColor,
    this.destination,
    this.testPublicId,
  });
}

class _CollapseButtonState extends State<CollapseButton> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return new Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  side: BorderSide(
                    color: HexColor(widget.color),
                  ),
                ),
                color: HexColor(widget.color),
                textColor: Colors.white,
                disabledColor: Colors.grey,
                disabledTextColor: Colors.black,
                padding: EdgeInsets.all(8.0),
                splashColor: HexColor(widget.splashColor),
                onPressed: () => setState(() {
                  _visible = !_visible;
                }),
                child: QuicksandText(
                  text: 'Clasa ${widget.text}',
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: 'FFFFFF',
                  height: 1.5,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: _visible
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: AnimatedOpacity(
                          opacity: _visible ? 1.0 : 0.0,
                          duration: Duration(milliseconds: 500),
                          child: Container(
                            decoration: BoxDecoration(
                              color: HexColor('7a6bee'),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  child: QuicksandText(
                                    text: 'Pentru ' + widget.destination,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: 'f85568',
                                    height: 1.6,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 5, 20, 20),
                                  child: QuicksandText(
                                    text: 'Clasa ${widget.text}',
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                    color: 'FFFFFF',
                                    height: 1.6,
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                ListTile(
                                  onTap: () {
                                    showAlertDialog(
                                      context,
                                      'Ștergeți testul',
                                      widget.testPublicId,
                                    );
                                  },
                                  title: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: QuicksandText(
                                      text: 'Ștergeți testul',
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12,
                                      color: 'f85568',
                                      height: 1.6,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              // height: _animatedHeight,
            )
          ],
        ),
      ),
    );
  }
}
