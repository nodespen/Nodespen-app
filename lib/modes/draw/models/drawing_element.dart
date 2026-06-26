import 'dart:ui' show Color;
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import '../../../core/math/vector2.dart';

enum ElementType { stroke, rect, circle, line, triangle, polygon }

abstract class DrawingElement {
  final String id;
  String name;
  ElementType type;
  Color color;
  double strokeWidth;
  double opacity;
  bool visible;
  int order;

  DrawingElement({
    String? id,
    this.name = 'Elemento',
    required this.type,
    this.color = Colors.white,
    this.strokeWidth = 2.0,
    this.opacity = 1.0,
    this.visible = true,
    this.order = 0,
  }) : id = id ?? const Uuid().v4();

  void render(Canvas canvas);
  bool hitTest(Vector2 point, double radius);

  Map<String, dynamic> toJson();
  void transform(Matrix3 matrix);
}

class StrokeElement extends DrawingElement {
  final List<Vector2> points;
  bool closed;
  bool filled;

  StrokeElement({
    String? id,
    this.points = const [],
    this.closed = false,
    this.filled = false,
    Color? color,
    double? strokeWidth,
  }) : super(
    id: id,
    type: ElementType.stroke,
    color: color ?? Colors.white,
    strokeWidth: strokeWidth ?? 2.0,
  );

  @override
  void render(Canvas canvas) {
    if (points.isEmpty) return;
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = strokeWidth
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(points[0].x, points[0].y);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i].x, points[i].y);
    }
    if (closed) path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool hitTest(Vector2 point, double radius) {
    for (final p in points) {
      if (p.distanceTo(point) <= radius) return true;
    }
    return false;
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id, 'type': type.name,
    'points': points.map((p) => [p.x, p.y]).toList(),
    'closed': closed, 'filled': filled,
    'color': color.value, 'strokeWidth': strokeWidth,
    'opacity': opacity, 'visible': visible, 'order': order,
  };

  factory StrokeElement.fromJson(Map<String, dynamic> json) => StrokeElement(
    id: json['id'],
    points: (json['points'] as List).map((p) => Vector2(p[0], p[1])).toList(),
    closed: json['closed'] ?? false,
    filled: json['filled'] ?? false,
    color: Color(json['color']),
    strokeWidth: (json['strokeWidth'] as num).toDouble(),
  );

  @override
  void transform(Matrix3 matrix) {
    for (var i = 0; i < points.length; i++) {
      points[i] = matrix.transform(points[i]);
    }
  }
}

class RectElement extends DrawingElement {
  Vector2 origin;
  Vector2 size;
  bool filled;

  RectElement({
    String? id,
    Vector2? origin,
    Vector2? size,
    this.filled = false,
    Color? color,
    double? strokeWidth,
  }) : origin = origin ?? Vector2.zero(),
       size = size ?? Vector2(100, 100),
       super(
    id: id,
    type: ElementType.rect,
    color: color ?? Colors.white,
    strokeWidth: strokeWidth ?? 2.0,
  );

  Rect get rect => Rect.fromLTWH(
    origin.x, origin.y, size.x, size.y
  );

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = strokeWidth
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke;
    canvas.drawRect(rect, paint);
  }

  @override
  bool hitTest(Vector2 point, double radius) => rect.contains(Offset(point.x, point.y));

  @override
  Map<String, dynamic> toJson() => {
    'id': id, 'type': type.name,
    'origin': [origin.x, origin.y],
    'size': [size.x, size.y],
    'filled': filled,
    'color': color.value, 'strokeWidth': strokeWidth,
    'opacity': opacity, 'visible': visible, 'order': order,
  };

  factory RectElement.fromJson(Map<String, dynamic> json) => RectElement(
    id: json['id'],
    origin: Vector2(json['origin'][0], json['origin'][1]),
    size: Vector2(json['size'][0], json['size'][1]),
    filled: json['filled'] ?? false,
    color: Color(json['color']),
    strokeWidth: (json['strokeWidth'] as num).toDouble(),
  );

  @override
  void transform(Matrix3 matrix) {
    origin = matrix.transform(origin);
  }
}

class CircleElement extends DrawingElement {
  Vector2 center;
  double radiusX;
  double radiusY;
  bool filled;

  CircleElement({
    String? id,
    Vector2? center,
    this.radiusX = 50,
    this.radiusY = 50,
    this.filled = false,
    Color? color,
    double? strokeWidth,
  }) : center = center ?? Vector2.zero(),
       super(
    id: id,
    type: ElementType.circle,
    color: color ?? Colors.white,
    strokeWidth: strokeWidth ?? 2.0,
  );

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = strokeWidth
      ..style = filled ? PaintingStyle.fill : PaintingStyle.stroke;
    canvas.drawOval(
      Rect.fromCenter(center: Offset(center.x, center.y), width: radiusX * 2, height: radiusY * 2),
      paint,
    );
  }

  @override
  bool hitTest(Vector2 point, double radius) {
    final dx = (point.x - center.x) / radiusX;
    final dy = (point.y - center.y) / radiusY;
    return dx * dx + dy * dy <= 1;
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id, 'type': type.name,
    'center': [center.x, center.y],
    'radiusX': radiusX, 'radiusY': radiusY,
    'filled': filled,
    'color': color.value, 'strokeWidth': strokeWidth,
    'opacity': opacity, 'visible': visible, 'order': order,
  };

  factory CircleElement.fromJson(Map<String, dynamic> json) => CircleElement(
    id: json['id'],
    center: Vector2(json['center'][0], json['center'][1]),
    radiusX: (json['radiusX'] as num).toDouble(),
    radiusY: (json['radiusY'] as num).toDouble(),
    filled: json['filled'] ?? false,
    color: Color(json['color']),
    strokeWidth: (json['strokeWidth'] as num).toDouble(),
  );

  @override
  void transform(Matrix3 matrix) {
    center = matrix.transform(center);
  }
}

class LineElement extends DrawingElement {
  Vector2 start;
  Vector2 end;

  LineElement({
    String? id,
    Vector2? start,
    Vector2? end,
    Color? color,
    double? strokeWidth,
  }) : start = start ?? Vector2.zero(),
       end = end ?? Vector2(100, 0),
       super(
    id: id,
    type: ElementType.line,
    color: color ?? Colors.white,
    strokeWidth: strokeWidth ?? 2.0,
  );

  @override
  void render(Canvas canvas) {
    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(start.x, start.y), Offset(end.x, end.y), paint);
  }

  @override
  bool hitTest(Vector2 point, double radius) {
    final d = ((end - start)..normalized).dot(point - start);
    final closest = start + (end - start) * (d / (end - start).magnitudeSquared).clamp(0, 1);
    return closest.distanceTo(point) <= radius;
  }

  @override
  Map<String, dynamic> toJson() => {
    'id': id, 'type': type.name,
    'start': [start.x, start.y],
    'end': [end.x, end.y],
    'color': color.value, 'strokeWidth': strokeWidth,
    'opacity': opacity, 'visible': visible, 'order': order,
  };

  factory LineElement.fromJson(Map<String, dynamic> json) => LineElement(
    id: json['id'],
    start: Vector2(json['start'][0], json['start'][1]),
    end: Vector2(json['end'][0], json['end'][1]),
    color: Color(json['color']),
    strokeWidth: (json['strokeWidth'] as num).toDouble(),
  );

  @override
  void transform(Matrix3 matrix) {
    start = matrix.transform(start);
    end = matrix.transform(end);
  }
}
