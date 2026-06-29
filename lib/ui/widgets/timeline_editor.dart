import 'package:flutter/material.dart';
import '../../core/document/document.dart';
import '../../core/document/scene.dart';
import '../../core/document/timeline.dart';
import '../../core/document/layer.dart';
import '../../core/document/frame.dart';
import '../../core/animation/playback_controller.dart';
import '../../core/animation/tween_engine.dart';
import '../theme/app_theme.dart';

class TimelineEditor extends StatefulWidget {
  final NodespenDocument document;
  final PlaybackController playback;

  const TimelineEditor({
    super.key,
    required this.document,
    required this.playback,
  });

  @override
  State<TimelineEditor> createState() => _TimelineEditorState();
}

class _TimelineEditorState extends State<TimelineEditor> {
  static const double frameWidth = 24;
  static const double layerHeaderWidth = 120;
  static const double rowHeight = 32;

  late ScrollController _scrollController;
  late TextEditingController _fpsController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _fpsController = TextEditingController(text: '${widget.document.timeline.fps}')
      ..selection = TextSelection.collapsed(offset: '${widget.document.timeline.fps}'.length);
    widget.playback.onFrameChanged = () => setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fpsController.dispose();
    super.dispose();
  }

  int get _frameCount => widget.document.timeline.totalFrames;

  @override
  Widget build(BuildContext context) {
    final timeline = widget.document.timeline;
    final scene = widget.document.activeScene;

    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: NodespenColors.surface,
        border: Border(top: BorderSide(color: NodespenColors.border)),
      ),
      child: Column(
        children: [
          _buildPlaybackControls(timeline),
          Divider(color: NodespenColors.border, height: 1),
          Expanded(
            child: Row(
              children: [
                _buildLayerPanel(scene),
                Container(width: 1, color: NodespenColors.border),
                Expanded(child: _buildFrameGrid(scene, timeline)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _addKeyframe(Timeline timeline) {
    final layer = widget.document.activeScene.activeLayer;
    final existing = layer.frames.where((f) => f.index == timeline.currentFrame).firstOrNull;
    if (existing == null) {
      layer.frames.add(Frame(index: timeline.currentFrame, isKeyframe: true));
      layer.frames.sort((a, b) => a.index.compareTo(b.index));
    }
    final engine = TweenEngine(timeline);
    engine.buildTweensOnFrame(layer.frames);
    setState(() {});
  }

  Widget _buildPlaybackControls(Timeline timeline) {
    final state = widget.playback.state;
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: NodespenColors.background,
        border: Border(bottom: BorderSide(color: NodespenColors.border)),
      ),
      child: Row(
        children: [
          _iconButton(Icons.first_page, 'Principio', () {
            widget.playback.stop();
            setState(() {});
          }),
          _iconButton(Icons.skip_previous, 'Anterior', () {
            timeline.goToFrame(timeline.currentFrame - 1);
            setState(() {});
          }),
          _iconButton(
            state == PlaybackState.playing ? Icons.pause : Icons.play_arrow,
            state == PlaybackState.playing ? 'Pausa' : 'Reproducir',
            () { widget.playback.togglePlayPause(); setState(() {}); },
          ),
          _iconButton(Icons.skip_next, 'Siguiente', () {
            timeline.goToFrame(timeline.currentFrame + 1);
            setState(() {});
          }),
          _iconButton(Icons.last_page, 'Final', () {
            timeline.goToFrame(timeline.endFrame);
            setState(() {});
          }),
          Container(width: 1, height: 20, color: NodespenColors.border, margin: const EdgeInsets.symmetric(horizontal: 8)),
          _iconButton(Icons.keyboard, 'Añadir Keyframe', () => _addKeyframe(timeline)),
          Container(width: 1, height: 20, color: NodespenColors.border, margin: const EdgeInsets.symmetric(horizontal: 8)),
          Text(
            'Frame: ${timeline.currentFrame + 1} / $_frameCount',
            style: const TextStyle(color: NodespenColors.textSecondary, fontSize: 11),
          ),
          Container(width: 1, height: 20, color: NodespenColors.border, margin: const EdgeInsets.symmetric(horizontal: 8)),
          Text('FPS:', style: const TextStyle(color: NodespenColors.textSecondary, fontSize: 11)),
          SizedBox(
            width: 40, height: 22,
            child: TextField(
              controller: _fpsController,
              style: const TextStyle(color: NodespenColors.textPrimary, fontSize: 11),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                border: OutlineInputBorder(borderSide: BorderSide(color: NodespenColors.border)),
              ),
              keyboardType: TextInputType.number,
              onSubmitted: (v) {
                final fps = int.tryParse(v);
                if (fps != null && fps > 0) {
                  timeline.fps = fps;
                  setState(() {});
                }
              },
            ),
          ),
          const Spacer(),
          _iconButton(Icons.add, 'Añadir capa', () {
            widget.document.activeScene.addLayer(Layer(name: 'Capa ${widget.document.activeScene.layers.length + 1}'));
            setState(() {});
          }),
          const SizedBox(width: 4),
          Text(
            '${widget.playback.elapsedMs ~/ 1000}:${(widget.playback.elapsedMs % 1000 ~/ 10).toString().padLeft(2, '0')}',
            style: const TextStyle(color: NodespenColors.textSecondary, fontSize: 11, fontFamily: 'monospace'),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: timeline.looping ? NodespenColors.success : NodespenColors.border,
              borderRadius: BorderRadius.circular(3),
            ),
            child: GestureDetector(
              onTap: () { timeline.looping = !timeline.looping; setState(() {}); },
              child: Text(
                'LOOP',
                style: TextStyle(
                  color: timeline.looping ? Colors.white : NodespenColors.textSecondary,
                  fontSize: 9, fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
            decoration: BoxDecoration(
              color: timeline.onionSkinEnabled ? NodespenColors.accent : NodespenColors.border,
              borderRadius: BorderRadius.circular(3),
            ),
            child: GestureDetector(
              onTap: () { timeline.onionSkinEnabled = !timeline.onionSkinEnabled; setState(() {}); },
              child: Text(
                '☰',
                style: TextStyle(
                  color: timeline.onionSkinEnabled ? Colors.white : NodespenColors.textSecondary,
                  fontSize: 9, fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, String tooltip, VoidCallback onPressed) {
    return SizedBox(
      width: 28, height: 28,
      child: IconButton(
        icon: Icon(icon, size: 16, color: NodespenColors.textSecondary),
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildLayerPanel(Scene scene) {
    return Container(
      width: layerHeaderWidth,
      color: NodespenColors.surface,
      child: Column(
        children: [
          Container(
            height: 18,
            decoration: BoxDecoration(
              color: NodespenColors.background,
              border: Border(bottom: BorderSide(color: NodespenColors.border)),
            ),
            child: const Center(
              child: Text('Capas', style: TextStyle(color: NodespenColors.textSecondary, fontSize: 9, fontWeight: FontWeight.w600)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: scene.layers.length,
              itemBuilder: (context, i) {
                final layer = scene.layers[i];
                final isActive = i == scene.activeLayerIndex;
                return GestureDetector(
                  onTap: () {
                    scene.activeLayerIndex = i;
                    setState(() {});
                  },
                  child: Container(
                    height: rowHeight,
                    decoration: BoxDecoration(
                      color: isActive ? NodespenColors.primary : (i.isOdd ? NodespenColors.background : NodespenColors.surface),
                      border: Border(bottom: BorderSide(color: NodespenColors.border.withValues(alpha: 0.5))),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () { layer.visible = !layer.visible; setState(() {}); },
                          child: Icon(layer.visible ? Icons.visibility : Icons.visibility_off, size: 14, color: NodespenColors.textSecondary),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () { layer.locked = !layer.locked; setState(() {}); },
                          child: Icon(layer.locked ? Icons.lock : Icons.lock_open, size: 12, color: NodespenColors.textSecondary),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(layer.name, overflow: TextOverflow.ellipsis, style: TextStyle(
                            color: isActive ? NodespenColors.textPrimary : NodespenColors.textSecondary,
                            fontSize: 10, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          )),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFrameGrid(Scene scene, Timeline timeline) {
    return GestureDetector(
      onHorizontalDragStart: (d) => _onFrameGridTap(d.localPosition.dx, timeline),
      onHorizontalDragUpdate: (d) => _onFrameGridTap(d.localPosition.dx, timeline),
      onTapDown: (d) => _onFrameGridTap(d.localPosition.dx, timeline),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        child: Column(
          children: [
            _buildFrameHeaders(timeline),
            ...List.generate(scene.layers.length, (i) =>
              _buildLayerFrames(scene.layers[i], timeline, i == scene.activeLayerIndex),
            ),
          ],
        ),
      ),
    );
  }

  void _onFrameGridTap(double dx, Timeline timeline) {
    final col = (dx / frameWidth).floor();
    if (col >= 0 && col < _frameCount) {
      timeline.goToFrame(col);
      setState(() {});
    }
  }

  Widget _buildFrameHeaders(Timeline timeline) {
    return SizedBox(
      height: 18,
      child: Row(
        children: List.generate(_frameCount, (i) {
          final isCurrent = i == timeline.currentFrame;
          return Container(
            width: frameWidth,
            decoration: BoxDecoration(
              color: isCurrent ? NodespenColors.accent.withValues(alpha: 0.3) : null,
              border: Border(
                right: BorderSide(color: NodespenColors.border.withValues(alpha: 0.3)),
                bottom: BorderSide(color: NodespenColors.border),
              ),
            ),
            child: Center(
              child: Text(
                '${i + 1}',
                style: TextStyle(
                  color: isCurrent ? NodespenColors.accent : NodespenColors.textSecondary.withValues(alpha: 0.5),
                  fontSize: 8, fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildLayerFrames(Layer layer, Timeline timeline, bool isActive) {
    return SizedBox(
      height: rowHeight,
      child: Row(
        children: List.generate(_frameCount, (i) {
          final hasKeyframe = layer.frames.any((f) => f.index == i && f.isKeyframe);
          final isCurrent = i == timeline.currentFrame;
          final isInRange = layer.frames.any((f) => f.index <= i && (f.duration + f.index) > i);

          Color bg;
          if (isCurrent && isActive) {
            bg = NodespenColors.accent.withValues(alpha: 0.25);
          } else if (isInRange) {
            bg = NodespenColors.primary.withValues(alpha: 0.3);
          } else {
            bg = Colors.transparent;
          }

          return GestureDetector(
            onTap: () { timeline.goToFrame(i); setState(() {}); },
            onLongPress: hasKeyframe ? () {
              layer.frames.removeWhere((f) => f.index == i && f.isKeyframe);
              setState(() {});
            } : null,
            child: Container(
              width: frameWidth,
              decoration: BoxDecoration(
                color: bg,
                border: Border(
                  right: BorderSide(color: NodespenColors.border.withValues(alpha: 0.2)),
                  bottom: BorderSide(color: NodespenColors.border.withValues(alpha: 0.4)),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  if (hasKeyframe)
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                        color: isCurrent ? NodespenColors.accent : NodespenColors.textSecondary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1),
                      ),
                    ),
                  if (isCurrent && !hasKeyframe && isInRange)
                    Container(
                      width: 4, height: 4,
                      decoration: BoxDecoration(
                        color: NodespenColors.textSecondary.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                    ),
                  if (hasKeyframe && i == timeline.currentFrame)
                    Container(
                      width: frameWidth, height: rowHeight,
                      decoration: BoxDecoration(border: Border.all(color: NodespenColors.accent, width: 1)),
                    ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
