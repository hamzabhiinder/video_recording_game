import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'score_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class VideoPlayerPage extends StatefulWidget {
  final String filePath;

  const VideoPlayerPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    print('Initializing video player with file: ${widget.filePath}');
    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      }).catchError((error) {
        log('Error initializing video player: $error');
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Playback'),
      ),
      body: Stack(
        children: [
          Center(
            child: _controller.value.isInitialized
                ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                : CircularProgressIndicator(),
          ),
          Consumer<ScoreProvider>(
            builder: (context, scoreProvider, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: scoreProvider.scores.map((score) {
                        return Text(
                          '${score.scorer}  at ${score.timestamp} - ${score.scorer}',
                          style: TextStyle(
                            color: score.scorer == 'Player 1' ? Colors.red : Colors.green,
                            fontSize: 16,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Padding(
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
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
