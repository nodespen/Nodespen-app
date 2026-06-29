import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/marioneta.dart';
import '../models/nodo.dart';
import 'node_tool.dart';
import 'ik_fk_solver.dart';
import '../../../core/math/vector2.dart';

class SelectTool extends NodeTool {
  @override String get name => 'Seleccionar';
  @override String get icon => '🖊️';
  @override NodeToolType get toolType => NodeToolType.select;

  final IkFkSolver ikFk = IkFkSolver();
  Nodo? _dragNode;
  Vector2? _dragOffset;

  IKFkMode get ikFkMode => ikFk.mode;
  set ikFkMode(IKFkMode m) => ikFk.mode = m;

  @override
  void onActivate() {}

  @override
  void onDeactivate() {
    _dragNode = null;
    _dragOffset = null;
  }

  @override
  void onTap(Vector2 position, NodeWorkspace workspace) {
    final hit = workspace.hitTest(position);
    if (hit != null) {
      workspace.selectNode(hit.id);
    } else {
      workspace.clearSelection();
    }
  }

  @override
  void onDragStart(Vector2 position, NodeWorkspace workspace) {
    final hit = workspace.hitTest(position);
    if (hit != null) {
      _dragNode = hit;
      _dragOffset = hit.posicion - position;
      workspace.selectNode(hit.id);
    } else {
      workspace.clearSelection();
    }
  }

  @override
  void onDragUpdate(Vector2 position, NodeWorkspace workspace) {
    if (_dragNode == null || _dragOffset == null) return;
    final targetPos = position + _dragOffset!;
    final isRoot = _dragNode!.id == workspace.marioneta.nodoRaizId;

    if (isRoot) {
      ikFk.moveRoot(workspace.marioneta, targetPos - _dragNode!.posicion);
    } else if (ikFk.mode == IKFkMode.ik) {
      ikFk.solveIK(workspace.marioneta, _dragNode!, targetPos);
    } else {
      _dragNode!.posicion = targetPos;
      _dragNode!.posicionLocal = targetPos;
    }
  }

  @override
  void onDragEnd(Vector2 position, NodeWorkspace workspace) {
    _dragNode = null;
    _dragOffset = null;
  }

  @override
  void renderOverlay(Canvas canvas, NodeWorkspace workspace) {
    if (workspace.selectedNode == null) return;
    final n = workspace.selectedNode!;
    final pos = Offset(n.posicion.x, n.posicion.y);

    final paint = Paint()
      ..color = Colors.cyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    canvas.drawCircle(pos, 8, paint);

    final fill = Paint()
      ..color = Colors.cyan.withValues(alpha: 0.15);
    canvas.drawCircle(pos, 8, fill);

    if (ikFk.mode == IKFkMode.ik) {
      final label = TextPainter(
        text: const TextSpan(
          text: 'IK',
          style: TextStyle(color: Colors.cyanAccent, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      label.paint(canvas, pos + const Offset(10, -16));
    }
  }
}
