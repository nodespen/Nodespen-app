import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/document/document.dart';
import '../../core/document/scene.dart';
import '../../core/document/layer.dart';
import '../../core/document/frame.dart';
import '../../core/math/vector2.dart';
import '../../modes/node/models/marioneta.dart';
import '../../modes/node/models/nodo.dart';
import '../../modes/node/models/segmento.dart';
import 'import_engine.dart';

class PivotImporter extends FormatImporter {
  @override String get formatName => 'Pivot Animator (.piv)';
  @override ImportFormat get format => ImportFormat.piv;

  @override
  Future<ImportResult> import(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      return importFromBytes(bytes);
    } catch (e) {
      return ImportResult(error: 'Error leyendo .piv: $e');
    }
  }

  @override
  Future<ImportResult> importFromBytes(List<int> bytes) async {
    try {
      final doc = NodespenDocument(name: 'Importado Pivot');
      final marioneta = Marioneta(nombre: 'Pivot Figure');

      var offset = 0;
      if (bytes.length < 4) return ImportResult(error: 'Archivo demasiado corto');

      final figureCount = bytes[offset++];
      if (figureCount == 0) return ImportResult(error: 'Sin figuras');

      final nodeCount = bytes[offset++];
      final segCount = bytes[offset++];

      final nodeIds = <int>[];
      for (var i = 0; i < nodeCount && offset + 9 <= bytes.length; i++) {
        final x = bytes[offset] + bytes[offset + 1] * 256;
        final y = bytes[offset + 2] + bytes[offset + 3] * 256;
        final r = bytes[offset + 4];
        final g = bytes[offset + 5];
        final b = bytes[offset + 6];
        final size = bytes[offset + 7];
        final parent = bytes[offset + 8];
        offset += 9;

        final nodo = Nodo(
          nombre: 'Nodo $i',
          posicion: Vector2(x.toDouble(), y.toDouble()),
          posicionLocal: Vector2(x.toDouble(), y.toDouble()),
          color: Color.fromARGB(255, r, g, b),
          grosor: size.toDouble(),
          longitud: 30,
        );
        marioneta.agregarNodo(nodo);
        nodeIds.add(parent);
      }

      for (var i = 0; i < nodeIds.length; i++) {
        if (nodeIds[i] < nodeIds.length) {
          final parentId = nodeIds[i];
          if (parentId >= 0 && parentId < marioneta.nodos.length && parentId != i) {
            marioneta.agregarSegmento(Segmento(
              nodoOrigenId: marioneta.nodos[parentId].id,
              nodoDestinoId: marioneta.nodos[i].id,
              nombre: 'Seg $parentId-$i',
            ));
          }
        }
      }

      if (marioneta.nodos.isNotEmpty) {
        marioneta.nodos.first.tipo = NodoTipo.raiz;
        marioneta.nodoRaizId = marioneta.nodos.first.id;
      }

      final scene = doc.activeScene;
      final layer = scene.activeLayer;
      layer.frames.first.content['marioneta'] = marioneta.toJson();
      layer.contentType = ContentType.node;

      return ImportResult(success: true, document: doc);
    } catch (e) {
      return ImportResult(error: 'Error parseando .piv: $e');
    }
  }
}
