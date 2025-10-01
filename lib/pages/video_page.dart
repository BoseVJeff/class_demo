import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:class_demo/utils/utils_support_web.dart'
    if (dart.library.io) "package:class_demo/utils/utils_support_io.dart";

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return VideoPlayerWidget();
  }
}

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({super.key});

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late bool _isPlaying;
  late Duration _position;
  late Duration _total;

  @override
  void initState() {
    super.initState();
    if (isVideoPlayerSupported) {
      _controller = VideoPlayerController.asset("assets/bee.mp4");
      _controller.initialize().then((_) {
        setState(() {});
      });
      _position = _controller.value.position;
      _total = _controller.value.duration;
      _controller.addListener(updateState);
    }
  }

  @override
  void dispose() {
    if (isVideoPlayerSupported) {
      _controller.removeListener(updateState);
      _controller.dispose();
    }
    super.dispose();
  }

  void updateState() {
    setState(() {
      _isPlaying = _controller.value.isPlaying;
      _position = _controller.value.position;
      _total = _controller.value.duration;
    });
  }

  @override
  Widget build(BuildContext context) {
    VideoPlayerValue? value;
    if (isVideoPlayerSupported) {
      value = _controller.value;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Playback"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed("/video/code");
            },
            icon: Icon(Icons.code),
            tooltip: "View Code",
          ),
        ],
        bottom: isVideoPlayerSupported
            ? MyLinearProgressIndicator(
                value: _position.inMilliseconds / _total.inMilliseconds,
              )
            : null,
      ),
      body: Center(
        child: !isVideoPlayerSupported
            ? Text("Video Player is not supported on this platform")
            : ((value!.isInitialized)
                  ? AspectRatio(
                      aspectRatio: value.aspectRatio,
                      child: VideoPlayer(_controller),
                    )
                  : Container()),
      ),
      floatingActionButton: !isVideoPlayerSupported
          ? null
          : FloatingActionButton(
              onPressed: value!.isInitialized
                  ? () {
                      if (_isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    }
                  : null,
              child: Icon(
                _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              ),
            ),
    );
  }
}

class MyLinearProgressIndicator extends LinearProgressIndicator
    implements PreferredSizeWidget {
  MyLinearProgressIndicator({
    super.key,
    super.value,
    super.backgroundColor,
    super.valueColor,
    super.color,
  });

  @override
  final Size preferredSize = Size(double.infinity, 4);
}
