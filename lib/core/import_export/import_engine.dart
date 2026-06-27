import '../../core/document/document.dart';

enum ImportFormat { stknds, piv, fla, xfl, nspn }

enum ExportFormat { nspn, stknds, piv, png, gif, mp4 }

class ImportResult {
  final bool success;
  final NodespenDocument? document;
  final String? error;

  const ImportResult({this.success = false, this.document, this.error});
}

class ExportResult {
  final bool success;
  final String? filePath;
  final String? error;

  const ExportResult({this.success = false, this.filePath, this.error});
}

abstract class FormatImporter {
  String get formatName;
  ImportFormat get format;
  Future<ImportResult> importFromBytes(List<int> bytes);
}

abstract class FormatExporter {
  String get formatName;
  ExportFormat get format;
  Future<List<int>> exportToBytes(NodespenDocument document);
}
