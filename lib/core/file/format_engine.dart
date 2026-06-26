import 'dart:typed_data';
import '../document/document.dart';
import 'native_format.dart';

enum FileFormat {
  nspn,  // Nodespen Project
  nmar,  // Marioneta (figure)
  nrel,  // Reel (movieclip)
  ndol,  // Muñeco (gacha character)
  nplt,  // Plano (scene)
  stknds, nodes, nodemc,
  stk, piv,
  fla, xfl,
  gacha,
}

class FormatEngine {
  static final Map<FileFormat, FormatHandler> _handlers = {
    FileFormat.nspn: NativeFormatHandler(),
  };

  static void registerHandler(FileFormat format, FormatHandler handler) {
    _handlers[format] = handler;
  }

  static NodespenDocument load(Uint8List bytes, FileFormat format) {
    final handler = _handlers[format];
    if (handler == null) throw UnsupportedError('Formato no soportado: $format');
    return handler.decode(bytes);
  }

  static Uint8List save(NodespenDocument document, FileFormat format) {
    final handler = _handlers[format];
    if (handler == null) throw UnsupportedError('Formato no soportado: $format');
    return handler.encode(document);
  }
}

abstract class FormatHandler {
  NodespenDocument decode(Uint8List bytes);
  Uint8List encode(NodespenDocument document);
  String get extension;
}

class NativeFormatHandler implements FormatHandler {
  @override String get extension => 'nspn';

  @override
  NodespenDocument decode(Uint8List bytes) => NativeFormat.decode(bytes);

  @override
  Uint8List encode(NodespenDocument document) => NativeFormat.encode(document);
}
