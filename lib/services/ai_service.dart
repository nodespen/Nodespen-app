import '../core/document/document.dart';

enum AiFeature {
  autoTween, suggestPose, generateCharacter, cleanDrawing,
  autoColor, describeScene, textToAnimation, smartFill
}

class AiService {
  bool _available = false;

  bool get isAvailable => _available;

  void configure(String apiKey) {
    _available = true;
  }

  void disable() {
    _available = false;
  }

  Future<String> processPrompt(String prompt, {NodespenDocument? context}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return '[AI Assist] Procesando: "$prompt" — (simulado)';
  }

  Future<List<String>> suggestImprovements(NodespenDocument document) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      'Sugerencia: prueba a añadir keyframes para animación más fluida',
      'Sugerencia: usa Onion Skin para ver frames anteriores',
      'Sugerencia: exporta como GIF para compartir',
    ];
  }
}
