import '../../core/document/document.dart';
import '../../core/document/layer.dart' show ContentType;
import '../../modes/node/models/marioneta.dart';
import '../../modes/node/models/nodo.dart' show Nodo, NodoTipo, SegmentoTipo;
import '../../modes/node/models/default_pencil.dart';

class ConversionEngine {
  final NodespenDocument document;

  ConversionEngine(this.document);

  void convertirCapa(int layerIndex, ContentType destino) {
    final layer = document.activeScene.layers[layerIndex];
    if (layer.contentType == destino) return;
    layer.contentType = destino;
    document.markModified();
  }

  Marioneta drawToNode(Map<String, dynamic> drawData) {
    final marioneta = Marioneta(nombre: 'De dibujo');
    return marioneta;
  }

  Map<String, dynamic> nodeToDraw(Marioneta marioneta) {
    return {'type': 'vector', 'shapes': []};
  }

  Map<String, dynamic> gachaToDraw(Map<String, dynamic> gachaData) {
    return {'type': 'vector', 'layers': []};
  }

  Marioneta gachaToNode(Map<String, dynamic> gachaData) {
    final marioneta = Marioneta(nombre: 'De Gacha');
    return marioneta;
  }

  Map<String, dynamic> nodeToGacha(Marioneta marioneta) {
    return {'type': 'gacha', 'parts': []};
  }
}
