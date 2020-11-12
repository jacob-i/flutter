import 'package:flutter/material.dart';
import './question.dart';
import './answer.dart';

class Quiz extends StatelessWidget {
  final Function answerQuestion;
  final int questionIndex;
  final List<Map<String, Object>> questions;
  final int selectedAnswer;

  Quiz({
    @required this.questions,
    @required this.answerQuestion,
    @required this.questionIndex,
    @required this.selectedAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Question(
            questions[questionIndex]['description'],
          ),
          ...(questions[questionIndex]['buttonsTexts'] as List<String>)
              .map((buttonText) {
            int index =
                (questions[questionIndex]['buttonsTexts'] as List<String>)
                    .indexOf(buttonText);
            return Answer(
              () => answerQuestion(
                (questions[questionIndex]['buttonAnswers']
                    as List<Object>)[index],
                index,
              ),
              buttonText,
              selectedAnswer == -1
                  ? 'regular'
                  : (questions[questionIndex]['buttonAnswers']
                              as List<Object>)[index] ==
                          1
                      ? 'green'
                      : selectedAnswer == index ? 'red' : 'regular',
            );
          }).toList()
        ],
      ),
    );
  }
}
