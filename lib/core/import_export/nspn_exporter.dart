import 'dart:convert';
import 'dart:io';
import 'package:archive/archive.dart';
import '../../core/document/document.dart';
import 'import_engine.dart';

class NspnExporter extends FormatExporter {
  @override String get formatName => 'Nodespen (.nspn)';
  @override ExportFormat get format => ExportFormat.nspn;

  @override
  Future<ExportResult> export(NodespenDocument document, String outputPath) async {
    try {
      final bytes = await exportToBytes(document);
      await File(outputPath).writeAsBytes(bytes);
      return ExportResult(success: true, filePath: outputPath);
    } catch (e) {
      return ExportResult(error: 'Error exportando: $e');
    }
  }

  @override
  Future<List<int>> exportToBytes(NodespenDocument document) async {
    final json = jsonEncode(document.toJson());
    final jsonBytes = utf8.encode(json);
    final compressed = GZipEncoder().encode(jsonBytes) ?? <int>[];
    final header = utf8.encode('NSPN0002');
    return [...header, ...compressed];
  }
}

class NspnImporter {
  Future<ImportResult> importFromBytes(List<int> bytes) async {
    try {
      final raw = utf8.decode(bytes.sublist(0, 8));
      if (!raw.startsWith('NSPN')) {
        return ImportResult(error: 'Formato .nspn inválido');
      }
      final compressed = bytes.sublist(8);
      final decompressed = GZipDecoder().decodeBytes(compressed);
      final json = utf8.decode(decompressed);
      final doc = NodespenDocument.fromJson(jsonDecode(json));
      return ImportResult(success: true, document: doc);
    } catch (e) {
      return ImportResult(error: 'Error importando .nspn: $e');
    }
  }
}
