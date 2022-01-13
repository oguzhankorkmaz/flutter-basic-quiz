import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:core';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:quiz_flutter/models/quiz.dart';

import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Quiz> quiz = [];
  int activeIndex = 0;
  List _items = [];
  List _answers = [];
  String _answer = "";
  String _question = "";
  String state = "free";

  int point = 0;
  Future<void> readJsonIl() async {
    final String response = await rootBundle.loadString('assets/quiz.json');
    final data = await json.decode(response);
    var list = data["items"] as List<dynamic>;
    setState(() {
      _items = data["items"];
      _question = _items[activeIndex]["question"];
      _answers = _items[activeIndex]["answers"];
    });
  }

  void initState() {
    readJsonIl();
    quiz = _items.map((e) => Quiz.fromJson(e)).toList();
  }

  void _nextquestion() {
    setState(() {
      activeIndex++;
      _question = _items[activeIndex]["question"];
      _answers = _items[activeIndex]["answers"];

      if (_answer == _items[activeIndex - 1]["correct_answer"]) {
        point += 20;
      }
      val = 0;
    });
  }

  void _endQuiz() {
    setState(() {
      if (_answer == _items[activeIndex - 1]["correct_answer"]) {
        point += 20;
      }
      state = "end";
      activeIndex = 0;
    });
  }

  void _startQuiz() {
    setState(() {
      state = "start";
    });
  }

  int val = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            state == "start"
                ? (Text(
                    '$_question',
                  ))
                : state == "end"
                    ? (Text('Puanınız: $point'))
                    : (TextButton(
                        onPressed: _startQuiz, child: Text("Sınavı Başlat"))),
            if (state == "start")
              for (int i = 0; i < _answers.length; i++)
                ListTile(
                  title: Text(
                    _answers[i].toString(),
                  ),
                  leading: Radio(
                    value: i,
                    groupValue: val,
                    onChanged: (value) {
                      setState(() {
                        val = i;

                        _answer = _answers[val].toString();
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ),
            if (state == "start")
              if (activeIndex == _items.length - 1)
                TextButton(onPressed: _endQuiz, child: Text("Sınavı Bitir"))
              else
                TextButton(onPressed: _nextquestion, child: Text("Cevapla"))
          ],
        ),
      ),
    );
  }
}
