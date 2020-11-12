@JS()
library s;

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:js/js.dart';
import './result.dart';
import './quiz.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

@JS()
external int s(message);

void main() => runApp(Survey(null));

class _SurveyState extends State<Survey> {
  var _questionIndex = 0;
  var _appScreen = 'Loading';
  var _totalScore = 0;
  var _selectedAnswer = -1;
  var _questionsWithoutAnswers = 0;
  var _answers = '';

  String _title;
  String _mainColor;
  bool _showNumberResult = true;
  bool _showPercentageResult = true;
  bool _voice = false;

  Future<dynamic> loadContentFromAssets() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString("assets/survey.glowbom");
    return json.decode(data);
  }

  @override
  void initState() {
    super.initState();

    if (_content != null) {
      _questions = _content['questions'];
      if (_content.containsKey('title')) {
        _title = _content['title'];
      }

      if (_content.containsKey('main_color')) {
        _mainColor = _content['main_color'];
      } else {
        _mainColor = 'Blue';
      }

      if (_content.containsKey('show_number_result')) {
        _showNumberResult = _content['show_number_result'];
      } else {
        _showNumberResult = true;
      }

      if (_content.containsKey('show_percentage_result')) {
        _showPercentageResult = _content['show_percentage_result'];
      } else {
        _showPercentageResult = true;
      }

      if (_content.containsKey('voice')) {
        _voice = _content['voice'];
      } else {
        _voice = false;
      }

      _pressed100();
    } else {
      loadContentFromAssets().then((value) => setState(() {
            _content = value;
            if (_content.containsKey('title')) {
              _title = _content['title'];
              print('title: ' + _title);
            }

            if (_content.containsKey('main_color')) {
              _mainColor = _content['main_color'];
            } else {
              _mainColor = 'Blue';
            }

            if (_content.containsKey('show_number_result')) {
              _showNumberResult = _content['show_number_result'];
            } else {
              _showNumberResult = true;
            }

            if (_content.containsKey('show_percentage_result')) {
              _showPercentageResult = _content['show_percentage_result'];
            } else {
              _showPercentageResult = true;
            }

            if (_content.containsKey('voice')) {
              _voice = _content['voice'];
            } else {
              _voice = false;
            }

            _questions = List<Map<String, Object>>();
            List<dynamic> list = _content['questions'];
            for (int i = 0; i < list.length; i++) {
              dynamic item = list[i];
              dynamic question = {
                "title": item['title'].toString(),
                "description": item['description'].toString(),
                "buttonsTexts": List<String>.from(item['buttonsTexts']),
                "buttonAnswers": List<int>.from(item['buttonAnswers']),
                "answersCount": item['answersCount'],
                "goIndexes": List<int>.from(item['goIndexes']),
                "answerPicture": item['answerPicture'].toString(),
                "answerPictureDelay": item['answerPictureDelay'],
                "goConditions": [],
                "heroValues": [],
                "picturesSpriteNames": ["", "", "", "", "", ""]
              };
              _questions.add(question);
            }
            _pressed100();
          }));
    }
  }

  List<Map<String, Object>> _currentQuestions;
  var _content;

  _SurveyState(this._content);

  var _questions;

  void _restart() {
    setState(() {
      _answers = '';
      _appScreen = 'Menu';
      _questionIndex = 0;
      _totalScore = 0;
      _questionsWithoutAnswers = 0;
    });

    if (_content != null) {
      _pressed100();
    }

    if (!kIsWeb) {}
  }

  String getRandomOk() {
    Random rnd = new Random(DateTime.now().millisecondsSinceEpoch);

    List<String> answers = [
      'Ok...',
      'Okay...',
      'Alright...',
    ];

    int index = rnd.nextInt(answers.length);
    return answers[index];
  }

  void _answerQuestion(int score, int selectedAnswer) {
    _answers +=  _questions[_questionIndex]['buttonsTexts'][selectedAnswer] + ', ';

    if (_questions[_questionIndex]['answersCount'] == 0) {
      setState(() {
        _selectedAnswer = -1;
        ++_questionIndex;
        ++_questionsWithoutAnswers;
      });
      return;
    }

    _totalScore += (score >= 1 ? 1 : 0);

    setState(() {
      _selectedAnswer = selectedAnswer;
    });

    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        _selectedAnswer = -1;
        ++_questionIndex;
      });
    });

    print(_questionIndex);
  }

  var lastSpeech;

  void speak() {
    if (_voice) {
      try {
        var speech = _questionIndex > 0 ? getRandomOk() : '';
        speech += _questions[_questionIndex]['description'] + '... ';
        List<String> answers =
            _questions[_questionIndex]['buttonsTexts'] as List<String>;
        for (int i = 0; i < answers.length; i++) {
          speech += answers[i] + ',';
        }

        if (lastSpeech == speech) {
          return;
        }

        s(speech);
        lastSpeech = speech;
      } catch (e) {}
    }
  }

  List<Map<String, Object>> deepCopy(List<Map<String, Object>> items) {
    List<Map<String, Object>> result = List.from(
      {},
    );

    // Go through all elements.
    for (var i = 0; i < items.length; i++) {
      result.add(Map.from(items[i]));
    }

    return result;
  }

  void _pressed100() {
    setState(() {
      _questionIndex = 0;
      //_currentQuestions = _addNumbers(deepCopy(_questions));
      _currentQuestions = deepCopy(_questions);
      _appScreen = 'Test100';
    });
  }

  String getConclusionAndTalkIfNeeded() {
    var message = _content != null && _content.containsKey('conclusion')
        ? _content['conclusion']
        : 'Please send us your information and we\'ll come back to you shortly!';
    if (_voice) {
      try {
        s(message);
      } catch (e) {}
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    speak();
    return MaterialApp(
      title: 'Survey',
      theme: ThemeData(
        primaryColor: _mainColor == 'Green'
            ? Color.fromRGBO(85, 185, 158, 1)
            : _mainColor == 'Blue'
                ? Colors.blue
                : _mainColor == 'Red'
                    ? Colors.red
                    : _mainColor == 'Black' ? Colors.black : Colors.grey,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            _title != null ? _title : 'Quiz App',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: _appScreen == 'Loading'
            ? Center(
                child: Text('Loading...'),
              )
            : _questionIndex < _currentQuestions.length
                ? Quiz(
                    answerQuestion: _answerQuestion,
                    questions: _currentQuestions,
                    questionIndex: _questionIndex,
                    selectedAnswer: _selectedAnswer,
                  )
                : Result(
                    _totalScore,
                    _currentQuestions.length - _questionsWithoutAnswers,
                    _restart,
                    _showNumberResult,
                    _showPercentageResult,
                    getConclusionAndTalkIfNeeded(),
                    _content != null && _content.containsKey('start_over')
                        ? _content['start_over']
                        : '',
                    _answers),
      ),
    );
  }
}

class Survey extends StatefulWidget {
  final _content;

  Survey(this._content);

  @override
  State<StatefulWidget> createState() {
    return _SurveyState(_content);
  }
}
