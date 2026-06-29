import 'package:flutter/material.dart';
import '../models/drawing_element.dart';
import 'draw_tool.dart';
import '../../../core/math/vector2.dart';

enum FillMode { solid, gradient, pattern }

class FillTool extends DrawTool {
  FillMode fillMode;

  FillTool({this.fillMode = FillMode.solid});

  @override String get name => 'Rellenar';
  @override String get icon => '🪣';
  @override ToolType get toolType => ToolType.fill;

  @override
  void onActivate() {}

  @override
  void onDeactivate() {}

  @override
  void onTap(Vector2 position, DrawingCanvas canvas) {
    final hit = canvas.hitTest(position, 10);
    if (hit == null) return;

    switch (fillMode) {
      case FillMode.solid:
        if (hit is StrokeElement) {
          hit.filled = !hit.filled;
          hit.closed = true;
        } else if (hit is RectElement) {
          hit.filled = !hit.filled;
        } else if (hit is CircleElement) {
          hit.filled = !hit.filled;
        }
      case FillMode.gradient:
        if (hit is StrokeElement) {
          hit.filled = true;
          hit.closed = true;
        } else if (hit is RectElement) {
          hit.filled = true;
        } else if (hit is CircleElement) {
          hit.filled = true;
        }
      case FillMode.pattern:
        break;
    }
  }

  @override
  void onDragStart(Vector2 position, DrawingCanvas canvas) {}

  @override
  void onDragUpdate(Vector2 position, DrawingCanvas canvas) {}

  @override
  void onDragEnd(Vector2 position, DrawingCanvas canvas) {}

  @override
  void renderPreview(Canvas canvas, DrawingCanvas ctx) {}
}
