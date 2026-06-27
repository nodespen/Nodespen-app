import 'dart:math' as math;
import '../document/frame.dart';
import '../document/timeline.dart';

class TweenEngine {
  final Timeline timeline;

  TweenEngine(this.timeline);

  double _ease(double t, TweenMode mode) {
    switch (mode) {
      case TweenMode.linear:
        return t;
      case TweenMode.easeIn:
        return t * t;
      case TweenMode.easeOut:
        return 1 - (1 - t) * (1 - t);
      case TweenMode.easeInOut:
        return t < 0.5 ? 2 * t * t : 1 - math.pow(-2 * t + 2, 2) / 2;
      case TweenMode.custom:
        return t;
    }
  }

  List<Frame> generateTweens(Frame from, Frame to, int steps) {
    final frames = <Frame>[];
    for (var i = 1; i < steps; i++) {
      final t = i / steps;
      final eased = _ease(t, timeline.tweenMode);
      frames.add(Frame(
        index: from.index + i,
        duration: 1,
        isKeyframe: false,
        content: _interpolateContent(from.content, to.content, eased),
      ));
    }
    return frames;
  }

  Map<String, dynamic> _interpolateContent(
    Map<String, dynamic> from,
    Map<String, dynamic> to,
    double t,
  ) {
    final result = <String, dynamic>{};
    for (final key in {...from.keys, ...to.keys}) {
      final a = from[key];
      final b = to[key];
      if (a == null) {
        result[key] = b;
      } else if (b == null) {
        result[key] = a;
      } else if (a is num && b is num) {
        result[key] = a + (b - a) * t;
      } else if (a is List && b is List) {
        result[key] = _interpolateList(a, b, t);
      } else if (a is Map<String, dynamic> && b is Map<String, dynamic>) {
        result[key] = _interpolateContent(a, b, t);
      } else {
        result[key] = t < 0.5 ? a : b;
      }
    }
    return result;
  }

  List<dynamic> _interpolateList(List<dynamic> a, List<dynamic> b, double t) {
    final len = math.max(a.length, b.length);
    final result = List<dynamic>.filled(len, null);
    for (var i = 0; i < len; i++) {
      if (i >= a.length) {
        result[i] = b[i];
      } else if (i >= b.length) {
        result[i] = a[i];
      } else if (a[i] is num && b[i] is num) {
        result[i] = (a[i] as num) + ((b[i] as num) - (a[i] as num)) * t;
      } else {
        result[i] = t < 0.5 ? a[i] : b[i];
      }
    }
    return result;
  }

  void buildTweensOnFrame(List<Frame> frames) {
    for (var i = 0; i < frames.length; i++) {
      if (frames[i].isKeyframe) {
        var nextKey = i + 1;
        while (nextKey < frames.length && !frames[nextKey].isKeyframe) {
          nextKey++;
        }
        if (nextKey < frames.length) {
          final steps = nextKey - i;
          final tweens = generateTweens(frames[i], frames[nextKey], steps);
          for (var j = 0; j < tweens.length; j++) {
            frames[i + 1 + j] = tweens[j];
          }
          i = nextKey;
        }
      }
    }
  }
}
