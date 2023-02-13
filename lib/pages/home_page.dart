import 'dart:math';
import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:friviaa/pages/game_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  double? _currentDifficultyLevel = 0;

  final List<String> _difficultyTextList = ["Easy", "Medium", "Hard"];

  Widget _startGameButton() {
    return MaterialButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GamePage(
              difficultyLevel: _difficultyTextList[_currentDifficultyLevel!.toInt()].toLowerCase(),
            ),
          ),
        );
      },
      color: Colors.blue,
      minWidth: _deviceWidth! * 0.80,
      height: _deviceHeight! * 0.10,
      child: const Text(
        "Start",
        style: TextStyle(color: Colors.white, fontSize: 25),
      ),
    );
  }

  Widget _difficultySlider() {
    return Slider(
      label: "Difficulty",
      min: 0,
      max: 2,
      divisions: 2,
      value: _currentDifficultyLevel!,
      onChanged: (value) {
        setState(() {
          _currentDifficultyLevel = value;
          // debugPrint(_currentDifficultyLevel.toString(),);
          // dev.log(_currentDifficultyLevel.toString(),);
        });
      },
    );
  }

  Widget _appTitle() {
    return Center(
      child: Column(
        children: [
          const Text(
            "Friviaa",
            style: TextStyle(
              color: Colors.white,
              fontSize: 50,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            _difficultyTextList[_currentDifficultyLevel!.toInt()],
            style: const TextStyle(
                color: Colors.white, fontSize: 30, fontWeight: FontWeight.w200),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: _deviceWidth! * 0.10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              _appTitle(),
              _difficultySlider(),
              _startGameButton(),
            ],
          ),
        ),
      ),
    );
  }
}
