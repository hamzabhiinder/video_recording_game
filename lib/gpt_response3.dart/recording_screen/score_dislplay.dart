// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../score_provider.dart';

// class ScoreDisplayScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Score Display'),
//       ),
//       body: Row(
//         children: [
//           Expanded(
//             child: Column(
//               children: [
//                 Text(
//                   'Red Team',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.red,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Expanded(
//                   child: Consumer<ScoreProvider>(
//                     builder: (context, scoreProvider, child) {
//                       return ListView(
//                         children: scoreProvider.scores
//                             .where((score) => score.color == Colors.red)
//                             .map((score) => ListTile(
//                                   title: Text(score.description),
//                                   trailing: IconButton(
//                                     icon: Icon(Icons.delete),
//                                     onPressed: () {
//                                       log('score.matchScoreID  ${score.matchScoreID}');
//                                       scoreProvider.deleteScore(score.matchScoreID);
//                                     },
//                                   ),
//                                 ))
//                             .toList(),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Column(
//               children: [
//                 Text(
//                   'Green Team',
//                   style: TextStyle(
//                     fontSize: 20,
//                     color: Colors.green,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Expanded(
//                   child: Consumer<ScoreProvider>(
//                     builder: (context, scoreProvider, child) {
//                       return ListView(
//                         children: scoreProvider.scores
//                             .where((score) => score.color == Colors.green)
//                             .map((score) => ListTile(
//                                   title: Text(score.description),
//                                   trailing: IconButton(
//                                     icon: Icon(Icons.delete),
//                                     onPressed: () {
//                                       scoreProvider.deleteScore(score.matchScoreID);
//                                     },
//                                   ),
//                                 ))
//                             .toList(),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:camera_recording_game/gpt_response3.dart/resonsive_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../score_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScoreDisplayScreen extends StatelessWidget {
  // void _showDeleteConfirmationDialog(BuildContext context, Score score) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Delete Confirmation'),
  //         content: Text('Are you sure you want to delete this score?'),
  //         actions: <Widget>[
  //           TextButton(
  //             child: Text('Delete'),
  //             onPressed: () {
  //               context.read<ScoreProvider>().deleteScore(score.matchScoreID);
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //           TextButton(
  //             child: Text('Cancel'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showDeleteConfirmationDialog(BuildContext context, Score score) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Are you sure you want to delete the below score?'),
              SizedBox(height: 8.0),
              Text('Period: ${score.period}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('Name: ${score.scorer}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text(
                  'Color: ${score.color.value.toString() == "4283215696" ? "Green" : "Red"}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Text('ScoreLine: ${score.description}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                context.read<ScoreProvider>().deleteScore(score.matchScoreID);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return isPortrait
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  alignment: Alignment.center,
                  color: Colors.red.withOpacity(0.3),
                  width: 50,
                  child: Consumer<ScoreProvider>(
                    builder: (context, scoreProvider, child) {
                      return ListView(
                        shrinkWrap: true,
                        children: _buildPeriodScores(
                            context, scoreProvider, Colors.red),
                      );
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  color: Colors.green.withOpacity(0.3),
                  width: 50,
                  child: Consumer<ScoreProvider>(
                    builder: (context, scoreProvider, child) {
                      return ListView(
                        shrinkWrap: true,
                        children: _buildPeriodScores(
                            context, scoreProvider, Colors.green),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 130,
                ),
                SizedBox(
                  width: 50,
                  child: Consumer<ScoreProvider>(
                    builder: (context, scoreProvider, child) {
                      return ListView(
                        shrinkWrap: true,
                        children: _buildPeriodScores(
                            context, scoreProvider, Colors.red),
                      );
                    },
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 50,
                  child: Consumer<ScoreProvider>(
                    builder: (context, scoreProvider, child) {
                      return ListView(
                        shrinkWrap: true,
                        children: _buildPeriodScores(
                            context, scoreProvider, Colors.green),
                      );
                    },
                  ),
                ),
                SizedBox(
                  width: 120,
                ),
              ],
            ),
          );
  }

  List<Widget> _buildPeriodScores(
      BuildContext context, ScoreProvider scoreProvider, Color color) {
    // Group scores by period
    final periodMap = <int, List<Score>>{};
    for (var score in scoreProvider.scores.where((s) => s.color == color)) {
      periodMap.putIfAbsent(score.period, () => []).add(score);
    }

    // Create a list of widgets, one for each period and its scores
    final periodWidgets = <Widget>[];
    periodMap.forEach((period, scores) {
      periodWidgets.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              color: Colors.black,
              padding: EdgeInsets.all(8.0),
              child: Text(
                'P$period',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...scores
                .map(
                  (score) => GestureDetector(
                    onTap: () {
                      _showDeleteConfirmationDialog(context, score);
                      // scoreProvider.deleteScore(score.matchScoreID);
                    },
                    child: Container(
                      // color: color.withOpacity(0.7),
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        score.description,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )

                // ListTile(
                //       title: Text(
                //         score.description,
                //         style: TextStyle(color: Colors.blue),
                //       ),
                //       trailing: IconButton(
                //         icon: Icon(Icons.delete, color: Colors.blue),
                //         onPressed: () {
                //           scoreProvider.deleteScore(score.matchScoreID);
                //         },
                //       ),
                //     ))
                .toList(),
          ],
        ),
      );
    });

    return periodWidgets;
  }



 }
