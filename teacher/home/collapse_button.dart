import 'package:flutter/material.dart';
import './../../quicksand_text.dart';
import './../../utils/hex_color.dart';

class CollapseButton extends StatefulWidget {
  @override
  _CollapseButtonState createState() => new _CollapseButtonState();
  final String text, color, splashColor, grade;
  final List classes;

  CollapseButton({
    this.text,
    this.color,
    this.splashColor,
    this.grade,
    this.classes,
  });
}

class _CollapseButtonState extends State<CollapseButton> {
  double _animatedHeight = 0.0;
  List<String> letters = [];
  bool _visible = false;

  @override
  void initState() {
    super.initState();
  }

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
                  text: widget.text,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: 'FFFFFF',
                  height: 1.5,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            new AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: _visible
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          ...(widget.classes).map((oneClass) {
                            return Padding(
                              padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
                              child: AnimatedOpacity(
                                opacity: _visible ? 1.0 : 0.0,
                                duration: Duration(milliseconds: 500),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 2,
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
                                      _animatedHeight != 0.0
                                          ? _animatedHeight = 0.0
                                          : _animatedHeight = 100.0;
                                      // print(oneClass['class_public_id']);
                                      Navigator.of(context).pushNamed(
                                        '/teacher_class_students_list',
                                        arguments: {
                                          'letter': oneClass['letter'],
                                          // 'letter': oneClass['public_id'],
                                          'classGrade': widget.text,
                                          'public_id': oneClass['public_id'],
                                          'subjectPublicId':
                                              oneClass['subject_public_id']
                                        },
                                      );
                                    }),
                                    child: QuicksandText(
                                      text: oneClass['letter'],
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                      color: 'FFFFFF',
                                      height: 1.5,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList()
                        ],
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
