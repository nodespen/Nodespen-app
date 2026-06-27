import 'package:flutter/material.dart';
import '../../../core/math/vector2.dart';

enum BodyPartType {
  cabeza, torso, brazoIzquierdo, brazoDerecho,
  manoIzquierda, manoDerecha, piernaIzquierda, piernaDerecha,
  pieIzquierdo, pieDerecho, accesorio, prop
}

class BodyPart {
  final BodyPartType type;
  final String name;
  Vector2 position;
  Vector2 localPosition;
  double angle;
  double scale;
  Color color;
  double width;
  double height;
  bool visible;

  BodyPart({
    required this.type,
    required this.name,
    Vector2? position,
    Vector2? localPosition,
    this.angle = 0,
    this.scale = 1.0,
    this.color = const Color(0xFFFFDBB4),
    this.width = 20,
    this.height = 20,
    this.visible = true,
  }) : position = position ?? Vector2.zero(),
       localPosition = localPosition ?? Vector2.zero();
}
