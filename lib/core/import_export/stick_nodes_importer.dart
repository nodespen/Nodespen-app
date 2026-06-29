import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/document/document.dart';
import '../../core/document/layer.dart';
import '../../core/math/vector2.dart';
import '../../modes/node/models/marioneta.dart';
import '../../modes/node/models/nodo.dart';
import '../../modes/node/models/segmento.dart';
import 'import_engine.dart';

class StickNodesImporter extends FormatImporter {
  @override String get formatName => 'Stick Nodes (.stknds)';
  @override ImportFormat get format => ImportFormat.stknds;

  @override
  Future<ImportResult> importFromBytes(List<int> bytes) async {
    try {
      final content = utf8.decode(bytes);
      return _parseStickNodesXml(content);
    } catch (e) {
      return ImportResult(error: 'Error parseando .stknds: $e');
    }
  }

  Future<ImportResult> _parseStickNodesXml(String xml) async {
    final doc = NodespenDocument(name: 'Importado Stick Nodes');

    final marioneta = Marioneta(nombre: 'Stick Figure');
    final regex = RegExp(
      r'<node[^>]*id="(\d+)"[^>]*x="([\d.-]+)"[^>]*y="([\d.-]+)"[^>]*>'
      r'\s*<color[^>]*r="([\d.]+)"[^>]*g="([\d.]+)"[^>]*b="([\d.]+)"[^>]*/>'
      r'\s*<size[^>]*>([\d.]+)</size>',
    );
    final nodeMap = <String, String>{};

    for (final match in regex.allMatches(xml)) {
      final id = match.group(1)!;
      final x = double.parse(match.group(2)!);
      final y = double.parse(match.group(3)!);
      final r = (double.parse(match.group(4)!) * 255).round();
      final g = (double.parse(match.group(5)!) * 255).round();
      final b = (double.parse(match.group(6)!) * 255).round();
      final size = double.parse(match.group(7)!);

      final nodo = Nodo(
        nombre: 'Node $id',
        posicion: Vector2(x, y),
        posicionLocal: Vector2(x, y),
        color: Color.fromARGB(255, r, g, b),
        grosor: size,
        longitud: 30,
      );
      marioneta.agregarNodo(nodo);
      nodeMap[id] = nodo.id;
    }

    final segRegex = RegExp(
      r'<segment[^>]*node1="(\d+)"[^>]*node2="(\d+)"[^>]*/>',
    );
    for (final match in segRegex.allMatches(xml)) {
      final n1 = nodeMap[match.group(1)!];
      final n2 = nodeMap[match.group(2)!];
      if (n1 != null && n2 != null) {
        marioneta.agregarSegmento(Segmento(
          nodoOrigenId: n1,
          nodoDestinoId: n2,
          nombre: 'Seg $n1-$n2',
        ));
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
  }
}
