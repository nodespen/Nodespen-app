import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../mode.dart';
import '../../core/document/document.dart';
import '../../core/canvas/renderer.dart';
import '../../core/math/vector2.dart';
import '../node/models/marioneta.dart';
import '../node/models/nodo.dart';
import '../node/models/segmento.dart';
import '../node/models/polyfill.dart';
import '../node/models/default_pencil.dart';

class NodeMode extends Mode {
  late Marioneta _pencil;
  bool _initialized = false;

  @override String get name => 'Nodo';
  @override String get icon => '🖊️';
  @override String get description => 'Modo de marionetas con nodos';
  @override ProjectMode get modeType => ProjectMode.node;

  Marioneta get pencil => _pencil;

  @override
  void onActivate(NodespenDocument document) {
    if (!_initialized) {
      _pencil = DefaultPencil.create();
      _initialized = true;
    }
  }

  @override
  void render(Canvas canvas, Size size, NodespenRenderer renderer) {
    if (!_initialized) return;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);

    _renderMarioneta(canvas, _pencil);

    canvas.restore();
  }

  void _renderMarioneta(Canvas canvas, Marioneta marioneta) {
    if (!marioneta.visible) return;

    // Dibujar segmentos
    for (final seg in marioneta.segmentos) {
      final origen = marioneta.obtenerNodo(seg.nodoOrigenId);
      final destino = marioneta.obtenerNodo(seg.nodoDestinoId);
      if (origen == null || destino == null) continue;
      _renderSegmento(canvas, origen, destino);
    }

    // Dibujar polyfills
    for (final pf in marioneta.polyfills) {
      _renderPolyfill(canvas, pf, marioneta);
    }

    // Dibujar nodos (encima de segmentos)
    for (final nodo in marioneta.nodos) {
      _renderNodo(canvas, nodo);
    }
  }

  void _renderSegmento(Canvas canvas, Nodo origen, Nodo destino) {
    if (origen.segmentoTipo == SegmentoTipo.linea && origen.grosor < 1) return;

    final paint = Paint()
      ..color = origen.color
      ..strokeWidth = origen.grosor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final from = Offset(origen.posicion.x, origen.posicion.y);
    final to = Offset(destino.posicion.x, destino.posicion.y);

    switch (origen.segmentoTipo) {
      case SegmentoTipo.linea:
        canvas.drawLine(from, to, paint);
      case SegmentoTipo.rectangulo:
        final medio = (from + to) / 2;
        final angulo = (to - from).direction;
        canvas.save();
        canvas.translate(medio.dx, medio.dy);
        canvas.rotate(angulo);
        final rect = Rect.fromCenter(
          center: Offset.zero,
          width: origen.grosor,
          height: origen.longitud,
        );
        if (origen.rellenoVisible) {
          canvas.drawRect(rect, Paint()..color = origen.color);
        }
        if (origen.contornoVisible) {
          canvas.drawRect(rect, Paint()
            ..color = origen.colorContorno
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1);
        }
        canvas.restore();
      case SegmentoTipo.triangulo:
        _renderTriangulo(canvas, origen, from, to);
      default:
        canvas.drawLine(from, to, paint);
    }
  }

  void _renderTriangulo(Canvas canvas, Nodo nodo, Offset from, Offset to) {
    final paint = Paint()..color = nodo.color;
    final paintContorno = Paint()
      ..color = nodo.colorContorno
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final dir = to - from;
    final perp = Offset(-dir.dy, dir.dx) * (nodo.grosor / 2 / dir.distance);
    final base = from;
    final tip = to;
    final p1 = base + perp;
    final p2 = base - perp;

    final path = Path()..moveTo(tip.dx, tip.dy)..lineTo(p1.dx, p1.dy)..lineTo(p2.dx, p2.dy)..close();
    if (nodo.rellenoVisible) canvas.drawPath(path, paint);
    if (nodo.contornoVisible) canvas.drawPath(path, paintContorno);
  }

  void _renderPolyfill(Canvas canvas, Polyfill polyfill, Marioneta marioneta) {
    if (polyfill.nodosIds.length < 3) return;
    final path = Path();
    bool first = true;
    for (final nid in polyfill.nodosIds) {
      final nodo = marioneta.obtenerNodo(nid);
      if (nodo == null) continue;
      final p = Offset(nodo.posicion.x, nodo.posicion.y);
      if (first) { path.moveTo(p.dx, p.dy); first = false; }
      else path.lineTo(p.dx, p.dy);
    }
    if (polyfill.cerrado) path.close();
    canvas.drawPath(path, Paint()..color = polyfill.color);
    canvas.drawPath(path, Paint()
      ..color = polyfill.colorContorno
      ..style = PaintingStyle.stroke
      ..strokeWidth = polyfill.grosorContorno);
  }

  void _renderNodo(Canvas canvas, Nodo nodo) {
    final pos = Offset(nodo.posicion.x, nodo.posicion.y);
    final radius = 4.0;
    final paint = Paint();

    switch (nodo.tipo) {
      case NodoTipo.raiz:
        paint.color = Colors.orange;
        canvas.drawCircle(pos, radius + 2, paint);
        canvas.drawCircle(pos, radius + 2, Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5);
      case NodoTipo.normal:
        paint.color = Colors.blue;
        canvas.drawCircle(pos, radius, paint);
      case NodoTipo.estatico:
        paint.color = Colors.grey;
        canvas.drawRect(Rect.fromCenter(center: pos, width: radius*2, height: radius*2), paint);
      case NodoTipo.anguloBloqueado:
        paint.color = Colors.red;
        canvas.drawCircle(pos, radius, paint);
        canvas.drawLine(pos - const Offset(3, 0), pos + const Offset(3, 0), Paint()..color = Colors.white);
      case NodoTipo.arrastreBloqueado:
        paint.color = Colors.purple;
        canvas.drawCircle(pos, radius, paint);
        canvas.drawCircle(pos, radius - 2, Paint()..color = Colors.white);
    }

    // Mostrar nombre si tiene
    if (nodo.nombre.isNotEmpty) {
      final tp = TextPainter(
        text: TextSpan(
          text: nodo.nombre,
          style: const TextStyle(color: Colors.white70, fontSize: 9),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, pos + const Offset(8, -6));
    }
  }
}
