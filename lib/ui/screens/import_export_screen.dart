import 'package:flutter/material.dart';
import '../../core/document/document.dart';
import '../../core/import_export/import_engine.dart';
import '../../core/import_export/stick_nodes_importer.dart';
import '../../core/import_export/pivot_importer.dart';
import '../../core/import_export/flash_importer.dart';
import '../../core/import_export/nspn_exporter.dart';
import '../theme/app_theme.dart';

class ImportExportScreen extends StatelessWidget {
  final NodespenDocument document;

  const ImportExportScreen({super.key, required this.document});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NodespenColors.background,
      appBar: AppBar(
        title: const Text('Importar / Exportar', style: TextStyle(color: NodespenColors.textPrimary, fontSize: 16)),
        backgroundColor: NodespenColors.surface,
        iconTheme: const IconThemeData(color: NodespenColors.textSecondary),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader('Importar'),
          _importCard(context, 'Stick Nodes (.stknds)', Icons.accessibility_new, StickNodesImporter()),
          _importCard(context, 'Pivot Animator (.piv)', Icons.compare_arrows, PivotImporter()),
          _importCard(context, 'Flash (.fla / .xfl)', Icons.movie, FlashImporter()),
          _importCard(context, 'Nodespen (.nspn)', Icons.folder_open, null, isNspn: true),
          const SizedBox(height: 24),
          _sectionHeader('Exportar'),
          _exportCard(context, 'Nodespen (.nspn)', Icons.save, NspnExporter()),
          _exportCard(context, 'Stick Nodes (.stknds)', Icons.share, null, isPlaceholder: true),
          _exportCard(context, 'Pivot (.piv)', Icons.share, null, isPlaceholder: true),
          _exportCard(context, 'PNG imagen', Icons.image, null, isPlaceholder: true),
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
        color: NodespenColors.textSecondary, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 1,
      )),
    );
  }

  Widget _importCard(BuildContext context, String label, IconData icon, FormatImporter? importer, {bool isNspn = false}) {
    return Card(
      color: NodespenColors.surface,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: NodespenColors.accent),
        title: Text(label, style: const TextStyle(color: NodespenColors.textPrimary, fontSize: 13)),
        trailing: const Icon(Icons.upload_file, color: NodespenColors.textSecondary, size: 18),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Importación de $label - selecciona archivo', style: const TextStyle(color: Colors.white))),
          );
        },
      ),
    );
  }

  Widget _exportCard(BuildContext context, String label, IconData icon, FormatExporter? exporter, {bool isPlaceholder = false}) {
    return Card(
      color: isPlaceholder ? NodespenColors.background : NodespenColors.surface,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: isPlaceholder ? NodespenColors.textSecondary.withValues(alpha: 0.5) : NodespenColors.accent),
        title: Text(
          label,
          style: TextStyle(
            color: isPlaceholder ? NodespenColors.textSecondary.withValues(alpha: 0.5) : NodespenColors.textPrimary,
            fontSize: 13,
          ),
        ),
        trailing: Icon(
          isPlaceholder ? Icons.lock : Icons.file_download,
          color: isPlaceholder ? NodespenColors.textSecondary.withValues(alpha: 0.3) : NodespenColors.textSecondary,
          size: 18,
        ),
        onTap: isPlaceholder ? null : () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Exportando $label...', style: const TextStyle(color: Colors.white))),
          );
        },
      ),
    );
  }
}
