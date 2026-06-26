import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../math/vector2.dart';
import '../document/document.dart';
import '../document/layer.dart';

class NodespenRenderer {
  final NodespenDocument document;
  late Matrix3 viewMatrix;
  Rect visibleBounds;

  NodespenRenderer(this.document)
    : viewMatrix = Matrix3.identity(),
      visibleBounds = Rect.zero;

  void updateViewMatrix() {
    final cam = document.camera;
    if (cam.isEnabled) {
      viewMatrix = cam.viewMatrix;
    } else {
      viewMatrix = Matrix3.identity();
    }
  }

  void renderScene(Canvas canvas, Size size) {
    updateViewMatrix();
    visibleBounds = Rect.fromLTWH(0, 0, size.width, size.height);

    final scene = document.activeScene;

    for (var i = 0; i < scene.layers.length; i++) {
      final layer = scene.layers[i];
      if (!layer.visible) continue;

      canvas.save();
      canvas.translate(size.width / 2, size.height / 2);
      _applyMatrixToCanvas(canvas, viewMatrix);
      canvas.translate(-size.width / 2, -size.height / 2);

      canvas.saveLayer(null, Paint()..color = Color.fromRGBO(0, 0, 0, layer.opacity));
      renderLayer(canvas, layer, size);
      canvas.restore();
      canvas.restore();
    }
  }

  void renderLayer(Canvas canvas, Layer layer, Size size) {
    switch (layer.contentType) {
      case ContentType.draw:
        _renderDrawContent(canvas, layer);
      case ContentType.node:
        _renderNodeContent(canvas, layer);
      case ContentType.gacha:
        _renderGachaContent(canvas, layer);
    }
  }

  void _renderDrawContent(Canvas canvas, Layer layer) {
    // Placeholder: se implementará en Fase 2
  }

  void _renderNodeContent(Canvas canvas, Layer layer) {
    // Placeholder: se implementará en Fase 3
  }

  void _renderGachaContent(Canvas canvas, Layer layer) {
    // Placeholder: se implementará en Fase 4
  }

  void _applyMatrixToCanvas(Canvas canvas, Matrix3 matrix) {
    final storage = matrix.storage;
    canvas.transform(Float64List.fromList([
      storage[0], storage[3], 0, storage[2],
      storage[1], storage[4], 0, storage[5],
      0, 0, 1, 0,
      0, 0, 0, 1,
    ]));
  }
}
