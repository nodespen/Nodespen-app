import 'package:flutter/material.dart';
import '../models/drawing_element.dart';
import 'draw_tool.dart';
import '../../../core/math/vector2.dart';

class SelectTool extends DrawTool {
  @override String get name => 'Seleccionar';
  @override String get icon => '👆';
  @override ToolType get toolType => ToolType.select;

  DrawingElement? _selected;
  Vector2? _dragStart;
  Vector2? _elementStartOffset;
  Rect? _selectionRect;
  bool _isDragging = false;

  DrawingElement? get selected => _selected;

  @override
  void onActivate() {}

  @override
  void onDeactivate() {
    _selected = null;
    _dragStart = null;
    _selectionRect = null;
  }

  @override
  void onTap(Vector2 position, DrawingCanvas canvas) {
    _selected = canvas.hitTest(position, 10);
    _selectionRect = null;
  }

  @override
  void onDragStart(Vector2 position, DrawingCanvas canvas) {
    _selected = canvas.hitTest(position, 10);
    if (_selected != null) {
      _isDragging = true;
      _dragStart = position;
      if (_selected is RectElement) {
        _elementStartOffset = (_selected as RectElement).origin;
      } else if (_selected is CircleElement) {
        _elementStartOffset = (_selected as CircleElement).center;
      } else if (_selected is LineElement) {
        _elementStartOffset = null;
      }
    } else {
      _isDragging = false;
      _dragStart = position;
    }
  }

  @override
  void onDragUpdate(Vector2 position, DrawingCanvas canvas) {
    if (_isDragging && _selected != null && _dragStart != null) {
      final delta = position - _dragStart!;
      if (_selected is RectElement) {
        final rect = _selected as RectElement;
        rect.origin = _elementStartOffset != null
            ? _elementStartOffset! + delta
            : rect.origin + delta;
      } else if (_selected is CircleElement) {
        final circle = _selected as CircleElement;
        circle.center = _elementStartOffset != null
            ? _elementStartOffset! + delta
            : circle.center + delta;
      } else if (_selected is LineElement) {
        final line = _selected as LineElement;
        final startDelta = position - _dragStart!;
        line.start = line.start + startDelta;
        line.end = line.end + startDelta;
        _dragStart = position;
      } else if (_selected is StrokeElement) {
        final stroke = _selected as StrokeElement;
        final delta2 = position - _dragStart!;
        for (var i = 0; i < stroke.points.length; i++) {
          stroke.points[i] = stroke.points[i] + delta2;
        }
        _dragStart = position;
      }
    } else if (_dragStart != null) {
      final minX = _dragStart!.x < position.x ? _dragStart!.x : position.x;
      final minY = _dragStart!.y < position.y ? _dragStart!.y : position.y;
      final maxX = _dragStart!.x > position.x ? _dragStart!.x : position.x;
      final maxY = _dragStart!.y > position.y ? _dragStart!.y : position.y;
      _selectionRect = Rect.fromLTRB(minX, minY, maxX, maxY);
    }
  }

  @override
  void onDragEnd(Vector2 position, DrawingCanvas canvas) {
    _isDragging = false;
    _dragStart = null;

    if (_selectionRect != null) {
      for (final e in canvas.elements) {
        if (_elementInRect(e, _selectionRect!)) {
          _selected = e;
          break;
        }
      }
      _selectionRect = null;
    }
  }

  bool _elementInRect(DrawingElement element, Rect rect) {
    if (element is RectElement) {
      return rect.contains(Offset(element.origin.x, element.origin.y));
    } else if (element is CircleElement) {
      return rect.contains(Offset(element.center.x, element.center.y));
    } else if (element is LineElement) {
      return rect.contains(Offset(element.start.x, element.start.y)) ||
             rect.contains(Offset(element.end.x, element.end.y));
    } else if (element is StrokeElement && element.points.isNotEmpty) {
      return rect.contains(Offset(element.points[0].x, element.points[0].y));
    }
    return false;
  }

  void deleteSelected(DrawingCanvas canvas) {
    if (_selected != null) {
      canvas.removeElement(_selected!.id);
      _selected = null;
    }
  }

  @override
  void renderPreview(Canvas canvas, DrawingCanvas ctx) {
    if (_selected != null) {
      final paint = Paint()
        ..color = Colors.cyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      if (_selected is RectElement) {
        final r = (_selected as RectElement).rect;
        canvas.drawRect(r.inflate(4), paint);
      } else if (_selected is CircleElement) {
        final c = _selected as CircleElement;
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(c.center.x, c.center.y),
            width: c.radiusX * 2 + 8,
            height: c.radiusY * 2 + 8,
          ), paint);
      }
    }

    if (_selectionRect != null) {
      final fill = Paint()
        ..color = Colors.cyan.withValues(alpha: 0.1);
      final border = Paint()
        ..color = Colors.cyan
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawRect(_selectionRect!, fill);
      canvas.drawRect(_selectionRect!, border);
    }
  }
}
