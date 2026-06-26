import 'package:flutter/material.dart';
import '../core/document/document.dart';
import 'mode.dart';

class ModeManager extends ChangeNotifier {
  final NodespenDocument document;
  final Map<ProjectMode, Mode> _modes = {};
  Mode? _activeMode;

  ModeManager(this.document);

  void registerMode(Mode mode) {
    _modes[mode.modeType] = mode;
  }

  Mode? get activeMode => _activeMode;
  List<Mode> get allModes => _modes.values.toList();

  void switchTo(ProjectMode modeType) {
    _activeMode?.onDeactivate(document);
    _activeMode = _modes[modeType];
    if (_activeMode != null) {
      document.activeMode = modeType;
      _activeMode!.onActivate(document);
    }
    notifyListeners();
  }

  void tap(Vector2 position) => _activeMode?.onTap(position, document);
  void dragStart(Vector2 pos) => _activeMode?.onDragStart(pos, document);
  void dragUpdate(Vector2 pos) => _activeMode?.onDragUpdate(pos, document);
  void dragEnd(Vector2 pos) => _activeMode?.onDragEnd(pos, document);
}
