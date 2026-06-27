import 'dart:async';
import '../document/document.dart';
import '../document/frame.dart';
import 'tween_engine.dart';

enum PlaybackState { stopped, playing, paused }

class PlaybackController {
  final NodespenDocument document;
  final TweenEngine tweenEngine;

  PlaybackState _state = PlaybackState.stopped;
  Timer? _timer;
  int _elapsedMs = 0;
  void Function()? onFrameChanged;

  PlaybackController(this.document)
    : tweenEngine = TweenEngine(document.timeline);

  PlaybackState get state => _state;
  int get elapsedMs => _elapsedMs;

  void play() {
    if (_state == PlaybackState.playing) return;
    _state = PlaybackState.playing;
    _elapsedMs = 0;
    _scheduleNextFrame();
  }

  void pause() {
    _state = PlaybackState.paused;
    _timer?.cancel();
  }

  void stop() {
    _state = PlaybackState.stopped;
    _timer?.cancel();
    _elapsedMs = 0;
    document.timeline.goToFrame(0);
  }

  void _scheduleNextFrame() {
    final interval = Duration(milliseconds: (1000 / document.timeline.fps).round());
    _timer = Timer(interval, () {
      if (_state != PlaybackState.playing) return;
      document.timeline.advanceFrame();
      _elapsedMs += interval.inMilliseconds;
      onFrameChanged?.call();
      _scheduleNextFrame();
    });
  }

  void togglePlayPause() {
    switch (_state) {
      case PlaybackState.stopped:
      case PlaybackState.paused:
        play();
      case PlaybackState.playing:
        pause();
    }
  }

  void dispose() {
    _timer?.cancel();
  }

  Frame? getActiveFrame() {
    final scene = document.activeScene;
    if (scene.layers.isEmpty) return null;
    final layer = scene.activeLayer;
    final timeline = document.timeline;

    final target = layer.frames.where((f) => f.index == timeline.currentFrame).firstOrNull;
    if (target != null) return target;

    final prevKeyframes = layer.frames
      .where((f) => f.isKeyframe && f.index <= timeline.currentFrame)
      .toList()
      ..sort((a, b) => b.index.compareTo(a.index));
    return prevKeyframes.isNotEmpty ? prevKeyframes.first : null;
  }
}
