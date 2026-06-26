import 'package:flutter/material.dart';
import '../core/document/document.dart';
import '../core/canvas/renderer.dart';
import '../core/math/vector2.dart';

abstract class Mode {
  String get name;
  String get icon;
  String get description;
  ProjectMode get modeType;

  void onActivate(NodespenDocument document) {}
  void onDeactivate(NodespenDocument document) {}
  void onTap(Vector2 canvasPosition, NodespenDocument document) {}
  void onDragStart(Vector2 position, NodespenDocument document) {}
  void onDragUpdate(Vector2 position, NodespenDocument document) {}
  void onDragEnd(Vector2 position, NodespenDocument document) {}
  void onKeyEvent(KeyEvent event, NodespenDocument document) {}

  void render(Canvas canvas, Size size, NodespenRenderer renderer);

  List<ToolOption> get toolOptions => [];
  List<Widget>? buildPropertyPanel(NodespenDocument document) => null;
}

class ToolOption {
  final String name;
  final String icon;
  final bool isActive;
  final VoidCallback? onTap;

  ToolOption({
    required this.name,
    required this.icon,
    this.isActive = false,
    this.onTap,
  });
}
