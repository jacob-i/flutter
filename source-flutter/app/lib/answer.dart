import 'package:flutter/material.dart';

class Answer extends StatelessWidget {
  final Function selectFunction;
  final String answer;
  final String type;

  Answer(
    this.selectFunction,
    this.answer,
    this.type,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 40.0, right: 40.0, top: 10.0),
      width: double.infinity,
      constraints: new BoxConstraints(
        maxWidth: 360.0,
        minHeight: 58.0,
      ),
      child: RaisedButton(
        color: type == 'regular'
            ? Colors.white
            : type == 'green' ? Colors.green : Colors.red,
        textColor: type == 'regular' ? Colors.black : Colors.white,
        child: Text(
          answer,
          style: new TextStyle(
            fontSize: 16.0,
          ),
          textAlign: TextAlign.center,
        ),
        onPressed: selectFunction,
      ),
    );
  }
}
