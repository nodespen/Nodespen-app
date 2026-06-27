import 'dart:ui' show Color;
import 'package:flutter/material.dart';
import '../models/marioneta.dart';
import '../models/nodo.dart';
import '../models/segmento.dart';
import 'node_tool.dart';
import '../../../core/math/vector2.dart';

class AddSegmentTool extends NodeTool {
  @override String get name => 'Añadir Segmento';
  @override String get icon => '🔗';
  @override NodeToolType get toolType => NodeToolType.addSegment;

  String? _firstNodeId;

  @override
  void onDeactivate() {
    _firstNodeId = null;
  }

  @override
  void onTap(Vector2 position, NodeWorkspace workspace) {
    final hit = workspace.hitTest(position);
    if (hit == null) {
      _firstNodeId = null;
      return;
    }

    if (_firstNodeId == null) {
      _firstNodeId = hit.id;
      workspace.selectNode(hit.id);
    } else {
      if (_firstNodeId != hit.id) {
        workspace.marioneta.agregarSegmento(Segmento(
          nodoOrigenId: _firstNodeId!,
          nodoDestinoId: hit.id,
          nombre: 'Seg ${_firstNodeId!.substring(0, 4)}-${hit.id.substring(0, 4)}',
        ));
      }
      _firstNodeId = null;
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
  void renderOverlay(Canvas canvas, NodeWorkspace workspace) {
    if (_firstNodeId == null) return;
    final first = workspace.marioneta.obtenerNodo(_firstNodeId!);
    if (first == null) return;
    final pos = Offset(first.posicion.x, first.posicion.y);
    final paint = Paint()
      ..color = Colors.greenAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(pos, 10, paint);
  }
}
