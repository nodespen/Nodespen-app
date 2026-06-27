import 'package:flutter/material.dart';
import '../models/gacha_character.dart';
import '../models/body_part.dart';
import '../models/clothing_item.dart';
import '../../../core/math/vector2.dart';

enum GachaToolType { dress, color, pose }

abstract class GachaTool {
  String get name;
  String get icon;
  GachaToolType get toolType;

  void onActivate() {}
  void onDeactivate() {}

  void onTap(Vector2 position, GachaWorkspace workspace);
  void onDragStart(Vector2 position, GachaWorkspace workspace);
  void onDragUpdate(Vector2 position, GachaWorkspace workspace);
  void onDragEnd(Vector2 position, GachaWorkspace workspace);

  void renderOverlay(Canvas canvas, GachaWorkspace workspace);
}

class GachaWorkspace {
  final GachaCharacter character;
  String? selectedPartType;
  ClothingCategory? selectedCategory;

  GachaWorkspace({required this.character});

  BodyPart? get selectedPart {
    if (selectedPartType == null) return null;
    return character.bodyParts[BodyPartType.values.byName(selectedPartType!)];
  }

  BodyPart? hitTest(Vector2 point, {double radius = 20}) {
    for (final part in character.bodyParts.values.toList().reversed) {
      if (!part.visible) continue;
      if (part.position.distanceTo(point) <= radius) return part;
    }
    return null;
  }
}
