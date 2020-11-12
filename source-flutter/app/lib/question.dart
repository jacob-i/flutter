import 'package:flutter/material.dart';

class Question extends StatelessWidget {
  final String questionText;

  Question(this.questionText);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: new BoxConstraints(
        maxWidth: 360.0,
        minHeight: 80.0,
      ),
      margin: const EdgeInsets.only(
        left: 40.0,
        right: 40.0,
        bottom: 8.0,
      ),
      child: Text(
        questionText,
        style: TextStyle(
          fontSize: 21,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
