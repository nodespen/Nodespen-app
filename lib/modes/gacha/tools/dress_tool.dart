import 'package:flutter/material.dart';
import '../models/gacha_character.dart';
import '../models/clothing_item.dart';
import '../models/body_part.dart';
import 'gacha_tool.dart';
import '../../../core/math/vector2.dart';

class DressTool extends GachaTool {
  @override String get name => 'Vestir';
  @override String get icon => '👗';
  @override GachaToolType get toolType => GachaToolType.dress;

  ClothingCategory? _selectedCategory;

  void selectCategory(ClothingCategory cat) {
    _selectedCategory = cat;
  }

  @override
  void onTap(Vector2 position, GachaWorkspace workspace) {
    if (_selectedCategory == null) return;
    final items = workspace.character.inventory
      .where((i) => i.category == _selectedCategory!)
      .toList();
    if (items.isEmpty) return;

    final current = workspace.character.getEquipped(_selectedCategory!);
    final currentIndex = current != null ? items.indexOf(current) : -1;
    final nextIndex = (currentIndex + 1) % items.length;
    workspace.character.equip(items[nextIndex]);
  }

  @override
  void onDragStart(Vector2 position, GachaWorkspace workspace) {}
  @override
  void onDragUpdate(Vector2 position, GachaWorkspace workspace) {}
  @override
  void onDragEnd(Vector2 position, GachaWorkspace workspace) {}

  @override
  void renderOverlay(Canvas canvas, GachaWorkspace workspace) {}
}
