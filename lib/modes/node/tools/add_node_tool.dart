import 'dart:ui' show Color;
import 'package:flutter/material.dart';
import '../models/marioneta.dart';
import '../models/nodo.dart';
import '../models/segmento.dart';
import 'node_tool.dart';
import '../../../core/math/vector2.dart';

class AddNodeTool extends NodeTool {
  @override String get name => 'Añadir Nodo';
  @override String get icon => '➕';
  @override NodeToolType get toolType => NodeToolType.addNode;

  Color _nodeColor = Colors.white;
  double _nodeSize = 30;

  set color(Color c) => _nodeColor = c;
  set size(double s) => _nodeSize = s;

  @override
  void onTap(Vector2 position, NodeWorkspace workspace) {
    final parent = workspace.selectedNode ?? workspace.marioneta.nodoRaiz;
    final nodo = Nodo(
      nombre: 'Nodo ${workspace.marioneta.nodos.length + 1}',
      posicion: position,
      posicionLocal: position,
      color: _nodeColor,
      grosor: 4,
      longitud: _nodeSize,
    );
    workspace.marioneta.agregarNodo(nodo);

    if (parent != null) {
      workspace.marioneta.agregarSegmento(Segmento(
        nodoOrigenId: parent.id,
        nodoDestinoId: nodo.id,
        nombre: '${parent.nombre}-${nodo.nombre}',
      ));
    }

    workspace.selectNode(nodo.id);
  }

  @override
  void renderOverlay(Canvas canvas, NodeWorkspace workspace) {}
}
