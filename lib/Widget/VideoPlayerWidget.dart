import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const VideoPlayerWidget({
    super.key,
    required this.videoPlayerController,
  });

  @override
  // ignore: library_private_types_in_public_api
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _initializeVideoPlayerFuture = widget.videoPlayerController.initialize();
  }

  @override
  void dispose() {
    widget.videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return AspectRatio(
            aspectRatio: widget.videoPlayerController.value.aspectRatio,
            child: VideoPlayer(widget.videoPlayerController),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
