import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoFrameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: VideoFrameScreen(),
    );
  }
}

class VideoFrameScreen extends StatefulWidget {
  @override
  _VideoFrameScreenState createState() => _VideoFrameScreenState();
}

class _VideoFrameScreenState extends State<VideoFrameScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    // Use VideoPlayerController.asset for local assets
    _controller = VideoPlayerController.asset('assets/images/myzero.mp4')
      ..initialize().then((_) {
        setState(() {});
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
      backgroundColor: Colors.orangeAccent,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer frame container
            Container(
              width: 300,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: _controller.value.isInitialized
                  ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
            // Play button overlay
            Positioned(
              bottom: 15,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _controller.value.isPlaying
                        ? _controller.pause()
                        : _controller.play();
                  });
                },
                style: ElevatedButton.styleFrom(
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(10),
                  backgroundColor: Colors.white,
                ),
                child: Icon(
                  _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.orange,
                ),
              ),
            ),
            // Text overlay
            Positioned(
              top: 20,
              child: Text(
                "अब घर खरीदना\nहुआ आसान, कोई ब्रोकरेज नहीं!!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}