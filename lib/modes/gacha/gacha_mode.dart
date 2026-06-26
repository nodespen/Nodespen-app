import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../mode.dart';
import '../../core/document/document.dart';
import '../../core/canvas/renderer.dart';
import '../../core/math/vector2.dart';

class GachaMode extends Mode {
  @override String get name => 'Gacha';
  @override String get icon => '🎀';
  @override String get description => 'Modo de personajes y escenas Gacha';
  @override ProjectMode get modeType => ProjectMode.gacha;

  @override
  void render(Canvas canvas, Size size, NodespenRenderer renderer) {
    final paint = Paint()
      ..color = Colors.pink
      ..strokeWidth = 2.0
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 40, paint);
  }
}
