import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPage extends StatelessWidget {
  const AudioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Audio Playback"),
        actions: [
          IconButton(
            onPressed: () async {
              await Navigator.of(context).pushNamed("/audio/code");
            },
            icon: Icon(Icons.code),
            tooltip: "View Code",
          ),
        ],
      ),
      body: AudioPlayerWidget(),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  const AudioPlayerWidget({super.key});

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayerWidget> {
  late AudioPlayer _player;
  late StreamSubscription<PlayerState> _stateStream;
  late PlayerState _state;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.setSourceAsset("rooster.mp3");
    _player.setReleaseMode(ReleaseMode.stop);
    _player.setPlayerMode(PlayerMode.lowLatency);
    _state = _player.state;
    _stateStream = _player.onPlayerStateChanged.listen((PlayerState newState) {
      setState(() {
        _state = newState;
      });
    });
  }

  @override
  void dispose() {
    _stateStream.cancel();
    _player.stop();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: IconButton.filled(
        onPressed: () {
          if (_state == PlayerState.playing) {
            _player.pause();
          } else {
            _player.resume();
          }
          // setState(() {});
        },
        icon: Icon(
          (_state == PlayerState.playing)
              ? Icons.pause_rounded
              : Icons.play_arrow_rounded,
        ),
      ),
    );
  }
}
