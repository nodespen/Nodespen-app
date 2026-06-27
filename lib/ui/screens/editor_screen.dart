import 'package:flutter/material.dart';
import '../../modes/mode_manager.dart';
import '../../modes/node/node_mode.dart';
import '../../modes/draw/draw_mode.dart';
import '../../modes/draw/tools/draw_tool.dart';
import '../../modes/node/tools/node_tool.dart' show NodeToolType;
import '../../modes/gacha/gacha_mode.dart';
import '../../modes/gacha/models/clothing_item.dart' show ClothingCategory;
import '../../modes/gacha/tools/gacha_tool.dart' show GachaToolType;
import '../../core/animation/playback_controller.dart';
import '../../core/document/document.dart';
import '../theme/app_theme.dart';
import '../widgets/mode_selector.dart';
import '../widgets/canvas_viewport.dart';
import '../widgets/timeline_editor.dart';
import 'import_export_screen.dart';
import 'settings_screen.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({super.key});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late NodespenDocument _document;
  late ModeManager _modeManager;
  late PlaybackController _playback;

  @override
  void initState() {
    super.initState();
    _document = NodespenDocument(name: 'Mi proyecto');
    _modeManager = ModeManager(_document);
    _playback = PlaybackController(_document);
    _modeManager.registerMode(DrawMode());
    _modeManager.registerMode(NodeMode());
    _modeManager.registerMode(GachaMode());
    _modeManager.switchTo(ProjectMode.draw);
    _modeManager.addListener(_onModeChanged);
  }

  void _onModeChanged() => setState(() {});
  bool get _isNodeMode => _modeManager.activeMode?.modeType == ProjectMode.node;
  bool get _isDrawMode => _modeManager.activeMode?.modeType == ProjectMode.draw;
  bool get _isGachaMode => _modeManager.activeMode?.modeType == ProjectMode.gacha;

  @override
  void dispose() {
    _modeManager.removeListener(_onModeChanged);
    _modeManager.dispose();
    _playback.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NodespenColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildToolBar(),
          Expanded(
            child: Row(
              children: [
                _buildLeftToolbar(),
                Expanded(
                  child: CanvasViewport(
                    modeManager: _modeManager,
                    document: _document,
                    playback: _playback,
                  ),
                ),
                _buildRightPanel(),
              ],
            ),
          ),
          _buildTimeline(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        _document.name,
        style: const TextStyle(
          color: NodespenColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.undo, color: NodespenColors.textSecondary),
          onPressed: () {},
          tooltip: 'Deshacer',
        ),
        IconButton(
          icon: const Icon(Icons.redo, color: NodespenColors.textSecondary),
          onPressed: () {},
          tooltip: 'Rehacer',
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.share, color: NodespenColors.textSecondary),
          onPressed: () {},
          tooltip: 'Colab Mode',
        ),
        IconButton(
          icon: const Icon(Icons.cloud_upload, color: NodespenColors.textSecondary),
          onPressed: () {},
          tooltip: 'Guardar en nube',
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.play_arrow, color: NodespenColors.success),
          onPressed: () {},
          tooltip: 'Reproducir',
        ),
        IconButton(
          icon: const Icon(Icons.import_export, color: NodespenColors.textSecondary),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ImportExportScreen(document: _document)),
            );
          },
          tooltip: 'Importar/Exportar',
        ),
        IconButton(
          icon: const Icon(Icons.settings, color: NodespenColors.textSecondary),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SettingsScreen()),
            );
          },
          tooltip: 'Ajustes',
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  Widget _buildToolBar() {
    final mode = _modeManager.activeMode;
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: NodespenColors.surface,
        border: Border(
          bottom: BorderSide(color: NodespenColors.border),
        ),
      ),
      child: Row(
        children: [
          ModeSelector(modeManager: _modeManager),
          const SizedBox(width: 12),
          Container(height: 24, width: 1, color: NodespenColors.border),
          const SizedBox(width: 12),
          if (_isDrawMode && mode is DrawMode) ...[
            for (final tool in mode.tools)
              _toolChip(tool.icon, tool.name, active: mode.currentTool.toolType == tool.toolType, onTap: () => mode.setTool(tool.toolType)),
          ],
          if (_isNodeMode && mode is NodeMode) ...[
            for (final tool in mode.tools)
              _toolChip(tool.icon, tool.name, active: mode.currentTool.toolType == tool.toolType, onTap: () => mode.setTool(tool.toolType)),
          ],
          if (_isGachaMode && mode is GachaMode) ...[
            for (final tool in mode.tools)
              _toolChip(tool.icon, tool.name, active: mode.currentTool.toolType == tool.toolType, onTap: () => mode.setTool(tool.toolType)),
          ],
        ],
      ),
    );
  }

  Widget _toolChip(String icon, String label, {bool active = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: GestureDetector(
        onTap: onTap,
        child: Chip(
          avatar: Text(icon, style: const TextStyle(fontSize: 14)),
          label: Text(label, style: const TextStyle(fontSize: 11, color: NodespenColors.textSecondary)),
          backgroundColor: active ? NodespenColors.primary : NodespenColors.background,
          side: BorderSide(color: active ? NodespenColors.accent : NodespenColors.border.withValues(alpha: 0.5)),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
      ),
    );
  }

  Widget _buildLeftToolbar() {
    final mode = _modeManager.activeMode;
    return Container(
      width: 48,
      decoration: BoxDecoration(
        color: NodespenColors.surface,
        border: Border(
          right: BorderSide(color: NodespenColors.border),
        ),
      ),
      child: Column(
        children: (_isNodeMode && mode is NodeMode)
          ? [
              _toolButton(Icons.touch_app, 'Seleccionar', active: mode.currentTool.toolType == NodeToolType.select, onPressed: () => mode.setTool(NodeToolType.select)),
              _toolButton(Icons.add_circle_outline, 'Añadir nodo', active: mode.currentTool.toolType == NodeToolType.addNode, onPressed: () => mode.setTool(NodeToolType.addNode)),
              _toolButton(Icons.link, 'Añadir segmento', active: mode.currentTool.toolType == NodeToolType.addSegment, onPressed: () => mode.setTool(NodeToolType.addSegment)),
              _toolButton(Icons.remove_circle_outline, 'Eliminar', active: mode.currentTool.toolType == NodeToolType.delete, onPressed: () => mode.setTool(NodeToolType.delete)),
              const Spacer(),
              _toolButton(Icons.settings, 'Ajustes'),
            ]
          : (_isDrawMode && mode is DrawMode
            ? [
                _toolButton(Icons.edit, 'Lápiz', active: mode.currentTool.toolType == ToolType.pen, onPressed: () => mode.setTool(ToolType.pen)),
                _toolButton(Icons.brush, 'Borrador', active: mode.currentTool.toolType == ToolType.eraser, onPressed: () => mode.setTool(ToolType.eraser)),
                _toolButton(Icons.crop_square, 'Rectángulo', active: mode.currentTool.toolType == ToolType.rect, onPressed: () => mode.setTool(ToolType.rect)),
                _toolButton(Icons.circle_outlined, 'Círculo', active: mode.currentTool.toolType == ToolType.circle, onPressed: () => mode.setTool(ToolType.circle)),
                _toolButton(Icons.show_chart, 'Línea', active: mode.currentTool.toolType == ToolType.line, onPressed: () => mode.setTool(ToolType.line)),
                _toolButton(Icons.delete_sweep, 'Limpiar', onPressed: () => mode.clearCanvas()),
                const Spacer(),
                _toolButton(Icons.settings, 'Ajustes'),
              ]
            : (_isGachaMode && mode is GachaMode
              ? [
                  _toolButton(Icons.accessibility_new, 'Pose', active: mode.currentTool.toolType == GachaToolType.pose, onPressed: () => mode.setTool(GachaToolType.pose)),
                  _toolButton(Icons.checkroom, 'Vestir', active: mode.currentTool.toolType == GachaToolType.dress, onPressed: () => mode.setTool(GachaToolType.dress)),
                  _toolButton(Icons.palette, 'Color', active: mode.currentTool.toolType == GachaToolType.color, onPressed: () => mode.setTool(GachaToolType.color)),
                  const Spacer(),
                  _toolButton(Icons.settings, 'Ajustes'),
                ]
              : [
                  _toolButton(Icons.pan_tool, 'Seleccionar'),
                  const Spacer(),
                  _toolButton(Icons.settings, 'Ajustes'),
                ])),
      ),
    );
  }

  Widget _toolButton(IconData icon, String tooltip, {bool active = false, VoidCallback? onPressed}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Tooltip(
        message: tooltip,
        child: IconButton(
          icon: Icon(icon, size: 20, color: active ? NodespenColors.accent : NodespenColors.textSecondary),
          onPressed: onPressed ?? () {},
        ),
      ),
    );
  }

  Widget _buildRightPanel() {
    return Container(
      width: 240,
      decoration: BoxDecoration(
        color: NodespenColors.surface,
        border: Border(
          left: BorderSide(color: NodespenColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Propiedades',
              style: TextStyle(
                color: NodespenColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1,
              ),
            ),
          ),
          Divider(color: NodespenColors.border, height: 1),
          Expanded(
            child: _isNodeMode
              ? _buildNodeProperties()
              : (_isDrawMode && _modeManager.activeMode is DrawMode)
                ? _buildDrawProperties(_modeManager.activeMode as DrawMode)
                : (_isGachaMode && _modeManager.activeMode is GachaMode)
                  ? _buildGachaProperties(_modeManager.activeMode as GachaMode)
                  : _buildGenericProperties(),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawProperties(DrawMode drawMode) {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _propSection('Herramienta: ${drawMode.currentTool.name}'),
        const SizedBox(height: 12),
        _propSection('Color'),
        _colorPicker(drawMode),
        const SizedBox(height: 12),
        _propSection('Grosor: ${drawMode.strokeWidth.toStringAsFixed(0)}px'),
        Slider(
          value: drawMode.strokeWidth.clamp(1, 50),
          min: 1, max: 50,
          activeColor: NodespenColors.accent,
          inactiveColor: NodespenColors.border,
          onChanged: (v) { drawMode.strokeWidth = v; setState(() {}); },
        ),
        const SizedBox(height: 12),
        Divider(color: NodespenColors.border, height: 1),
        const SizedBox(height: 8),
        _propSection('Elementos: ${drawMode.canvas.elements.length}'),
        const SizedBox(height: 12),
        TextButton.icon(
          onPressed: () { drawMode.clearCanvas(); setState(() {}); },
          icon: const Icon(Icons.delete_sweep, size: 16, color: NodespenColors.error),
          label: const Text('Limpiar todo', style: TextStyle(fontSize: 11, color: NodespenColors.error)),
        ),
      ],
    );
  }

  Widget _colorPicker(DrawMode drawMode) {
    final colors = [
      Colors.white, Colors.red, Colors.orange, Colors.yellow,
      Colors.green, Colors.cyan, Colors.blue, Colors.purple,
      Colors.pink, Colors.brown, Colors.grey, Colors.black,
    ];
    return Wrap(
      spacing: 6, runSpacing: 6,
      children: colors.map((c) => GestureDetector(
        onTap: () { drawMode.color = c; setState(() {}); },
        child: Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
            color: c,
            shape: BoxShape.circle,
            border: Border.all(
              color: drawMode.color == c ? NodespenColors.accent : NodespenColors.border,
              width: drawMode.color == c ? 2.5 : 1,
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildGachaProperties(GachaMode mode) {
    final char = mode.character;
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _propSection('Personaje: ${char.name}'),
        _propRow('Partes', '${char.bodyParts.length}'),
        _propRow('Equipado', '${char.wornItems.length} piezas'),
        _propRow('Inventario', '${char.inventory.length} ítems'),
        const SizedBox(height: 12),
        Divider(color: NodespenColors.border, height: 1),
        const SizedBox(height: 8),
        _propSection('Vestuario'),
        for (final cat in ClothingCategory.values) ...[
          if (char.inventory.any((i) => i.category == cat))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      cat.name,
                      style: TextStyle(color: NodespenColors.textSecondary, fontSize: 11),
                    ),
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 80, height: 24,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        foregroundColor: NodespenColors.accent,
                        textStyle: const TextStyle(fontSize: 10),
                      ),
                      onPressed: () {
                        final equipped = char.getEquipped(cat);
                        if (equipped != null) {
                          mode.unequipCategory(cat);
                        } else {
                          final item = char.inventory.where((i) => i.category == cat).first;
                          mode.equipItem(item);
                        }
                        setState(() {});
                      },
                      child: Text(char.isEquipped(cat) ? 'Quitar' : 'Poner'),
                    ),
                  ),
                ],
              ),
            ),
        ],
        const SizedBox(height: 12),
        Divider(color: NodespenColors.border, height: 1),
        const SizedBox(height: 8),
        _propSection('Herramienta: ${mode.currentTool.name}'),
        if (mode.currentTool.toolType == GachaToolType.pose)
          _propRow('Arrastra partes', 'para posar'),
        if (mode.currentTool.toolType == GachaToolType.dress)
          _propRow('Toca categoría', 'cambia la prenda'),
        if (mode.currentTool.toolType == GachaToolType.color)
          _propRow('Toca parte', 'cambia su color'),
      ],
    );
  }

  Widget _buildNodeProperties() {
    final mode = _modeManager.activeMode;
    if (mode is! NodeMode) return _buildGenericProperties();
    final pencil = mode.pencil;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        _propSection('Marioneta: ${pencil.nombre}'),
        _propRow('Nodos', '${pencil.nodos.length}'),
        _propRow('Segmentos', '${pencil.segmentos.length}'),
        _propRow('Raíz', pencil.nodoRaiz?.nombre ?? '—'),
        const SizedBox(height: 12),
        Divider(color: NodespenColors.border, height: 1),
        const SizedBox(height: 8),
        _propSection('Mangos de control'),
        _propRow('Mango A (arrastrar)', 'Cerca del borrador'),
        _propRow('Mango B (rotar)', 'Cerca de la punta'),
        const SizedBox(height: 12),
        Divider(color: NodespenColors.border, height: 1),
        const SizedBox(height: 8),
        _propSection('Información'),
        _propRow('Escala', '1.0x'),
        _propRow('Rotación', '0°'),
        _propRow('Visible', 'Sí'),
        if (pencil.reels.isNotEmpty) ...[
          const SizedBox(height: 12),
          Divider(color: NodespenColors.border, height: 1),
          const SizedBox(height: 8),
          _propSection('Reels (${pencil.reels.length})'),
          for (final reel in pencil.reels)
            _propRow(reel.nombre, '${reel.frames.length} frames'),
        ],
      ],
    );
  }

  Widget _buildGenericProperties() {
    return Center(
      child: Text(
        'Selecciona un elemento',
        style: TextStyle(color: NodespenColors.textSecondary.withValues(alpha: 0.5)),
      ),
    );
  }

  Widget _propSection(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title,
        style: TextStyle(
          color: NodespenColors.textPrimary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _propRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: NodespenColors.textSecondary, fontSize: 11)),
          Text(value, style: TextStyle(color: NodespenColors.textPrimary, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return TimelineEditor(
      document: _document,
      playback: _playback,
    );
  }
}
