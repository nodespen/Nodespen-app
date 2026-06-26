import 'dart:ui' show Color;
import 'package:flutter/material.dart';
import '../models/drawing_element.dart';
import 'draw_tool.dart';
import '../../../core/math/vector2.dart';

class EraserTool extends DrawTool {
  @override String get name => 'Borrador';
  @override String get icon => '🧹';
  @override ToolType get toolType => ToolType.eraser;

  final Set<String> _touchedIds = {};
  double eraserRadius = 15.0;

  @override
  void onActivate() {}

  @override
  void onDeactivate() {
    _touchedIds.clear();
  }

  @override
  void onDragStart(Vector2 position, DrawingCanvas canvas) {
    _eraseAt(position, canvas);
  }

  @override
  void onDragUpdate(Vector2 position, DrawingCanvas canvas) {
    _eraseAt(position, canvas);
  }

  @override
  void onDragEnd(Vector2 position, DrawingCanvas canvas) {
    for (final id in _touchedIds) {
      canvas.removeElement(id);
    }
    _touchedIds.clear();
  }

  void _eraseAt(Vector2 position, DrawingCanvas canvas) {
    final hit = canvas.hitTest(position, eraserRadius);
    if (hit != null) {
      _touchedIds.add(hit.id);
    }
  }

  @override
  void onTap(Vector2 position, DrawingCanvas canvas) {
    final hit = canvas.hitTest(position, eraserRadius);
    if (hit != null) canvas.removeElement(hit.id);
  }

  @override
  void renderPreview(Canvas canvas, DrawingCanvas ctx) {
    // No preview needed for eraser
  }
}
