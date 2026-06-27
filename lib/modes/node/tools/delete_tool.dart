import 'package:flutter/material.dart';
import '../models/marioneta.dart';
import '../models/nodo.dart';
import 'node_tool.dart';
import '../../../core/math/vector2.dart';

class DeleteTool extends NodeTool {
  @override String get name => 'Eliminar';
  @override String get icon => '🗑️';
  @override NodeToolType get toolType => NodeToolType.delete;

  @override
  void onTap(Vector2 position, NodeWorkspace workspace) {
    final hit = workspace.hitTest(position);
    if (hit == null) return;

    if (hit.tipo == NodoTipo.raiz) return;

    final segmentos = workspace.marioneta.segmentosDeNodo(hit.id);
    for (final seg in segmentos) {
      workspace.marioneta.segmentos.removeWhere((s) => s.id == seg.id);
    }

    workspace.marioneta.nodos.removeWhere((n) => n.id == hit.id);

    if (workspace.selectedNodeId == hit.id) {
      workspace.clearSelection();
    }
  }

  @override
  void onDragStart(Vector2 position, NodeWorkspace workspace) {}

  @override
  void onDragUpdate(Vector2 position, NodeWorkspace workspace) {}

  @override
  void onDragEnd(Vector2 position, NodeWorkspace workspace) {}

  @override
  void renderOverlay(Canvas canvas, NodeWorkspace workspace) {}
}
