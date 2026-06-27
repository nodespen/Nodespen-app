import 'package:flutter/material.dart';
import '../models/marioneta.dart';
import '../models/nodo.dart';
import '../models/segmento.dart';
import '../../../core/math/vector2.dart';

enum NodeToolType { select, addNode, addSegment, delete, move, rotate }

abstract class NodeTool {
  String get name;
  String get icon;
  NodeToolType get toolType;

  void onActivate() {}
  void onDeactivate() {}

  void onTap(Vector2 position, NodeWorkspace workspace);
  void onDragStart(Vector2 position, NodeWorkspace workspace);
  void onDragUpdate(Vector2 position, NodeWorkspace workspace);
  void onDragEnd(Vector2 position, NodeWorkspace workspace);

  void renderOverlay(Canvas canvas, NodeWorkspace workspace);
}

class NodeWorkspace {
  final Marioneta marioneta;
  String? selectedNodeId;
  final Set<String> selectedIds = {};
  Vector2? dragStart;

  NodeWorkspace({required this.marioneta});

  Nodo? get selectedNode =>
    selectedNodeId != null ? marioneta.obtenerNodo(selectedNodeId!) : null;

  Nodo? hitTest(Vector2 point, {double radius = 12}) {
    for (final nodo in marioneta.nodos.reversed) {
      if (nodo.posicion.distanceTo(point) <= radius) return nodo;
    }
    return null;
  }

  void selectNode(String? id) {
    selectedNodeId = id;
    if (id != null) selectedIds.add(id);
  }

  void clearSelection() {
    selectedNodeId = null;
    selectedIds.clear();
  }
}
