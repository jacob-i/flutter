import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Result extends StatefulWidget {
  final bool showResult;
  final bool showScore;
  final String conclusion;
  final String startOver;
  final String answers;
  final int resultScore;
  final int total;
  final Function restartFunction;

  Result(this.resultScore, this.total, this.restartFunction, this.showResult,
      this.showScore, this.conclusion, this.startOver, this.answers);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  final _formKey = GlobalKey<FormState>();
  var _userEmail = '';
  var _userName = '';
  var _phone = '';
  var _submitted = false;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();

      final url = widget.startOver;

      if (url != null && url.contains('http')) {
        http.get('$url?data=$_userEmail;$_userName;$_phone;${widget.answers}').then((value) => print(value.body));
      }

      setState(() {
        _submitted = true;
      });
    }
  }

  String get resultText {
    if (widget.resultScore > widget.total) {
      return 'You got ${widget.total} of ${widget.total} correctly.';
    }
    return 'You got ${widget.resultScore} of ${widget.total} correctly.';
  }

  String get scoreText {
    if (widget.resultScore > widget.total || widget.total == 0) {
      return 'YOUR SCORE: 100%';
    }

    int percent = (widget.resultScore * 100 / widget.total).round();
    return 'YOUR SCORE: $percent%';
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: new BoxConstraints(
          maxWidth: 360.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                _submitted ? 'Thank you!' : widget.conclusion,
                style: TextStyle(
                  fontSize: 21,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    // showScore is name
                    if (!_submitted && widget.showScore)
                      TextFormField(
                        key: ValueKey('username'),
                        autocorrect: true,
                        textCapitalization: TextCapitalization.words,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter at least 1 character.';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Name',
                        ),
                        onSaved: (value) {
                          _userName = value;
                        },
                      ),
                    if (!_submitted)
                      TextFormField(
                        key: ValueKey('email'),
                        autocorrect: false,
                        textCapitalization: TextCapitalization.none,
                        enableSuggestions: false,
                        validator: (value) {
                          if (value.isEmpty || !value.contains('@')) {
                            return 'Please enter a valid email address.';
                          }

                          return null;
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email address',
                        ),
                        onSaved: (value) {
                          _userEmail = value;
                        },
                      ),

                    // showResult is name
                    if (!_submitted && widget.showResult)
                      TextFormField(
                        key: ValueKey('phone'),
                        validator: (value) {
                          if (value.isEmpty || value.length < 3) {
                            return 'Please enter at least 3 characters.';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          labelText: 'Phone',
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (value) {
                          _phone = value;
                        },
                        onFieldSubmitted: (value) {
                          _trySubmit();
                        },
                      ),
                    SizedBox(height: 12),
                    FlatButton(
                      child: Text(
                        _submitted ? 'Start Over' : 'Submit',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed:
                          _submitted ? widget.restartFunction : _trySubmit,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
