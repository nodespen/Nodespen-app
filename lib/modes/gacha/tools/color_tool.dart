import 'package:flutter/material.dart';
import '../models/gacha_character.dart';
import '../models/body_part.dart';
import 'gacha_tool.dart';
import '../../../core/math/vector2.dart';

class ColorTool extends GachaTool {
  @override String get name => 'Color';
  @override String get icon => '🎨';
  @override GachaToolType get toolType => GachaToolType.color;

  Color _currentColor = const Color(0xFFFFDBB4);

  set color(Color c) => _currentColor = c;
  Color get color => _currentColor;

  @override
  void onTap(Vector2 position, GachaWorkspace workspace) {
    final hit = workspace.hitTest(position);
    if (hit != null) {
      hit.color = _currentColor;
      workspace.selectedPartType = hit.type.name;
    }
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
