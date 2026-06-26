import '../document/document.dart';

abstract class UndoableCommand {
  String get description;
  void execute(NodespenDocument document);
  void undo(NodespenDocument document);
}

class UndoHistory {
  final List<UndoableCommand> _undoStack = [];
  final List<UndoableCommand> _redoStack = [];
  final int maxSize;

  UndoHistory({this.maxSize = 100});

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;
  int get undoCount => _undoStack.length;
  int get redoCount => _redoStack.length;

  void execute(UndoableCommand command, NodespenDocument document) {
    command.execute(document);
    _undoStack.add(command);
    _redoStack.clear();
    if (_undoStack.length > maxSize) _undoStack.removeAt(0);
  }

  void undo(NodespenDocument document) {
    if (!canUndo) return;
    final command = _undoStack.removeLast();
    command.undo(document);
    _redoStack.add(command);
  }

  void redo(NodespenDocument document) {
    if (!canRedo) return;
    final command = _redoStack.removeLast();
    command.execute(document);
    _undoStack.add(command);
  }

  void clear() {
    _undoStack.clear();
    _redoStack.clear();
  }

  String get undoDescription =>
    canUndo ? _undoStack.last.description : '';
  String get redoDescription =>
    canRedo ? _redoStack.last.description : '';
}
