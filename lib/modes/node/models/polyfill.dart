import 'dart:ui' as ui;
import 'package:uuid/uuid.dart';
import '../../../core/math/vector2.dart';
import 'nodo.dart';

class Polyfill {
  final String id;
  final List<String> nodosIds;
  String nombre;
  bool cerrado;
  Color color;
  Color colorContorno;
  double grosorContorno;

  Polyfill({
    String? id,
    required this.nodosIds,
    this.nombre = 'Polyfill',
    this.cerrado = true,
    this.color = const Color(0xFFFFFFFF),
    this.colorContorno = const Color(0xFF000000),
    this.grosorContorno = 1.0,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'nodosIds': nodosIds,
    'nombre': nombre,
    'cerrado': cerrado,
    'color': color.toHex(),
    'colorContorno': colorContorno.toHex(),
    'grosorContorno': grosorContorno,
  };

  factory Polyfill.fromJson(Map<String, dynamic> json) => Polyfill(
    id: json['id'],
    nodosIds: List<String>.from(json['nodosIds']),
    nombre: json['nombre'],
    cerrado: json['cerrado'],
    color: Color.fromHex(json['color']),
    colorContorno: Color.fromHex(json['colorContorno']),
    grosorContorno: (json['grosorContorno'] as num).toDouble(),
  );
}
