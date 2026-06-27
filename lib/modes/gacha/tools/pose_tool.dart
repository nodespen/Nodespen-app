import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/gacha_character.dart';
import '../models/body_part.dart';
import 'gacha_tool.dart';
import '../../../core/math/vector2.dart';

class PoseTool extends GachaTool {
  @override String get name => 'Pose';
  @override String get icon => '🧎';
  @override GachaToolType get toolType => GachaToolType.pose;

  BodyPart? _dragPart;
  Vector2? _dragOffset;

  @override
  void onTap(Vector2 position, GachaWorkspace workspace) {
    final hit = workspace.hitTest(position);
    if (hit != null) {
      workspace.selectedPartType = hit.type.name;
    }
  }

  @override
  void onDragStart(Vector2 position, GachaWorkspace workspace) {
    final hit = workspace.hitTest(position);
    if (hit != null) {
      _dragPart = hit;
      _dragOffset = hit.position - position;
      workspace.selectedPartType = hit.type.name;
    }
  }

  @override
  void onDragUpdate(Vector2 position, GachaWorkspace workspace) {
    if (_dragPart == null || _dragOffset == null) return;
    _dragPart!.position = position + _dragOffset!;
  }

  @override
  void onDragEnd(Vector2 position, GachaWorkspace workspace) {
    if (_dragPart == null) return;
    _dragPart!.position = position + _dragOffset!;
    _dragPart = null;
    _dragOffset = null;
  }

  @override
  void renderOverlay(Canvas canvas, GachaWorkspace workspace) {
    if (workspace.selectedPartType == null) return;
    final part = workspace.selectedPart;
    if (part == null) return;
    final pos = Offset(part.position.x, part.position.y);
    canvas.drawCircle(pos, 8, Paint()
      ..color = Colors.pinkAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5);
  }
}
