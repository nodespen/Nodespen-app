import 'package:flutter/material.dart';
import '../mode.dart';
import '../../core/document/document.dart';
import '../../core/canvas/renderer.dart';
import '../../core/math/vector2.dart';
import 'tools/draw_tool.dart';
import 'tools/pen_tool.dart';
import 'tools/shape_tool.dart';
import 'tools/eraser_tool.dart';
import 'tools/select_tool.dart';
import 'tools/fill_tool.dart';

class DrawMode extends Mode {
  @override String get name => 'Dibujo';
  @override String get icon => '✏️';
  @override String get description => 'Modo de dibujo vectorial';
  @override ProjectMode get modeType => ProjectMode.draw;

  final DrawingCanvas _canvas = DrawingCanvas();
  DrawTool _currentTool = PenTool();
  final List<DrawTool> _tools = [PenTool(), ShapeTool(), ShapeTool(shapeType: ToolType.circle), ShapeTool(shapeType: ToolType.line), EraserTool(), SelectTool(), FillTool()];

  DrawTool get currentTool => _currentTool;
  DrawingCanvas get canvas => _canvas;
  List<DrawTool> get tools => _tools;
  Color get color => _canvas.currentColor;
  double get strokeWidth => _canvas.strokeWidth;

  set color(Color c) => _canvas.currentColor = c;
  set strokeWidth(double w) => _canvas.strokeWidth = w;

  void setTool(ToolType type) {
    _currentTool.onDeactivate();
    _currentTool = _tools.firstWhere((t) => t.toolType == type);
    _currentTool.onActivate();
  }

  @override
  void onActivate(NodespenDocument document) {
    _currentTool.onActivate();
  }

  @override
  void onDeactivate(NodespenDocument document) {
    _currentTool.onDeactivate();
  }

  @override
  void onTap(Vector2 position, NodespenDocument document) {
    _currentTool.onTap(position, _canvas);
  }

  @override
  void onDragStart(Vector2 position, NodespenDocument document) {
    _currentTool.onDragStart(position, _canvas);
  }

  @override
  void onDragUpdate(Vector2 position, NodespenDocument document) {
    _currentTool.onDragUpdate(position, _canvas);
  }

  @override
  void onDragEnd(Vector2 position, NodespenDocument document) {
    _currentTool.onDragEnd(position, _canvas);
  }

  @override
  void render(Canvas canvas, Size size, NodespenRenderer renderer) {
    for (final element in _canvas.elements) {
      if (!element.visible) continue;
      element.render(canvas);
    }
    _currentTool.renderPreview(canvas, _canvas);
  }

  void clearCanvas() => _canvas.clear();
}
