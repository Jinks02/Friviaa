import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/adapter.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class GamePageProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  final int _maxQuestions = 10;
  String difficultyLevel;
  BuildContext context;
  List? questions;
  int _currentQuestionCount = 0;
  int? _correctAnswerCount =0;


  GamePageProvider({required this.context,required this.difficultyLevel}) {
    _dio.options.baseUrl = 'https://opentdb.com/api.php';
    log("inside game page prov constructor");
    _getQuestionsFromApi();
  }

  Future<void> _getQuestionsFromApi() async {
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (HttpClient dioClient) {
      dioClient.badCertificateCallback =
          ((X509Certificate cert, String host, int port) => true);
      return dioClient;
    };
    var _response = await _dio.get(
      '',
      queryParameters: {
        'amount': _maxQuestions,
        'type': 'boolean',
        'difficulty': difficultyLevel,
      },
    );
    var _data = jsonDecode(
      _response.toString(),
    );

    questions = _data['results'];
    notifyListeners();

    // log(difficultyLevel);
    // log(
    //   _data.toString(),
    // );
  }

  String getCurrentQuestionText() {
    return questions![_currentQuestionCount]['question'];
  }

  void checkAnswer(String _answer) async {
    bool isCorrectAnswer =
        questions![_currentQuestionCount]['correct_answer'] == _answer;
    _correctAnswerCount = isCorrectAnswer? _correctAnswerCount! +1 : _correctAnswerCount! +0;
    _currentQuestionCount++;
    // log(isCorrectAnswer ? "Correct" : "InCorrect");

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: isCorrectAnswer ? Colors.green : Colors.red,
          title: Icon(
            isCorrectAnswer ? Icons.check_circle : Icons.cancel_sharp,
            color: Colors.white,
          ),
        );
      },
    );
    await Future.delayed(
      const Duration(seconds: 1),
    );
    Navigator.pop(context);

    if(_currentQuestionCount == _maxQuestions){
      endGame();
    }
    else{
      notifyListeners();
    }

  }

  Future<void> endGame() async {
    showDialog(
      context: context,
      builder: (context) {
        return  AlertDialog(
          backgroundColor: Colors.blue,
          title: const Text(
            "The Trivia has ended!",
            style: TextStyle(
              fontSize: 25,
              color: Colors.white,
            ),
          ),
          content: Text("Score: $_correctAnswerCount/$_maxQuestions "),
        );
      },
    );

    await Future.delayed(
      const Duration(seconds: 3),
    );
    Navigator.pop(context);
    Navigator.pop(context);
  }
}
