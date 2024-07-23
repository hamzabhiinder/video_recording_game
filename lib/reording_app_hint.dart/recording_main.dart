import 'dart:developer';

import '/reording_app_hint.dart/result.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';

import 'package:provider/provider.dart';

import 'score_provider.dart';
import 'video_player_page.dart';

class RecordScreenMainApp extends StatefulWidget {
  final CameraDescription camera;

  const RecordScreenMainApp({Key? key, required this.camera}) : super(key: key);

  @override
  _RecordScreenMainAppState createState() => _RecordScreenMainAppState();
}

class _RecordScreenMainAppState extends State<RecordScreenMainApp> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool isRecording = false;
  String videoPath = '';
  int currentPeriod = 1;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> startRecording() async {
    try {
      await _initializeControllerFuture;
      final directory = await getApplicationDocumentsDirectory();
      final filePath = join(directory.path, '${DateTime.now()}.mp4');

      await _controller.startVideoRecording();
      setState(() {
        isRecording = true;
        videoPath = filePath;
      });
    } catch (e) {
      log('startRecording $e');
    }
  }

  Future<void> stopRecording(context) async {
    try {
      final videoFile = await _controller.stopVideoRecording();
      final videoFilePath = videoFile.path;

      log('Video saved to: $videoFilePath');

      setState(() {
        isRecording = false;
      });

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoPlayerPage(filePath: videoFilePath),
        ),
      );
    } catch (e) {
      log('Error stopping recording: $e');
    }
  }

  void changePeriod(context) {
    if (currentPeriod < 3) {
      setState(() {
        currentPeriod++;
      });
    } else {
      stopRecording(context);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ResultScreen(videoPath: videoPath),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record and Score - Period $currentPeriod'),
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                CameraPreview(_controller),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: FloatingActionButton(
                    onPressed: () {
                      isRecording ? stopRecording(context) : startRecording();
                    },
                    child: Icon(isRecording ? Icons.stop : Icons.videocam),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: FloatingActionButton(
                    onPressed: () {
                      changePeriod(context);
                    },
                    child: Icon(Icons.pause),
                  ),
                ),
                ScoreOverlay(currentPeriod: currentPeriod),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}

class ScoreOverlay extends StatelessWidget {
  final int currentPeriod;

  const ScoreOverlay({Key? key, required this.currentPeriod}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ScoreColumn(
                color: Colors.red,
                player: 'Player 1',
                scoreProvider: Provider.of<ScoreProvider>(context, listen: false),
                currentPeriod: currentPeriod,
              ),
              ScoreColumn(
                color: Colors.green,
                player: 'Player 2',
                scoreProvider: Provider.of<ScoreProvider>(context, listen: false),
                currentPeriod: currentPeriod,
              ),
            ],
          ),
        ),
        Consumer<ScoreProvider>(
          builder: (context, scoreProvider, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Player 1 Score: ${scoreProvider.totalScore1}',
                    style: TextStyle(color: Colors.red, fontSize: 20),
                  ),
                  Text(
                    'Player 2 Score: ${scoreProvider.totalScore2}',
                    style: TextStyle(color: Colors.green, fontSize: 20),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class ScoreColumn extends StatelessWidget {
  final Color color;
  final String player;
  final ScoreProvider scoreProvider;
  final int currentPeriod;

  const ScoreColumn({
    Key? key,
    required this.color,
    required this.player,
    required this.scoreProvider,
    required this.currentPeriod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          player,
          style: TextStyle(color: color, fontSize: 20),
        ),
        ScoreButton(
            score: 3,
            description: 'T3',
            color: color,
            scoreProvider: scoreProvider,
            player: player,
            currentPeriod: currentPeriod),
        ScoreButton(
            score: 1,
            description: 'E1',
            color: color,
            scoreProvider: scoreProvider,
            player: player,
            currentPeriod: currentPeriod),
        ScoreButton(
            score: 2,
            description: 'R2',
            color: color,
            scoreProvider: scoreProvider,
            player: player,
            currentPeriod: currentPeriod),
        ScoreButton(
            score: 2,
            description: 'N2',
            color: color,
            scoreProvider: scoreProvider,
            player: player,
            currentPeriod: currentPeriod),
        ScoreButton(
            score: 3,
            description: 'N3',
            color: color,
            scoreProvider: scoreProvider,
            player: player,
            currentPeriod: currentPeriod),
        ScoreButton(
            score: 4,
            description: 'N4',
            color: color,
            scoreProvider: scoreProvider,
            player: player,
            currentPeriod: currentPeriod),
        ScoreButton(
            score: 5,
            description: 'N5',
            color: color,
            scoreProvider: scoreProvider,
            player: player,
            currentPeriod: currentPeriod),
        ScoreButton(
            score: 6,
            description: 'N6',
            color: color,
            scoreProvider: scoreProvider,
            player: player,
            currentPeriod: currentPeriod),
        ScoreButton(
            score: 7,
            description: 'N7',
            color: color,
            scoreProvider: scoreProvider,
            player: player,
            currentPeriod: currentPeriod),
      ],
    );
  }
}

class ScoreButton extends StatelessWidget {
  final int score;
  final String description;
  final Color color;
  final ScoreProvider scoreProvider;
  final String player;
  final int currentPeriod;

  const ScoreButton({
    Key? key,
    required this.score,
    required this.description,
    required this.color,
    required this.scoreProvider,
    required this.player,
    required this.currentPeriod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ElevatedButton(
        onPressed: () {
          scoreProvider.addScore(score, description, player, currentPeriod);
        },
        child: Text('$description ($score)'),
        style: ElevatedButton.styleFrom(backgroundColor: color),
      ),
    );
  }
}
