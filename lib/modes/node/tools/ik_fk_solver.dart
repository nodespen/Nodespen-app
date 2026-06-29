import 'dart:math' as math;
import '../models/marioneta.dart';
import '../models/nodo.dart';
import '../../../core/math/vector2.dart';

enum IKFkMode { fk, ik }

class IkFkSolver {
  IKFkMode mode;

  IkFkSolver({this.mode = IKFkMode.fk});

  /// Forward Kinematics: propagate rotation from root down the chain
  void solveFK(Marioneta marioneta) {
    marioneta.recalcularPosiciones();
  }

  /// Inverse Kinematics using CCD (Cyclic Coordinate Descent):
  /// moves [targetNode] to [targetPos] by adjusting ancestor angles.
  void solveIK(Marioneta marioneta, Nodo targetNode, Vector2 targetPos,
      {int maxIterations = 10, double tolerance = 1.0}) {
    final chain = _buildChainToRoot(marioneta, targetNode.id);
    if (chain.length < 2) {
      targetNode.posicion = targetPos;
      targetNode.posicionLocal = targetPos;
      return;
    }

    for (var iter = 0; iter < maxIterations; iter++) {
      final endPos = targetNode.posicion;
      if (endPos.distanceTo(targetPos) <= tolerance) break;

      for (var i = chain.length - 2; i >= 0; i--) {
        final joint = chain[i];
        final child = chain[i + 1];
        if (joint.tipo == NodoTipo.estatico ||
            joint.tipo == NodoTipo.anguloBloqueado) continue;

        final jointPos = joint.posicion;
        final childPos = child.posicion;

        final toChild = (childPos - jointPos).normalized;
        final toTarget = (targetPos - jointPos).normalized;

        final cross = toChild.cross(toTarget);
        final angle = math.acos(
          (toChild.dot(toTarget)).clamp(-1.0, 1.0));

        final sign = cross < 0 ? -1.0 : 1.0;
        joint.angulo += angle * sign;
        joint.anguloLocal += angle * sign;

        _updateFKFromRoot(marioneta, chain[0].id);
      }
    }

    targetNode.posicion = targetPos;
    targetNode.posicionLocal = targetPos;
  }

  /// Move root and all children (FK translation)
  void moveRoot(Marioneta marioneta, Vector2 delta) {
    if (marioneta.nodoRaiz == null) return;
    marioneta.nodoRaiz!.posicion += delta;
    marioneta.posicion += delta;
    solveFK(marioneta);
  }

  List<Nodo> _buildChainToRoot(Marioneta marioneta, String nodeId) {
    final chain = <Nodo>[];
    String? currentId = nodeId;

    while (currentId != null) {
      final node = marioneta.obtenerNodo(currentId);
      if (node == null) break;
      chain.insert(0, node);

      Nodo? parent;
      for (final seg in marioneta.segmentos) {
        if (seg.nodoDestinoId == currentId) {
          parent = marioneta.obtenerNodo(seg.nodoOrigenId);
          if (parent != null) break;
        }
      }
      currentId = parent?.id;
    }
    return chain;
  }

  void _updateFKFromRoot(Marioneta marioneta, String rootId) {
    final root = marioneta.obtenerNodo(rootId);
    if (root == null) return;
    _fkRecursive(marioneta, rootId, root.posicion, root.angulo);
  }

  void _fkRecursive(
      Marioneta marioneta, String nodeId, Vector2 parentPos, double parentAng) {
    final node = marioneta.obtenerNodo(nodeId);
    if (node == null) return;

    if (node.id != marioneta.nodoRaizId) {
      final ang = parentAng + node.anguloLocal;
      node.posicion = Vector2(
        parentPos.x + node.longitud * math.cos(ang),
        parentPos.y + node.longitud * math.sin(ang),
      );
    }

    for (final seg in marioneta.segmentos) {
      if (seg.nodoOrigenId == nodeId) {
        _fkRecursive(
            marioneta, seg.nodoDestinoId, node.posicion, node.angulo);
      }
    }
  }
}
