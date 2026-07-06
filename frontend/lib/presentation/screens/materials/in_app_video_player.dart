import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

/// Pemutar video 100% di dalam aplikasi — tanpa browser / app luar.
class InAppVideoPlayer extends StatefulWidget {
  final String filePath;

  const InAppVideoPlayer({super.key, required this.filePath});

  @override
  State<InAppVideoPlayer> createState() => _InAppVideoPlayerState();
}

class _InAppVideoPlayerState extends State<InAppVideoPlayer> {
  Player? _player;
  VideoController? _videoController;
  bool _ready = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _open();
  }

  @override
  void didUpdateWidget(InAppVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.filePath != widget.filePath) {
      _open();
    }
  }

  @override
  void dispose() {
    _videoController = null;
    _player?.dispose();
    _player = null;
    super.dispose();
  }

  Future<void> _open() async {
    // Check if it's a URL or local file
    final isUrl = widget.filePath.startsWith('http');
    
    if (!isUrl && !File(widget.filePath).existsSync()) {
      setState(() {
        _ready = false;
        _error = 'File video tidak ditemukan';
      });
      return;
    }

    setState(() {
      _ready = false;
      _error = null;
    });

    _videoController = null;
    await _player?.dispose();
    _player = null;

    try {
      final player = Player();
      final videoController = VideoController(player);

      await player.open(Media(widget.filePath));
      await player.setVolume(100);
      await player.play();

      if (!mounted) {
        player.dispose();
        return;
      }

      setState(() {
        _player = player;
        _videoController = videoController;
        _ready = true;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _ready = false;
        _error = 'Gagal memutar: $e';
      });
    }
  }

  String _format(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return ColoredBox(
        color: Colors.black,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, color: Colors.white54, size: 40),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.redAccent, fontSize: 12),
                ),
                const SizedBox(height: 8),
                FilledButton.icon(
                  onPressed: _open,
                  icon: const Icon(Icons.refresh, size: 18),
                  label: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (!_ready || _player == null || _videoController == null) {
      return const ColoredBox(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white),
              SizedBox(height: 12),
              Text(
                'Memuat video...',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    final player = _player!;

    return Stack(
      fit: StackFit.expand,
      children: [
        Video(
          controller: _videoController!,
          controls: null,
          fill: Colors.black,
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.85),
                  Colors.transparent,
                ],
              ),
            ),
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
                child: StreamBuilder<Duration>(
                  stream: player.stream.position,
                  builder: (context, posSnap) {
                    return StreamBuilder<Duration>(
                      stream: player.stream.duration,
                      builder: (context, durSnap) {
                        final position = posSnap.data ?? Duration.zero;
                        final duration = durSnap.data ?? Duration.zero;
                        final maxMs = duration.inMilliseconds > 0
                            ? duration.inMilliseconds.toDouble()
                            : 1.0;
                        final value = position.inMilliseconds
                            .clamp(0, duration.inMilliseconds > 0
                                ? duration.inMilliseconds
                                : 0)
                            .toDouble();

                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                trackHeight: 3,
                                thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6,
                                ),
                              ),
                              child: Slider(
                                value: value,
                                max: maxMs,
                                activeColor: Colors.white,
                                inactiveColor: Colors.white38,
                                onChanged: duration.inMilliseconds > 0
                                    ? (v) => player.seek(
                                          Duration(milliseconds: v.round()),
                                        )
                                    : null,
                              ),
                            ),
                            Row(
                              children: [
                                StreamBuilder<bool>(
                                  stream: player.stream.playing,
                                  builder: (context, playingSnap) {
                                    final playing = playingSnap.data ?? false;
                                    return IconButton(
                                      icon: Icon(
                                        playing
                                            ? Icons.pause_circle_filled
                                            : Icons.play_circle_filled,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                      onPressed: () {
                                        if (playing) {
                                          player.pause();
                                        } else {
                                          player.play();
                                        }
                                      },
                                    );
                                  },
                                ),
                                Text(
                                  '${_format(position)} / ${_format(duration)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                                const Spacer(),
                                const Text(
                                  'Dalam aplikasi',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
