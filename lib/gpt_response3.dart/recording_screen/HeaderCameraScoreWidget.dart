import 'package:camera_recording_game/gpt_response3.dart/resonsive_helper.dart';
import 'package:camera_recording_game/gpt_response3.dart/score_provider.dart';
import 'package:camera_recording_game/gpt_response3.dart/screen_ui.dart';
import 'package:camera_recording_game/gpt_response3.dart/stopWathch/stopwatch_provider.dart';
import 'package:camera_recording_game/gpt_response3.dart/video_player_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';

import '../../reording_app_hint.dart/result.dart';

class HeaderCameraScoreWidget extends StatelessWidget {
  final bool isOpaque;
  final Function onScoreTap;
  final VoidCallback onHeaderTap;

  const HeaderCameraScoreWidget({
    super.key,
    required this.isOpaque,
    required this.onScoreTap,
    required this.onHeaderTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return isPortrait
        ? Positioned(
            top: 50,
            left: 0,
            right: 0,
            height: 110, // Total height for three containers
            child: Opacity(
              opacity: isOpaque ? 1.0 : 0.5,
              child: GestureDetector(
                onTap: onHeaderTap,
                child: Row(
                  children: [
                    // First Container: Red Team Score and Name
                    Expanded(
                      child: Container(
                        color: Colors.red,
                        child: Center(
                          child: Consumer<ScoreProvider>(
                            builder: (context, scoreProvider, child) {
                              String redName =
                                  scoreProvider.matchDetails['RedOpp'];
                              redName = redName.length > 4
                                  ? redName.substring(0, 4)
                                  : redName;
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        height: getResponsiveWidth(context, 25),
                                        width: getResponsiveWidth(context, 25),
                                        color: Colors.black,
                                        child: Center(
                                          child: PositionLabel(
                                            backgroundColor: Colors.black,
                                            onPositionChange: (newPosition) {
                                              // Handle position change
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${scoreProvider.totalScore1}',
                                      style: TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            String newName = scoreProvider
                                                .matchDetails['RedOpp'];
                                            return AlertDialog(
                                              title:
                                                  Text('Update Opponent Name'),
                                              content: TextField(
                                                decoration: InputDecoration(
                                                    hintText: newName),
                                                onChanged: (value) {
                                                  newName = value;
                                                  scoreProvider
                                                      .updateMatchDetail(
                                                          'RedOpp', value);
                                                },
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Save'),
                                                  onPressed: () {
                                                    // scoreProvider.matchDetails
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        '${redName}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // Second Container: Time and Period
                    Expanded(
                      child: Container(
                        height: getResponsiveHeight(context, 125),
                        color: Colors.grey.shade800,
                        child: Center(
                          child: Consumer<StopwatchProvider>(
                            builder: (context, stopwatchProvider, child) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Consumer<ScoreProvider>(
                                      builder: (context, scoreProvider, child) {
                                    return DropdownButtonHideUnderline(
                                      // Hide the underline
                                      child: DropdownButton<int>(
                                        value: scoreProvider.currentPeriod,
                                        dropdownColor: Colors.grey.shade400
                                            .withOpacity(
                                                0.6), // 60% transparency
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: getResponsiveFontSize(
                                                context, 20)),
                                        onChanged: (int? newValue) {
                                          if (newValue != null) {
                                            scoreProvider
                                                .setCurrentPeriod(newValue);
                                          }
                                        },
                                        iconSize: 2,
                                        items: List.generate(
                                                8, (index) => index + 1)
                                            .map<DropdownMenuItem<int>>(
                                                (int value) {
                                          return DropdownMenuItem<int>(
                                            value: value,
                                            child: Center(
                                              child: Text(
                                                'Period $value',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        getResponsiveFontSize(
                                                            context, 24)),
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  }),
                                  // Text(
                                  //   'Period: ${context.read<ScoreProvider>().currentPeriod}',
                                  //   style: TextStyle(
                                  //     fontSize: 19,
                                  //     color: Colors.white,
                                  //     fontWeight: FontWeight.bold,
                                  //   ),
                                  // ),
                                  Text(
                                    '${stopwatchProvider.formatDuration(stopwatchProvider.elapsedTime)}',
                                    style: TextStyle(
                                      fontSize: getResponsiveFontSize(
                                          context, 36), // Increased font size
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // Third Container: Green Team Score and Name
                    Expanded(
                      child: Container(
                        color: Colors.green,
                        child: Center(
                          child: Consumer<ScoreProvider>(
                            builder: (context, scoreProvider, child) {
                              String greenName =
                                  scoreProvider.matchDetails['GreenOpp'];
                              greenName = greenName.length > 4
                                  ? greenName.substring(0, 4)
                                  : greenName;
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: Alignment.topLeft,
                                      child: Container(
                                        height: getResponsiveWidth(context, 25),
                                        width: getResponsiveWidth(context, 25),
                                        color: Colors.black,
                                        child: Center(
                                          child: PositionLabel(
                                            backgroundColor: Colors.black,
                                            onPositionChange: (newPosition) {
                                              // Handle position change
                                            },
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${scoreProvider.totalScore2}',
                                      style: TextStyle(
                                        fontSize: 32,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            String newName = scoreProvider
                                                .matchDetails['GreenOpp'];
                                            return AlertDialog(
                                              title:
                                                  Text('Update Opponent Name'),
                                              content: TextField(
                                                decoration: InputDecoration(
                                                    hintText: newName),
                                                onChanged: (value) {
                                                  newName = value;
                                                  scoreProvider
                                                      .updateMatchDetail(
                                                          'GreenOpp', value);
                                                },
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Save'),
                                                  onPressed: () {
                                                    // scoreProvider.matchDetails
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        '${greenName}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Positioned(
            top: 5,
            left: 0,
            right: 0,
            height: 150, // Total height for three containers
            child: Opacity(
              opacity: isOpaque ? 1.0 : 0.5,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // First Container: Red Team Score and Name
                  Container(
                    height: 110,
                    width: 125,
                    color: Colors.red,
                    child: Center(
                      child: Consumer<ScoreProvider>(
                        builder: (context, scoreProvider, child) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        '${scoreProvider.totalScore1}',
                                        style: TextStyle(
                                          fontSize: 28,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            String newName = scoreProvider
                                                .matchDetails['RedOpp'];
                                            return AlertDialog(
                                              title:
                                                  Text('Update Opponent Name'),
                                              content: TextField(
                                                decoration: InputDecoration(
                                                    hintText: newName),
                                                onChanged: (value) {
                                                  newName = value;
                                                  scoreProvider
                                                      .updateMatchDetail(
                                                          'RedOpp', value);
                                                },
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Save'),
                                                  onPressed: () {
                                                    // scoreProvider.matchDetails
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        '${scoreProvider.matchDetails['RedOpp']}',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 30,
                                  width: 30,
                                  color: Colors.black,
                                  child: Center(
                                    child: PositionLabel(
                                      backgroundColor: Colors.black,
                                      onPositionChange: (newPosition) {
                                        // Handle position change
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 50),
                  // Second Container: Time and Period
                  Expanded(
                    child: Container(
                      height: 100,
                      color: Colors.black12,
                      child: Center(
                        child: Consumer<StopwatchProvider>(
                          builder: (context, stopwatchProvider, child) {
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Consumer<ScoreProvider>(
                                    builder: (context, scoreProvider, child) {
                                  return DropdownButtonHideUnderline(
                                    // Hide the underline
                                    child: DropdownButton<int>(
                                      value: scoreProvider.currentPeriod,
                                      dropdownColor: Colors.grey.shade400
                                          .withOpacity(0.6), // 60% transparency
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: getResponsiveFontSize(
                                              context, 20)),
                                      onChanged: (int? newValue) {
                                        if (newValue != null) {
                                          scoreProvider
                                              .setCurrentPeriod(newValue);
                                        }
                                      },
                                      iconSize: 2,
                                      items:
                                          List.generate(8, (index) => index + 1)
                                              .map<DropdownMenuItem<int>>(
                                                  (int value) {
                                        return DropdownMenuItem<int>(
                                          value: value,
                                          child: Center(
                                            child: Text(
                                              'Period $value',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      getResponsiveFontSize(
                                                          context, 16)),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }),
                                // Text(
                                //   'Period: ${context.read<ScoreProvider>().currentPeriod}',
                                //   style: TextStyle(
                                //     fontSize: 19,
                                //     color: Colors.white,
                                //     fontWeight: FontWeight.bold,
                                //   ),
                                // ),
                                Text(
                                  '${stopwatchProvider.formatDuration(stopwatchProvider.elapsedTime)}',
                                  style: TextStyle(
                                    fontSize: 21,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 50),

                  // Third Container: Green Team Score and Name
                  Container(
                    height: 110,
                    width: 125,
                    color: Colors.green,
                    child: Center(
                      child: Consumer<ScoreProvider>(
                        builder: (context, scoreProvider, child) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 30,
                                  width: 30,
                                  color: Colors.black,
                                  child: Center(
                                    child: PositionLabel(
                                      backgroundColor: Colors.black,
                                      onPositionChange: (newPosition) {
                                        // Handle position change
                                      },
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    SizedBox(height: 25),
                                    FittedBox(
                                      child: Text(
                                        '${scoreProvider.totalScore2}',
                                        style: TextStyle(
                                          fontSize: 32,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            String newName = scoreProvider
                                                .matchDetails['GreenOpp'];
                                            return AlertDialog(
                                              title:
                                                  Text('Update Opponent Name'),
                                              content: TextField(
                                                decoration: InputDecoration(
                                                    hintText: newName),
                                                onChanged: (value) {
                                                  newName = value;
                                                  scoreProvider
                                                      .updateMatchDetail(
                                                          'GreenOpp', value);
                                                },
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  child: Text('Save'),
                                                  onPressed: () {
                                                    // scoreProvider.matchDetails
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        '${scoreProvider.matchDetails['GreenOpp']}',
                                        style: TextStyle(
                                          fontSize: 24,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}

class PositionLabel extends StatefulWidget {
  final Color backgroundColor;
  final Function(String) onPositionChange;

  PositionLabel(
      {required this.backgroundColor, required this.onPositionChange});

  @override
  _PositionLabelState createState() => _PositionLabelState();
}

class _PositionLabelState extends State<PositionLabel> {
  String position = 'N'; // Initial position

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showPositionDialog(context),
      child: Container(
        height: 25,
        width: 20,
        color: widget.backgroundColor.withOpacity(0.4), // 60% transparency
        alignment: Alignment.center,
        child: Text(
          position,
          style: TextStyle(
              color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _showPositionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Position'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPositionButton(context, '↑'),
              _buildPositionButton(context, '↓'),
              _buildPositionButton(context, 'A'),
              _buildPositionButton(context, 'N'),
              _buildPositionButton(context, 'D'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPositionButton(BuildContext context, String newPosition) {
    return TextButton(
      onPressed: () {
        setState(() {
          position = newPosition;
        });
        widget.onPositionChange(newPosition);
        Navigator.of(context).pop();
      },
      child: Text(
        newPosition,
        style: TextStyle(
            fontSize: getResponsiveFontSize(context, 14),
            fontWeight: FontWeight.bold),
      ),
    );
  }
}

class BoxingTimerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // Make the widget as wide as possible
      height: 100, // Adjust height as needed
      decoration: BoxDecoration(
        color: Colors.black, // Background color
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '17',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Muha',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Period 3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                Text(
                  '00:00',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '5',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'GRAY',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
