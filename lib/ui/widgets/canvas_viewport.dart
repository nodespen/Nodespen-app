import 'package:flutter/material.dart';
import '../../modes/mode_manager.dart';
import '../../modes/mode.dart';
import '../../core/canvas/renderer.dart';
import '../../core/document/document.dart';
import '../../core/math/vector2.dart' show Vector2;
import '../theme/app_theme.dart';

class CanvasViewport extends StatefulWidget {
  final ModeManager modeManager;
  final NodespenDocument document;

  const CanvasViewport({
    super.key,
    required this.modeManager,
    required this.document,
  });

  @override
  State<CanvasViewport> createState() => _CanvasViewportState();
}

class _CanvasViewportState extends State<CanvasViewport> {
  late NodespenRenderer _renderer;
  Offset _lastPanPosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _renderer = NodespenRenderer(widget.document);
  }

  @override
  void didUpdateWidget(CanvasViewport oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.document != widget.document) {
      _renderer = NodespenRenderer(widget.document);
    }
  }

  void _onScaleStart(ScaleStartDetails details) {
    _lastPanPosition = details.focalPoint;
    final canvasPos = _screenToCanvas(details.focalPoint);
    widget.modeManager.dragStart(canvasPos);
  }

  void _onScaleUpdate(ScaleUpdateDetails details) {
    if (details.pointerCount == 1) {
      final delta = details.focalPoint - _lastPanPosition;
      widget.document.camera.pan(Vector2(delta.dx, delta.dy));
      _lastPanPosition = details.focalPoint;
    } else if (details.pointerCount >= 2) {
      widget.document.camera.zoomTo(
        details.scale,
        _screenToCanvas(details.focalPoint),
      );
    }
    setState(() {});
  }

  void _onScaleEnd(ScaleEndDetails details) {
    final canvasPos = _screenToCanvas(_lastPanPosition);
    widget.modeManager.dragEnd(canvasPos);
  }

  void _onTapUp(TapUpDetails details) {
    final canvasPos = _screenToCanvas(details.localPosition);
    widget.modeManager.tap(canvasPos);
    setState(() {});
  }

  Vector2 _screenToCanvas(Offset screenPos) {
    final center = Offset(
      context.size?.width ?? 0 / 2,
      context.size?.height ?? 0 / 2,
    );
    final relative = screenPos - center;
    final zoom = widget.document.camera.zoom;
    return Vector2(relative.dx / zoom, relative.dy / zoom);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: _onScaleStart,
      onScaleUpdate: _onScaleUpdate,
      onScaleEnd: _onScaleEnd,
      onTapUp: _onTapUp,
      child: Container(
        decoration: BoxDecoration(
          color: NodespenColors.background,
          border: Border.all(color: NodespenColors.border),
        ),
        child: ClipRect(
          child: CustomPaint(
            painter: _CanvasPainter(
              mode: widget.modeManager.activeMode,
              renderer: _renderer,
            ),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }
}

class _CanvasPainter extends CustomPainter {
  final Mode? mode;
  final NodespenRenderer renderer;

  _CanvasPainter({required this.mode, required this.renderer});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = NodespenColors.background,
    );

    final gridPaint = Paint()
      ..color = NodespenColors.border.withValues(alpha: 0.3)
      ..strokeWidth = 0.5;
    for (var x = 0.0; x < size.width; x += 50) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var y = 0.0; y < size.height; y += 50) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    canvas.save();
    final center = size.center(Offset.zero);
    canvas.translate(center.dx, center.dy);
    canvas.scale(renderer.document.camera.zoom);
    canvas.translate(-center.dx, -center.dy);

    mode?.render(canvas, size, renderer);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CanvasPainter oldDelegate) => true;
}
