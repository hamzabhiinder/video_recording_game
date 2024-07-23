import 'dart:developer';

import 'package:camera_recording_game/gpt_response3.dart/stopWathch/stopwatch_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'score_provider.dart';
import 'video_player_page.dart';

class ResultScreen extends StatelessWidget {
  final String videoPath;

  const ResultScreen({Key? key, required this.videoPath}) : super(key: key);
  void _showEndMatchDialog(BuildContext context) {
    String? selectedDecision;
    String reason = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('End Match'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<String>(
                    hint: Text('Select Decision'),
                    value: selectedDecision,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDecision = newValue;
                      });
                    },
                    items: <String>[
                      'Regular Decision',
                      'Major Decision',
                      'Pin',
                      'Technical Fall',
                      'Disqualification'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  // TextField(
                  //   decoration: InputDecoration(labelText: 'Time'),
                  //   onChanged: (value) {
                  //     time = value;
                  //   },
                  // ),
                  TextField(
                    decoration: InputDecoration(labelText: 'Reason'),
                    onChanged: (value) {
                      reason = value;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Save'),
                  onPressed: () {
                    log('selectedDecision${selectedDecision}');
                    if (selectedDecision != null) {
                      Provider.of<ScoreProvider>(context, listen: false).endMatch(
                        selectedDecision!,
                        context
                            .read<StopwatchProvider>()
                            .formatDuration(context.read<StopwatchProvider>().elapsedTime),
                        reason,
                      );
                      Navigator.of(context).pop();
                    } else {
                      // Show error message or handle invalid input
                    }
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Result'),
      ),
      body: Consumer<ScoreProvider>(
        builder: (context, scoreProvider, child) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Player 1 Total Score: ${scoreProvider.totalScore1}',
                style: TextStyle(color: Colors.red, fontSize: 24),
              ),
              Text(
                'Player 2 Total Score: ${scoreProvider.totalScore2}',
                style: TextStyle(color: Colors.green, fontSize: 24),
              ),
              SizedBox(height: 20),
              DataTable(
                columns: [
                  DataColumn(label: Text('MatchScoreID')),
                  DataColumn(label: Text('MatchID')),
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('Period')),
                  DataColumn(label: Text('ScoreID')),
                  DataColumn(label: Text('Scorer')),
                ],
                rows: scoreProvider.scores.map((score) {
                  return DataRow(cells: [
                    DataCell(Text(score.matchScoreID.toString())),
                    DataCell(Text(score.matchID.toString())),
                    DataCell(Text(score.time)),
                    DataCell(Text(score.period.toString())),
                    DataCell(Text(score.scoreID.toString())),
                    DataCell(Text(score.scorer)),
                  ]);
                }).toList(),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (context) => VideoPlayerPage(filePath: videoPath),
                  //   ),
                  // );
                  scoreProvider.getResultData();
                },
                child: Text('Play Video'),
              ),
            ],
          );
        },
      ),
    );
  }
}
