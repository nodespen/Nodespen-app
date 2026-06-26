import 'package:flutter/material.dart';
import '../models/drawing_element.dart';
import 'draw_tool.dart';
import '../../../core/math/vector2.dart';

class ShapeTool extends DrawTool {
  ToolType _shapeType;
  Vector2? _dragStart;
  DrawingElement? _preview;

  ShapeTool({ToolType shapeType = ToolType.rect}) : _shapeType = shapeType;

  @override String get name {
    switch (_shapeType) {
      case ToolType.rect: return 'Rectángulo';
      case ToolType.circle: return 'Círculo';
      case ToolType.line: return 'Línea';
      default: return 'Formas';
    }
  }
  @override String get icon {
    switch (_shapeType) {
      case ToolType.rect: return '⬜';
      case ToolType.circle: return '⬤';
      case ToolType.line: return '╱';
      default: return '⬜';
    }
  }
  @override ToolType get toolType => _shapeType;

  void setShape(ToolType type) => _shapeType = type;

  @override
  void onActivate() {}

  @override
  void onDeactivate() {
    _dragStart = null;
    _preview = null;
  }

  @override
  void onDragStart(Vector2 position, DrawingCanvas canvas) {
    _dragStart = position;
  }

  @override
  void onDragUpdate(Vector2 position, DrawingCanvas canvas) {
    if (_dragStart == null) return;
    _preview = _buildShape(_dragStart!, position, canvas);
  }

  @override
  void onDragEnd(Vector2 position, DrawingCanvas canvas) {
    if (_dragStart == null) return;
    canvas.addElement(_buildShape(_dragStart!, position, canvas));
    _dragStart = null;
    _preview = null;
  }

  @override
  void onTap(Vector2 position, DrawingCanvas canvas) {
    canvas.addElement(RectElement(
      origin: position - const Vector2(25, 25),
      size: const Vector2(50, 50),
      color: canvas.currentColor,
      strokeWidth: canvas.strokeWidth,
    ));
  }

  DrawingElement _buildShape(Vector2 start, Vector2 end, DrawingCanvas canvas) {
    final minX = start.x < end.x ? start.x : end.x;
    final minY = start.y < end.y ? start.y : end.y;
    final maxX = start.x > end.x ? start.x : end.x;
    final maxY = start.y > end.y ? start.y : end.y;
    final size = Vector2(maxX - minX, maxY - minY);

    switch (_shapeType) {
      case ToolType.rect:
        return RectElement(
          origin: Vector2(minX, minY),
          size: size,
          color: canvas.currentColor,
          strokeWidth: canvas.strokeWidth,
        );
      case ToolType.circle:
        return CircleElement(
          center: Vector2((start.x + end.x) / 2, (start.y + end.y) / 2),
          radiusX: size.x / 2, radiusY: size.y / 2,
          color: canvas.currentColor,
          strokeWidth: canvas.strokeWidth,
        );
      case ToolType.line:
        return LineElement(
          start: start, end: end,
          color: canvas.currentColor,
          strokeWidth: canvas.strokeWidth,
        );
      default:
        return RectElement(
          origin: Vector2(minX, minY), size: size,
          color: canvas.currentColor,
          strokeWidth: canvas.strokeWidth,
        );
    }
  }

  @override
  void renderPreview(Canvas canvas, DrawingCanvas ctx) {
    _preview?.render(canvas);
  }
}
