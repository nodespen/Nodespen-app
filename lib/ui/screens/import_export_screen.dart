import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../core/document/document.dart';
import '../../core/import_export/import_engine.dart';
import '../../core/import_export/stick_nodes_importer.dart';
import '../../core/import_export/pivot_importer.dart';
import '../../core/import_export/flash_importer.dart';
import '../../core/import_export/nspn_exporter.dart';
import '../theme/app_theme.dart';

class ImportExportScreen extends StatelessWidget {
  final NodespenDocument document;
  final ValueChanged<NodespenDocument>? onDocumentLoaded;

  const ImportExportScreen({
    super.key,
    required this.document,
    this.onDocumentLoaded,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NodespenColors.background,
      appBar: AppBar(
        title: const Text('Importar / Exportar',
          style: TextStyle(color: NodespenColors.textPrimary, fontSize: 16)),
        backgroundColor: NodespenColors.surface,
        iconTheme: const IconThemeData(color: NodespenColors.textSecondary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader('Importar'),
          _importCard(context, 'Nodespen (.nspn)', Icons.folder_open, _importNspn),
          _importCard(context, 'Stick Nodes (.stknds)', Icons.accessibility_new, _importStickNodes),
          _importCard(context, 'Pivot Animator (.piv)', Icons.compare_arrows, _importPivot),
          _importCard(context, 'Flash (.fla / .xfl)', Icons.movie, _importFlash),
          const SizedBox(height: 24),
          _sectionHeader('Exportar'),
          _exportCard(context, 'Nodespen (.nspn)', Icons.save, _exportNspn),
          _exportCard(context, 'PNG imagen', Icons.image, _exportPng),
          _exportCard(context, 'GIF animado', Icons.gif, null, isPlaceholder: true),
          _exportCard(context, 'MP4 video', Icons.videocam, null, isPlaceholder: true),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: const TextStyle(
        color: NodespenColors.textSecondary, fontSize: 13,
        fontWeight: FontWeight.w600, letterSpacing: 1,
      )),
    );
  }

  Widget _importCard(BuildContext context, String label, IconData icon, VoidCallback? onTap) {
    return Card(
      color: NodespenColors.surface,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: NodespenColors.accent),
        title: Text(label, style: const TextStyle(color: NodespenColors.textPrimary, fontSize: 13)),
        trailing: const Icon(Icons.upload_file, color: NodespenColors.textSecondary, size: 18),
        onTap: onTap,
      ),
    );
  }

  Widget _exportCard(BuildContext context, String label, IconData icon, VoidCallback? onTap,
      {bool isPlaceholder = false}) {
    return Card(
      color: isPlaceholder ? NodespenColors.background : NodespenColors.surface,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon,
          color: isPlaceholder
            ? NodespenColors.textSecondary.withValues(alpha: 0.5)
            : NodespenColors.accent),
        title: Text(label,
          style: TextStyle(
            color: isPlaceholder
              ? NodespenColors.textSecondary.withValues(alpha: 0.5)
              : NodespenColors.textPrimary,
            fontSize: 13,
          )),
        trailing: Icon(
          isPlaceholder ? Icons.lock : Icons.file_download,
          color: isPlaceholder
            ? NodespenColors.textSecondary.withValues(alpha: 0.3)
            : NodespenColors.textSecondary,
          size: 18,
        ),
        onTap: isPlaceholder ? null : onTap,
      ),
    );
  }

  Future<void> _importNspn() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['nspn'],
    );
    if (result == null || result.files.isEmpty) return;
    final file = File(result.files.single.path!);
    final bytes = await file.readAsBytes();
    final importer = NspnImporter();
    final importResult = await importer.importFromBytes(bytes);
    if (importResult.success && importResult.document != null) {
      onDocumentLoaded?.call(importResult.document!);
    }
  }

  Future<void> _importStickNodes() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['stknds', 'nodes', 'nodemc'],
    );
    if (result == null || result.files.isEmpty) return;
    final file = File(result.files.single.path!);
    final bytes = await file.readAsBytes();
    final importer = StickNodesImporter();
    await importer.importFromBytes(bytes);
  }

  Future<void> _importPivot() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['piv', 'stk'],
    );
    if (result == null || result.files.isEmpty) return;
    final file = File(result.files.single.path!);
    final bytes = await file.readAsBytes();
    final importer = PivotImporter();
    await importer.importFromBytes(bytes);
  }

  Future<void> _importFlash() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['fla', 'xfl'],
    );
    if (result == null || result.files.isEmpty) return;
    final file = File(result.files.single.path!);
    final bytes = await file.readAsBytes();
    final importer = FlashImporter();
    await importer.importFromBytes(bytes);
  }

  Future<void> _exportNspn() async {
    final result = await FilePicker.platform.saveFile(
      type: FileType.custom,
      allowedExtensions: ['nspn'],
      fileName: '${document.name}.nspn',
    );
    if (result == null) return;
    final exporter = NspnExporter();
    final bytes = await exporter.exportToBytes(document);
    await File(result).writeAsBytes(bytes);
  }

  Future<void> _exportPng() async {
    final result = await FilePicker.platform.saveFile(
      type: FileType.custom,
      allowedExtensions: ['png'],
      fileName: '${document.name}.png',
    );
    if (result == null) return;
  }
}
