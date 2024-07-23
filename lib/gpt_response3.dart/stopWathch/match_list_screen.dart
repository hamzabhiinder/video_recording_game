import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:camera_recording_game/gpt_response3.dart/resonsive_helper.dart';
import 'package:path/path.dart' as path;
import 'package:camera_recording_game/gpt_response3.dart/video_player_page.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as vt;

class MatchListScreen extends StatefulWidget {
  const MatchListScreen({super.key});

  @override
  _MatchListScreenState createState() => _MatchListScreenState();
}

class _MatchListScreenState extends State<MatchListScreen> {
  late Future<List<Map<String, String>>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    _matchesFuture = getAllMatches();
  }

  Future<List<Map<String, String>>> getAllMatches() async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) {
      throw Exception('External storage directory not found');
    }

    final videoDir = Directory('${directory.path}/MatchVideos');
    if (!await videoDir.exists()) {
      return [];
    }

    final List<Map<String, String>> matches = [];
    final matchDirs = videoDir.listSync();

    for (var matchDir in matchDirs) {
      if (matchDir is Directory) {
        final videoPath = '${matchDir.path}/${path.basename(matchDir.path)}.mp4';
        final scoreFilePath = '${matchDir.path}/${path.basename(matchDir.path)}.json';
        log('scoreFilePath ${scoreFilePath}');
        if (File(videoPath).existsSync() && File(scoreFilePath).existsSync()) {
          final scoreFile = File(scoreFilePath);
          final scoreContent = jsonDecode(await scoreFile.readAsString());
          log('scoreContent ${scoreContent[0]}');
          final redPlayerName = scoreContent[0]['redPlayer'];
          final greenPlayerName = scoreContent[0]['greenPlayer'];
          final matchDate = scoreContent[0]['timestamp'];
          matches.add({
            'videoPath': videoPath,
            'scoreFilePath': scoreFilePath,
            'redPlayerName': redPlayerName ?? "",
            'greenPlayerName': greenPlayerName ?? "",
            'date': matchDate,
          });
        }
      }
    }
    matches.sort((a, b) => b['date']!.compareTo(a['date']!));
    return matches;
  }

  void deleteMatch(String videoPath, String scoreFilePath) async {
    try {
      final videoFile = File(videoPath);
      final scoreFile = File(scoreFilePath);

      if (await videoFile.exists()) {
        await videoFile.delete();
      }

      if (await scoreFile.exists()) {
        await scoreFile.delete();
      }

      setState(() {
        _matchesFuture = getAllMatches(); // Refresh the list
      });
    } catch (e) {
      log('Error deleting match: $e');
    }
  }

  Future<Duration> getVideoDuration(String videoPath) async {
    final controller = VideoPlayerController.file(File(videoPath));
    await controller.initialize();
    final duration = controller.value.duration;
    controller.dispose();
    return duration;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, String>>>(
      future: _matchesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No matches found'));
        } else {
          final matches = snapshot.data!;

          return Container(
            height: 200, // Adjust height as needed

            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                final date = DateTime.parse(match['date']!);
                final formattedDate = "${date.day}-${date.month}-${date.year}";
                return FutureBuilder<Duration>(
                    future: getVideoDuration(match['videoPath']!),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return const Center(child: Icon(Icons.error));
                      } else {
                        final duration = snapshot.data!;
                        final formattedDuration =
                            '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayerPage(
                                  filePath: match['videoPath']!,
                                  scoreFilePath: match['scoreFilePath']!,
                                ),
                              ),
                            );
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.all(10.0),
                                width: getResponsiveWidth(context, 220),
                                // height: getResponsiveHeight(context, 150),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: FutureBuilder(
                                  future: _getVideoThumbnail(match['videoPath']!),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      return const Center(child: Icon(Icons.error));
                                    } else {
                                      return ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.file(
                                          File(snapshot.data!),
                                          fit: BoxFit.cover,
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                              const Icon(
                                Icons.play_circle_outline,
                                color: Colors.white,
                                size: 50,
                              ),
                              Positioned(
                                top: 20,
                                left: 20,
                                child: Text(
                                  '${match['redPlayerName']} vs ${match['greenPlayerName']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                right: 20,
                                child: Text(
                                  '${formattedDate}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    // backgroundColor: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: Text(
                                  '${formattedDuration}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    // backgroundColor: Colors.grey.shade800,
                                  ),
                                ),
                              ),
                              // Positioned(
                              //   top: 10,
                              //   right: 10,
                              //   child: IconButton(
                              //     icon: const Icon(Icons.delete, color: Colors.red),
                              //     onPressed: () async {
                              //       final confirm = await showDialog(
                              //         context: context,
                              //         builder: (context) => AlertDialog(
                              //           title: const Text('Confirm Deletion'),
                              //           content: const Text(
                              //               'Are you sure you want to delete this video?'),
                              //           actions: [
                              //             TextButton(
                              //               onPressed: () => Navigator.of(context).pop(false),
                              //               child: const Text('Cancel'),
                              //             ),
                              //             TextButton(
                              //               onPressed: () => Navigator.of(context).pop(true),
                              //               child: const Text('Delete'),
                              //             ),
                              //           ],
                              //         ),
                              //       );
                              //       if (confirm == true) {
                              //         deleteMatch(match['videoPath']!, match['scoreFilePath']!);
                              //       }
                              //     },
                              //   ),
                              // ),
                            ],
                          ),
                        );
                      }
                    });
              },
            ),
          );
        }
      },
    );
  }

  Future<String> _getVideoThumbnail(String videoPath) async {
    // Generate a thumbnail for the video
    final thumbFile = await vt.VideoThumbnail.thumbnailFile(
      video: videoPath,
      thumbnailPath: (await getTemporaryDirectory()).path,
      imageFormat: vt.ImageFormat.JPEG,
    );
    return thumbFile!;
  }
}
