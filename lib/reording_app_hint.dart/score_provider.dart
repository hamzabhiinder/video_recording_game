// import 'package:flutter/material.dart';

// class Score {
//   final int score;
//   final String description;
//   final DateTime timestamp;
//   final String player;

//   Score({
//     required this.score,
//     required this.description,
//     required this.timestamp,
//     required this.player,
//   });
// }

// class ScoreProvider extends ChangeNotifier {
//   List<Score> _scores = [];
//   int _totalScore1 = 0;
//   int _totalScore2 = 0;

//   List<Score> get scores => _scores;

//   int get totalScore1 => _totalScore1;
//   int get totalScore2 => _totalScore2;

//   void addScore(int score, String description, String player) {
//     final newScore = Score(
//       score: score,
//       description: description,
//       timestamp: DateTime.now(),
//       player: player,
//     );
//     _scores.add(newScore);
//     if (player == 'Player 1') {
//       _totalScore1 += score;
//     } else if (player == 'Player 2') {
//       _totalScore2 += score;
//     }
//     notifyListeners();
//   }
// }


import 'package:flutter/material.dart';

class Score {
  final int matchScoreID;
  final int matchID;
  final String time;
  final int period;
  final int scoreID;
  final String scorer;
  final DateTime timestamp;

  Score({
    required this.matchScoreID,
    required this.matchID,
    required this.time,
    required this.period,
    required this.scoreID,
    required this.scorer,
    required this.timestamp,
  });
}

class ScoreProvider extends ChangeNotifier {
  List<Score> _scores = [];
  int _totalScore1 = 0;
  int _totalScore2 = 0;
  int _nextMatchScoreID = 1;
  int _currentMatchID = 1;

  List<Score> get scores => _scores;

  int get totalScore1 => _totalScore1;
  int get totalScore2 => _totalScore2;

  void addScore(int score, String description, String player, int period) {
    final newScore = Score(
      matchScoreID: _nextMatchScoreID,
      matchID: _currentMatchID,
      time: "${DateTime.now().minute}:${DateTime.now().second}",
      period: period,
      scoreID: score,
      scorer: player,
      timestamp: DateTime.now(),
    );
    _scores.add(newScore);
    if (player == 'Player 1') {
      _totalScore1 += score;
    } else if (player == 'Player 2') {
      _totalScore2 += score;
    }
    _nextMatchScoreID++;
    notifyListeners();
  }
}
