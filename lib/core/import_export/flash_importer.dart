import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/document/document.dart';
import '../../core/document/scene.dart';
import '../../core/document/layer.dart';
import '../../core/document/frame.dart';
import '../../core/document/timeline.dart';
import '../../core/math/vector2.dart';
import '../../modes/draw/models/drawing_element.dart';
import 'import_engine.dart';

class FlashImporter extends FormatImporter {
  @override String get formatName => 'Flash (.fla/.xfl)';
  @override ImportFormat get format => ImportFormat.fla;

  @override
  Future<ImportResult> import(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      return importFromBytes(bytes);
    } catch (e) {
      return ImportResult(error: 'Error leyendo archivo: $e');
    }
  }

  @override
  Future<ImportResult> importFromBytes(List<int> bytes) async {
    try {
      final xml = utf8.decode(bytes);
      return _parseFlashXml(xml);
    } catch (e) {
      return ImportResult(error: 'Error parseando Flash: $e');
    }
  }

  Future<ImportResult> _parseFlashXml(String xml) async {
    final doc = NodespenDocument(name: 'Importado Flash');
    final scene = doc.activeScene;
    final layer = scene.activeLayer;
    layer.contentType = ContentType.draw;

    final elements = <DrawingElement>[];

    final strokeRegex = RegExp(
      r'<Edge[^>]*strokeWidth="([\d.]+)"[^>]*color="#([0-9A-Fa-f]+)"[^>]*>'
      r'\s*<Point[^>]*x="([\d.]+)"[^>]*y="([\d.]+)"[^>]*/>'
      r'(.*?)</Edge>',
      dotAll: true,
    );

    for (final match in strokeRegex.allMatches(xml)) {
      final sw = double.tryParse(match.group(1)!) ?? 2;
      final hex = match.group(2)!;
      final color = Color(int.parse('FF$hex', radix: 16));

      final points = <Vector2>[];
      final pointRegex = RegExp(r'x="([\d.]+)"[^>]*y="([\d.]+)"');
      for (final pm in pointRegex.allMatches(match.group(0)!)) {
        points.add(Vector2(
          double.tryParse(pm.group(1)!) ?? 0,
          double.tryParse(pm.group(2)!) ?? 0,
        ));
      }

      if (points.isNotEmpty) {
        elements.add(StrokeElement(
          points: points,
          color: color,
          strokeWidth: sw,
        ));
      }
    }

    final rectRegex = RegExp(
      r'<Rectangle[^>]*x="([\d.]+)"[^>]*y="([\d.]+)"[^>]*'
      r'width="([\d.]+)"[^>]*height="([\d.]+)"[^>]*'
      r'fillColor="#([0-9A-Fa-f]+)"[^>]*/>',
    );
    for (final match in rectRegex.allMatches(xml)) {
      final x = double.tryParse(match.group(1)!) ?? 0;
      final y = double.tryParse(match.group(2)!) ?? 0;
      final w = double.tryParse(match.group(3)!) ?? 0;
      final h = double.tryParse(match.group(4)!) ?? 0;
      final hex = match.group(5)!;
      final color = Color(int.parse('FF$hex', radix: 16));
      elements.add(RectElement(
        center: Vector2(x + w / 2, y + h / 2),
        width: w,
        height: h,
        color: color,
        strokeWidth: 1,
      ));
    }

    layer.frames.first.content['elements'] = elements.map((e) => e.toJson()).toList();

    return ImportResult(success: true, document: doc);
  }
}
