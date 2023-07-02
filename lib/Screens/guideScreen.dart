import 'package:flutter/material.dart';
import 'package:newui/Screens/chiewe.dart';
import 'package:video_player/video_player.dart';

class guideScreen extends StatefulWidget {
  const guideScreen({super.key});

  @override
  State<guideScreen> createState() => _guideScreenState();
}

class _guideScreenState extends State<guideScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal[300],
        title: Text('GUIDE'),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 30),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      'HAJJ TAKBEER',
                      style: TextStyle(color: Colors.teal[500], fontSize: 15),
                    ),
                  ),
                ],
              ),
              Container(
                height: 250,
                child: ChewieListItem(
                  videoPlayerController: VideoPlayerController.asset(
                    'assets/hajjtakber.mp4',
                  ),
                  looping: true,
                ),
              ),
              Container(
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
      ),
    );
  }
}
