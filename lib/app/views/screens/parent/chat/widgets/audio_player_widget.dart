import 'dart:io';
import 'package:flutter/material.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:dot_connections/app/core/utils/app_colors.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioAsset;
  final bool isMe;

  const AudioPlayerWidget({
    super.key,
    required this.audioAsset,
    required this.isMe,
  });

  @override
  AudioPlayerWidgetState createState() => AudioPlayerWidgetState();
}

class AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late final PlayerController _controller;
  bool _isPlayerReady = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _controller = PlayerController();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      final path = await _getAssetPath();
      await _controller.preparePlayer(
        path: path,
        shouldExtractWaveform: true,
        noOfSamples: 100,
        volume: 1.0,
      );
      if (mounted) {
        setState(() {
          _isPlayerReady = true;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to load audio: $e';
        });
      }
    }

    _controller.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {});
      }
    });

    // Add this listener to handle audio completion
    _controller.onCompletion.listen((_) {
      if (mounted) {
        _controller.seekTo(0);
        // After seeking to the beginning, you might want to ensure the state is `paused`.
        // The onPlayerStateChanged listener should handle the UI update.
        // If the icon doesn't update correctly, you can explicitly call setState.
        setState(() {});
      }
    });
  }

  Future<String> _getAssetPath() async {
    final directory = await getTemporaryDirectory();
    final fileName =
        'audio_${widget.audioAsset.hashCode}_${DateTime.now().millisecondsSinceEpoch}.mp3';
    final path = '${directory.path}/$fileName';

    try {
      final file = File(path);
      if (!await file.exists()) {
        final assetData = await DefaultAssetBundle.of(
          context,
        ).load(widget.audioAsset);
        final bytes = assetData.buffer.asUint8List();
        await file.writeAsBytes(bytes);
      }
      return path;
    } catch (e) {
      throw Exception('Failed to copy audio asset: $e');
    }
  }

  Future<void> _handlePlayPause() async {
    if (!_isPlayerReady) return;

    try {
      if (_controller.playerState.isPlaying) {
        await _controller.pausePlayer();
      } else {
        await _controller.seekTo(0);
        await _controller.startPlayer();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'Playback error: $e';
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Text(
        _errorMessage!,
        style: const TextStyle(color: Colors.red, fontSize: 12),
      );
    }

    if (!_isPlayerReady) {
      return const SizedBox(
        height: 50,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            _controller.playerState.isPlaying
                ? Icons.pause_circle
                : Icons.play_circle,
            color: widget.isMe ? Colors.white : AppColors.primaryColor,
            size: 30,
          ),
          onPressed: _handlePlayPause,
        ),
        Expanded(
          child: AudioFileWaveforms(
            size: Size(MediaQuery.of(context).size.width * 0.5, 50),
            playerController: _controller,
            waveformType: WaveformType.long,
            playerWaveStyle: PlayerWaveStyle(
              fixedWaveColor: widget.isMe
                  ? Colors.white.withOpacity(0.5)
                  : AppColors.primaryColor.withOpacity(0.5),
              liveWaveColor: widget.isMe ? Colors.white : AppColors.primaryColor,
              spacing: 6,
              showSeekLine: false,
              waveCap: StrokeCap.round,
            ),
          ),
        ),
      ],
    );
  }
}
