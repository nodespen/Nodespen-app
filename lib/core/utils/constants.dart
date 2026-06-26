class AppConstants {
  static const String appName = 'Nodespen';
  static const String appVersion = '0.1.0';
  static const String nativeExtension = 'nspn';
  static const String marionetaExtension = 'nmar';
  static const String reelExtension = 'nrel';
  static const String munecoExtension = 'ndol';
  static const String planoExtension = 'nplt';

  static const double defaultCanvasWidth = 1920;
  static const double defaultCanvasHeight = 1080;
  static const double minCanvasWidth = 16;
  static const double maxCanvasWidth = 8192;
  static const int defaultFps = 24;
  static const int maxFps = 120;
  static const int maxUndoStack = 100;
  static const int maxLayerCount = 128;
  static const double minZoom = 0.01;
  static const double maxZoom = 100.0;
  static const double defaultZoom = 1.0;

  static const double nodeMinScale = 0.1;
  static const double nodeMaxScale = 20.0;
  static const int maxNodesPerFigure = 30000;
  static const int maxFiguresPerScene = 1000;

  static const List<String> supportedExportFormats = [
    'nspn', 'stknds', 'nodes', 'nodemc',
    'stk', 'piv',
    'fla', 'xfl',
    'gacha',
    'gif', 'mp4', 'png', 'webm', 'svg',
  ];
}
