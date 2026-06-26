import 'package:flutter/material.dart';
import '../mode.dart';
import '../../core/document/document.dart';
import '../../core/canvas/renderer.dart';

class DrawMode extends Mode {
  @override String get name => 'Dibujo';
  @override String get icon => '✏️';
  @override String get description => 'Modo de dibujo vectorial y raster';
  @override ProjectMode get modeType => ProjectMode.draw;

  @override
  void onActivate(NodespenDocument document) {
    // Inicializar herramientas de dibujo
  }

  @override
  void render(Canvas canvas, Size size, NodespenRenderer renderer) {
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    canvas.drawRect(
      Rect.fromCenter(center: size.center(Offset.zero), width: 100, height: 100),
      paint,
    );
  }
}
