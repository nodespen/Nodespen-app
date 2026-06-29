import 'package:flutter/material.dart';
import 'gacha_tool.dart';
import '../../../core/math/vector2.dart';

class ColorTool extends GachaTool {
  @override String get name => 'Color';
  @override String get icon => '🎨';
  @override GachaToolType get toolType => GachaToolType.color;

  Color color = const Color(0xFFFFDBB4);

  @override
  void onTap(Vector2 position, GachaWorkspace workspace) {
    final hit = workspace.hitTest(position);
    if (hit != null) {
      hit.color = color;
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
