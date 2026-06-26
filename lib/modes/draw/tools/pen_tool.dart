import 'package:flutter/material.dart';
import '../models/drawing_element.dart';
import 'draw_tool.dart';
import '../../../core/math/vector2.dart';

class PenTool extends DrawTool {
  @override String get name => 'Lápiz';
  @override String get icon => '✏️';
  @override ToolType get toolType => ToolType.pen;

  StrokeElement? _currentStroke;

  @override
  void onActivate() {}

  @override
  void onDeactivate() {
    _currentStroke = null;
  }

  @override
  void onDragStart(Vector2 position, DrawingCanvas canvas) {
    _currentStroke = StrokeElement(
      color: canvas.currentColor,
      strokeWidth: canvas.strokeWidth,
    );
    _currentStroke!.points.add(position);
  }

  @override
  void onDragUpdate(Vector2 position, DrawingCanvas canvas) {
    if (_currentStroke == null) return;
    _currentStroke!.points.add(position);
  }

  @override
  void onDragEnd(Vector2 position, DrawingCanvas canvas) {
    if (_currentStroke == null) return;
    _currentStroke!.points.add(position);
    if (_currentStroke!.points.length > 1) {
      canvas.addElement(_currentStroke!);
    }
    _currentStroke = null;
  }

  @override
  void onTap(Vector2 position, DrawingCanvas canvas) {
    final stroke = StrokeElement(
      color: canvas.currentColor,
      strokeWidth: canvas.strokeWidth,
      points: [position, position + const Vector2(0.1, 0.1)],
    );
    canvas.addElement(stroke);
  }

  @override
  void renderPreview(Canvas canvas, DrawingCanvas ctx) {
    if (_currentStroke == null || _currentStroke!.points.length < 2) return;
    final paint = Paint()
      ..color = ctx.currentColor.withValues(alpha: ctx.opacity)
      ..strokeWidth = ctx.strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final path = Path();
    path.moveTo(_currentStroke!.points[0].x, _currentStroke!.points[0].y);
    for (var i = 1; i < _currentStroke!.points.length; i++) {
      path.lineTo(_currentStroke!.points[i].x, _currentStroke!.points[i].y);
    }
    canvas.drawPath(path, paint);
  }
}
