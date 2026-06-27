import 'dart:ui' show Color;
import 'package:uuid/uuid.dart';
import 'body_part.dart';
import 'color_utils.dart';

enum ClothingCategory {
  peinado, sombrero, ojos, boca, mascara,
  camisa, chaqueta, vestido, abrigo,
  pantalon, falda,
  zapatos, calcetines,
  accesorioCabeza, accesorioCuello, accesorioMuneca,
  ala, cola, prop
}

class ClothingItem {
  final String id;
  final String name;
  final ClothingCategory category;
  final BodyPartType attachmentPoint;
  Color color;
  Color colorSecundario;
  double scale;
  bool activo;

  ClothingItem({
    String? id,
    required this.name,
    required this.category,
    this.attachmentPoint = BodyPartType.torso,
    this.color = const Color(0xFFFFFFFF),
    this.colorSecundario = const Color(0xFFCCCCCC),
    this.scale = 1.0,
    this.activo = true,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name, 'category': category.name,
    'attachmentPoint': attachmentPoint.name,
    'color': colorToInt(color), 'colorSecundario': colorToInt(colorSecundario),
    'scale': scale, 'activo': activo,
  };

  factory ClothingItem.fromJson(Map<String, dynamic> json) => ClothingItem(
    id: json['id'], name: json['name'],
    category: ClothingCategory.values.byName(json['category']),
    attachmentPoint: BodyPartType.values.byName(json['attachmentPoint']),
    color: intToColor(json['color']),
    colorSecundario: Color(json['colorSecundario']),
    scale: (json['scale'] as num).toDouble(),
    activo: json['activo'],
  );
}
