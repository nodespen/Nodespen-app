import 'dart:ui' show Color;
import 'package:uuid/uuid.dart';
import 'body_part.dart';
import 'clothing_item.dart';
import 'color_utils.dart';
import '../../../core/math/vector2.dart';

class GachaCharacter {
  final String id;
  String name;
  Vector2 position;
  double scale;
  double rotation;
  bool visible;

  final Map<BodyPartType, BodyPart> bodyParts = {};
  final Map<BodyPartType, BodyPart> accesorios = {};
  final List<ClothingItem> wornItems = [];
  final List<ClothingItem> inventory = [];

  GachaCharacter({
    String? id,
    this.name = 'Personaje',
    Vector2? position,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.visible = true,
  }) : id = id ?? const Uuid().v4(),
       position = position ?? Vector2.zero() {
    _buildDefaultBody();
    _populateInventory();
  }

  void _buildDefaultBody() {
    final skin = const Color(0xFFFFDBB4);

    bodyParts[BodyPartType.cabeza] = BodyPart(
      type: BodyPartType.cabeza, name: 'Cabeza',
      position: Vector2(0, -100), localPosition: Vector2(0, -100),
      width: 50, height: 50, color: skin,
    );

    bodyParts[BodyPartType.torso] = BodyPart(
      type: BodyPartType.torso, name: 'Torso',
      position: Vector2(0, -20), localPosition: Vector2(0, -20),
      width: 40, height: 60, color: const Color(0xFF4488FF),
    );

    bodyParts[BodyPartType.brazoIzquierdo] = BodyPart(
      type: BodyPartType.brazoIzquierdo, name: 'Brazo Izq',
      position: Vector2(-35, -5), localPosition: Vector2(-35, -5),
      width: 12, height: 45, color: skin, angle: 0.2,
    );

    bodyParts[BodyPartType.brazoDerecho] = BodyPart(
      type: BodyPartType.brazoDerecho, name: 'Brazo Der',
      position: Vector2(35, -5), localPosition: Vector2(35, -5),
      width: 12, height: 45, color: skin, angle: -0.2,
    );

    bodyParts[BodyPartType.manoIzquierda] = BodyPart(
      type: BodyPartType.manoIzquierda, name: 'Mano Izq',
      position: Vector2(-35, 37), localPosition: Vector2(0, 40),
      width: 10, height: 10, color: skin,
    );

    bodyParts[BodyPartType.manoDerecha] = BodyPart(
      type: BodyPartType.manoDerecha, name: 'Mano Der',
      position: Vector2(35, 37), localPosition: Vector2(0, 40),
      width: 10, height: 10, color: skin,
    );

    bodyParts[BodyPartType.piernaIzquierda] = BodyPart(
      type: BodyPartType.piernaIzquierda, name: 'Pierna Izq',
      position: Vector2(-12, 40), localPosition: Vector2(-12, 40),
      width: 14, height: 50, color: const Color(0xFF3355AA),
    );

    bodyParts[BodyPartType.piernaDerecha] = BodyPart(
      type: BodyPartType.piernaDerecha, name: 'Pierna Der',
      position: Vector2(12, 40), localPosition: Vector2(12, 40),
      width: 14, height: 50, color: const Color(0xFF3355AA),
    );

    bodyParts[BodyPartType.pieIzquierdo] = BodyPart(
      type: BodyPartType.pieIzquierdo, name: 'Pie Izq',
      position: Vector2(-12, 88), localPosition: Vector2(0, 48),
      width: 16, height: 8, color: const Color(0xFF884422),
    );

    bodyParts[BodyPartType.pieDerecho] = BodyPart(
      type: BodyPartType.pieDerecho, name: 'Pie Der',
      position: Vector2(12, 88), localPosition: Vector2(0, 48),
      width: 16, height: 8, color: const Color(0xFF884422),
    );
  }

  void _populateInventory() {
    final items = [
      ClothingItem(name: 'Pelo Largo', category: ClothingCategory.peinado, attachmentPoint: BodyPartType.cabeza, color: const Color(0xFF2D2D2D)),
      ClothingItem(name: 'Pelo Corto', category: ClothingCategory.peinado, attachmentPoint: BodyPartType.cabeza, color: const Color(0xFF8B4513)),
      ClothingItem(name: 'Sombrero Copa', category: ClothingCategory.sombrero, attachmentPoint: BodyPartType.cabeza, color: const Color(0xFF1A1A1A)),
      ClothingItem(name: 'Corona', category: ClothingCategory.sombrero, attachmentPoint: BodyPartType.cabeza, color: const Color(0xFFFFD700)),
      ClothingItem(name: 'Ojos Brillantes', category: ClothingCategory.ojos, attachmentPoint: BodyPartType.cabeza, color: const Color(0xFF44AAFF)),
      ClothingItem(name: 'Ojos Serios', category: ClothingCategory.ojos, attachmentPoint: BodyPartType.cabeza, color: const Color(0xFF2D2D2D)),
      ClothingItem(name: 'Camisa Blanca', category: ClothingCategory.camisa, attachmentPoint: BodyPartType.torso, color: const Color(0xFFFFFFFF)),
      ClothingItem(name: 'Camisa Roja', category: ClothingCategory.camisa, attachmentPoint: BodyPartType.torso, color: const Color(0xFFCC3333)),
      ClothingItem(name: 'Chaqueta', category: ClothingCategory.chaqueta, attachmentPoint: BodyPartType.torso, color: const Color(0xFF555555)),
      ClothingItem(name: 'Vestido Floral', category: ClothingCategory.vestido, attachmentPoint: BodyPartType.torso, color: const Color(0xFFFF88AA)),
      ClothingItem(name: 'Pantalón Mezclilla', category: ClothingCategory.pantalon, attachmentPoint: BodyPartType.piernaIzquierda, color: const Color(0xFF3355AA)),
      ClothingItem(name: 'Falda Corta', category: ClothingCategory.falda, attachmentPoint: BodyPartType.piernaIzquierda, color: const Color(0xFFFF6699)),
      ClothingItem(name: 'Zapatos Negros', category: ClothingCategory.zapatos, attachmentPoint: BodyPartType.pieIzquierdo, color: const Color(0xFF1A1A1A)),
      ClothingItem(name: 'Botas Marrones', category: ClothingCategory.zapatos, attachmentPoint: BodyPartType.pieIzquierdo, color: const Color(0xFF8B4513)),
      ClothingItem(name: 'Alas Blancas', category: ClothingCategory.ala, attachmentPoint: BodyPartType.torso, color: const Color(0xFFFFFFFF)),
      ClothingItem(name: 'Collar Perla', category: ClothingCategory.accesorioCuello, attachmentPoint: BodyPartType.torso, color: const Color(0xFFFFF8DC)),
      ClothingItem(name: 'Varita Mágica', category: ClothingCategory.prop, attachmentPoint: BodyPartType.manoDerecha, color: const Color(0xFFFFD700)),
    ];
    inventory.addAll(items);
  }

  void equip(ClothingItem item) {
    wornItems.removeWhere((w) => w.category == item.category);
    wornItems.add(item);
  }

  void unequip(ClothingCategory category) {
    wornItems.removeWhere((w) => w.category == category);
  }

  bool isEquipped(ClothingCategory category) =>
    wornItems.any((w) => w.category == category);

  ClothingItem? getEquipped(ClothingCategory category) =>
    wornItems.where((w) => w.category == category).firstOrNull;

  Map<String, dynamic> toJson() => {
    'id': id, 'name': name,
    'position': [position.x, position.y],
    'scale': scale, 'rotation': rotation, 'visible': visible,
    'bodyParts': bodyParts.entries.map((e) => {
      'type': e.key.name,
      'position': [e.value.position.x, e.value.position.y],
      'angle': e.value.angle,
      'color': colorToInt(e.value.color),
    }).toList(),
    'wornItems': wornItems.map((w) => w.toJson()).toList(),
    'inventory': inventory.map((w) => w.toJson()).toList(),
  };

  factory GachaCharacter.fromJson(Map<String, dynamic> json) {
    final c = GachaCharacter(
      id: json['id'], name: json['name'],
      position: Vector2(json['position'][0], json['position'][1]),
      scale: (json['scale'] as num).toDouble(),
      rotation: (json['rotation'] as num).toDouble(),
      visible: json['visible'],
    );
    for (final entry in json['bodyParts'] as List) {
      final type = BodyPartType.values.byName(entry['type']);
      final part = c.bodyParts[type];
      if (part != null) {
        part.position = Vector2(entry['position'][0], entry['position'][1]);
        part.angle = (entry['angle'] as num).toDouble();
        part.color = Color(entry['color']);
      }
    }
    for (final item in json['wornItems'] as List) {
      c.wornItems.add(ClothingItem.fromJson(item));
    }
    for (final item in json['inventory'] as List) {
      c.inventory.add(ClothingItem.fromJson(item));
    }
    return c;
  }
}
