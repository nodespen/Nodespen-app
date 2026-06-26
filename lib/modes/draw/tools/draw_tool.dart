import 'dart:ui' show Color;
import 'package:flutter/material.dart';
import '../models/drawing_element.dart';
import '../../../core/math/vector2.dart';

enum ToolType { pen, eraser, rect, circle, line, select }

abstract class DrawTool {
  String get name;
  String get icon;
  ToolType get toolType;

  void onActivate();
  void onDeactivate();

  void onDragStart(Vector2 position, DrawingCanvas canvas);
  void onDragUpdate(Vector2 position, DrawingCanvas canvas);
  void onDragEnd(Vector2 position, DrawingCanvas canvas);
  void onTap(Vector2 position, DrawingCanvas canvas);

  void renderPreview(Canvas canvas, DrawingCanvas ctx);
}

class DrawingCanvas {
  final List<DrawingElement> elements;
  Color currentColor;
  double strokeWidth;
  double opacity;

  DrawingCanvas({
    required this.elements,
    this.currentColor = Colors.white,
    this.strokeWidth = 2.0,
    this.opacity = 1.0,
  });

  void addElement(DrawingElement element) {
    element.order = elements.length;
    elements.add(element);
  }

  void removeElement(String id) {
    elements.removeWhere((e) => e.id == id);
  }

  DrawingElement? hitTest(Vector2 point, double radius) {
    for (final e in elements.reversed) {
      if (e.hitTest(point, radius)) return e;
    }
    return null;
  }

  void clear() => elements.clear();
}
