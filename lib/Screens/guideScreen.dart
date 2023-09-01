import 'package:flutter/material.dart';
import 'package:newui/Screens/chiewe.dart';
import 'package:video_player/video_player.dart';

class guideScreen extends StatefulWidget {
  const guideScreen({super.key});

  @override
  State<guideScreen> createState() => _guideScreenState();
}

// ignore: camel_case_types
class _guideScreenState extends State<guideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[300],
        title: const Text('GUIDE'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 30),
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 20),
                  child: Text(
                    'HAJJ TAKBEER',
                    style: TextStyle(color: Colors.teal[500], fontSize: 15),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 250,
              child: ChewieListItem(
                videoPlayerController: VideoPlayerController.asset(
                  'assets/hajjtakber.mp4',
                ),
                looping: true,
              ),
            ),
            SizedBox(
              height: 250,
              child: ChewieListItem(
                videoPlayerController: VideoPlayerController.asset(
                  'assets/images/hajjvideo.mp4',
                ),
                looping: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
