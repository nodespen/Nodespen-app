class Timeline {
  int fps;
  int currentFrame;
  int totalFrames;
  bool looping;
  int startFrame;
  int endFrame;
  bool onionSkinEnabled;
  int onionSkinPastFrames;
  int onionSkinFutureFrames;
  bool autoTweenEnabled;
  TweenMode tweenMode;

  Timeline({
    this.fps = 24,
    this.currentFrame = 0,
    this.totalFrames = 1,
    this.looping = true,
    this.startFrame = 0,
    this.endFrame = 0,
    this.onionSkinEnabled = false,
    this.onionSkinPastFrames = 2,
    this.onionSkinFutureFrames = 1,
    this.autoTweenEnabled = true,
    this.tweenMode = TweenMode.linear,
  });

  void advanceFrame() {
    currentFrame++;
    if (currentFrame > endFrame && looping) currentFrame = startFrame;
  }

  void goToFrame(int frame) {
    currentFrame = frame.clamp(startFrame, endFrame);
  }

  Map<String, dynamic> toJson() => {
    'fps': fps,
    'currentFrame': currentFrame,
    'totalFrames': totalFrames,
    'looping': looping,
    'startFrame': startFrame,
    'endFrame': endFrame,
    'onionSkinEnabled': onionSkinEnabled,
    'onionSkinPastFrames': onionSkinPastFrames,
    'onionSkinFutureFrames': onionSkinFutureFrames,
    'autoTweenEnabled': autoTweenEnabled,
    'tweenMode': tweenMode.name,
  };

  factory Timeline.fromJson(Map<String, dynamic> json) => Timeline(
    fps: json['fps'] as int,
    currentFrame: json['currentFrame'] as int,
    totalFrames: json['totalFrames'] as int,
    looping: json['looping'] as bool,
    startFrame: json['startFrame'] as int,
    endFrame: json['endFrame'] as int,
    onionSkinEnabled: json['onionSkinEnabled'] as bool,
    onionSkinPastFrames: json['onionSkinPastFrames'] as int,
    onionSkinFutureFrames: json['onionSkinFutureFrames'] as int,
    autoTweenEnabled: json['autoTweenEnabled'] as bool,
    tweenMode: TweenMode.values.byName(json['tweenMode'] as String),
  );
}

enum TweenMode { linear, easeIn, easeOut, easeInOut, custom }
