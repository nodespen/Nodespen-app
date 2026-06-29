import '../../../core/document/document.dart';
import '../../../core/document/layer.dart';
import '../../../core/document/frame.dart';
import '../../../core/math/vector2.dart';
import '../../../modes/node/models/marioneta.dart';
import '../../../modes/node/models/nodo.dart';
import '../../../modes/node/models/segmento.dart';
import '../../../modes/node/models/polyfill.dart';
import '../../../modes/draw/models/drawing_element.dart';
import '../../../modes/gacha/models/gacha_character.dart';
import '../../../modes/gacha/models/body_part.dart';

class ConversionEngine {
  final NodespenDocument document;

  ConversionEngine(this.document);

  /// Convierte una capa de un tipo a otro
  void convertirCapa(int layerIndex, ContentType destino) {
    final layer = document.activeScene.layers[layerIndex];
    if (layer.contentType == destino) return;
    layer.contentType = destino;
    document.markModified();
  }

  /// Draw → Node: Elementos de dibujo a marioneta con nodos
  Marioneta drawToNode(List<DrawingElement> elements) {
    final marioneta = Marioneta(nombre: 'De dibujo');
    if (elements.isEmpty) return marioneta;

    Nodo? nodoAnterior;
    for (final elem in elements) {
      if (elem is StrokeElement && elem.points.length >= 2) {
        for (var i = 0; i < elem.points.length; i++) {
          final punto = elem.points[i];
          final tipoNodo = (i == 0 && nodoAnterior == null)
              ? NodoTipo.raiz
              : NodoTipo.normal;
          final nodo = Nodo(
            nombre: 'Nodo ${marioneta.nodos.length + 1}',
            tipo: tipoNodo,
            posicion: punto,
            color: elem.color,
            grosor: elem.strokeWidth,
          );
          marioneta.agregarNodo(nodo);

          if (nodoAnterior != null) {
            marioneta.agregarSegmento(Segmento(
              nodoOrigenId: nodoAnterior.id,
              nodoDestinoId: nodo.id,
              nombre: 'Seg ${marioneta.segmentos.length + 1}',
            ));
          }
          nodoAnterior = nodo;
        }
      } else if (elem is RectElement) {
        final nodos = _rectToNodos(elem);
        for (final n in nodos) {
          marioneta.agregarNodo(n);
        }
        _conectarNodosEnCadena(marioneta, nodos, true);
        if (elem.filled) {
          marioneta.agregarPolyfill(Polyfill(
            nodosIds: nodos.map((n) => n.id).toList(),
            color: elem.color,
            cerrado: true,
          ));
        }
        nodoAnterior = null;
      } else if (elem is CircleElement) {
        final nodos = _circleToNodos(elem);
        for (final n in nodos) {
          marioneta.agregarNodo(n);
        }
        _conectarNodosEnCadena(marioneta, nodos, true);
        if (elem.filled) {
          marioneta.agregarPolyfill(Polyfill(
            nodosIds: nodos.map((n) => n.id).toList(),
            color: elem.color,
            cerrado: true,
          ));
        }
        nodoAnterior = null;
      } else if (elem is LineElement) {
        final inicio = Nodo(
          nombre: 'Inicio ${marioneta.nodos.length + 1}',
          tipo: nodoAnterior == null ? NodoTipo.raiz : NodoTipo.normal,
          posicion: elem.start,
          color: elem.color,
          grosor: elem.strokeWidth,
        );
        final fin = Nodo(
          nombre: 'Fin ${marioneta.nodos.length + 1}',
          posicion: elem.end,
          color: elem.color,
          grosor: elem.strokeWidth,
        );
        marioneta.agregarNodo(inicio);
        marioneta.agregarNodo(fin);
        marioneta.agregarSegmento(Segmento(
          nodoOrigenId: inicio.id,
          nodoDestinoId: fin.id,
        ));
        nodoAnterior = fin;
      }
    }

    return marioneta;
  }

  /// Node → Draw: Marioneta a elementos de dibujo vectorial
  List<DrawingElement> nodeToDraw(Marioneta marioneta) {
    final elements = <DrawingElement>[];
    if (!marioneta.visible) return elements;

    for (final seg in marioneta.segmentos) {
      if (!seg.activo) continue;
      final origen = marioneta.obtenerNodo(seg.nodoOrigenId);
      final destino = marioneta.obtenerNodo(seg.nodoDestinoId);
      if (origen == null || destino == null) continue;

      elements.add(LineElement(
        start: origen.posicion + marioneta.posicion,
        end: destino.posicion + marioneta.posicion,
        color: origen.color,
        strokeWidth: origen.grosor,
      ));
    }

    for (final pf in marioneta.polyfills) {
      final nodos = <Vector2>[];
      for (final nid in pf.nodosIds) {
        final nodo = marioneta.obtenerNodo(nid);
        if (nodo != null) {
          nodos.add(nodo.posicion + marioneta.posicion);
        }
      }
      if (nodos.length >= 3) {
        final path = StrokeElement(
          points: nodos,
          closed: pf.cerrado,
          filled: true,
          color: pf.color,
          strokeWidth: pf.grosorContorno,
        );
        elements.add(path);
      }
    }

    for (final nodo in marioneta.nodos) {
      elements.add(CircleElement(
        center: nodo.posicion + marioneta.posicion,
        radiusX: 4,
        radiusY: 4,
        filled: true,
        color: nodo.color,
      ));
    }

    return elements;
  }

  /// Gacha → Node: Personaje Gacha a marioneta
  Marioneta gachaToNode(GachaCharacter character) {
    final marioneta = Marioneta(nombre: character.name);
    if (!character.visible) return marioneta;

    final Map<BodyPartType, Nodo> nodosMap = {};

    for (final entry in character.bodyParts.entries) {
      final part = entry.value;
      final tipo = entry.key == BodyPartType.torso
          ? NodoTipo.raiz
          : NodoTipo.normal;
      final nodo = Nodo(
        nombre: part.name,
        tipo: tipo,
        posicion: part.position,
        color: part.color,
        grosor: part.width / 2,
        longitud: part.height,
      );
      marioneta.agregarNodo(nodo);
      nodosMap[entry.key] = nodo;
    }

    final conexiones = [
      (BodyPartType.torso, BodyPartType.cabeza),
      (BodyPartType.torso, BodyPartType.brazoIzquierdo),
      (BodyPartType.torso, BodyPartType.brazoDerecho),
      (BodyPartType.torso, BodyPartType.piernaIzquierda),
      (BodyPartType.torso, BodyPartType.piernaDerecha),
      (BodyPartType.brazoIzquierdo, BodyPartType.manoIzquierda),
      (BodyPartType.brazoDerecho, BodyPartType.manoDerecha),
      (BodyPartType.piernaIzquierda, BodyPartType.pieIzquierdo),
      (BodyPartType.piernaDerecha, BodyPartType.pieDerecho),
    ];

    for (final (origen, destino) in conexiones) {
      final nOrigen = nodosMap[origen];
      final nDestino = nodosMap[destino];
      if (nOrigen != null && nDestino != null) {
        marioneta.agregarSegmento(Segmento(
          nodoOrigenId: nOrigen.id,
          nodoDestinoId: nDestino.id,
        ));
      }
    }

    return marioneta;
  }

  /// Node → Gacha: Marioneta a personaje Gacha
  GachaCharacter nodeToGacha(Marioneta marioneta) {
    final character = GachaCharacter(name: marioneta.nombre);
    if (!marioneta.visible || marioneta.nodos.isEmpty) return character;

    final bodyPartMap = <BodyPartType, Vector2>{};
    final partsFound = <int, BodyPartType>{};

    if (marioneta.nodoRaiz != null) {
      final raiz = marioneta.nodoRaiz!;
      bodyPartMap[BodyPartType.torso] = raiz.posicion;
      character.bodyParts[BodyPartType.torso] = BodyPart(
        type: BodyPartType.torso, name: 'Torso',
        position: raiz.posicion, color: raiz.color,
        width: raiz.grosor * 3, height: raiz.longitud,
      );

      for (var i = 0; i < marioneta.nodos.length; i++) {
        final nodo = marioneta.nodos[i];
        if (nodo.id == marioneta.nodoRaizId) continue;

        final assigned = _asignarParteCercana(character, nodo);
        if (assigned != null) {
          partsFound[i] = assigned;
        }
      }
    }

    return character;
  }

  /// Gacha → Draw: Personaje Gacha a elementos de dibujo
  List<DrawingElement> gachaToDraw(GachaCharacter character) {
    final elements = <DrawingElement>[];
    if (!character.visible) return elements;

    for (final entry in character.bodyParts.entries) {
      final part = entry.value;
      if (!part.visible) continue;

      elements.add(RectElement(
        origin: Vector2(
          part.position.x - part.width / 2,
          part.position.y - part.height / 2,
        ),
        size: Vector2(part.width, part.height),
        filled: true,
        color: part.color,
      ));
    }

    for (final item in character.wornItems) {
      elements.add(CircleElement(
        center: item.attachmentPoint == BodyPartType.cabeza
            ? Vector2(0, -100)
            : Vector2(0, -20),
        radiusX: 15,
        radiusY: 15,
        filled: true,
        color: item.color,
      ));
    }

    return elements;
  }

  List<Nodo> _rectToNodos(RectElement rect) {
    final x = rect.origin.x;
    final y = rect.origin.y;
    final w = rect.size.x;
    final h = rect.size.y;
    return [
      Nodo(nombre: 'ES', posicion: Vector2(x, y), color: rect.color, grosor: rect.strokeWidth, tipo: NodoTipo.raiz),
      Nodo(nombre: 'EI', posicion: Vector2(x + w, y), color: rect.color, grosor: rect.strokeWidth),
      Nodo(nombre: 'II', posicion: Vector2(x + w, y + h), color: rect.color, grosor: rect.strokeWidth),
      Nodo(nombre: 'IS', posicion: Vector2(x, y + h), color: rect.color, grosor: rect.strokeWidth),
    ];
  }

  List<Nodo> _circleToNodos(CircleElement circle) {
    final cx = circle.center.x;
    final cy = circle.center.y;
    final rx = circle.radiusX;
    final ry = circle.radiusY;
    return [
      Nodo(nombre: 'Centro', posicion: circle.center, color: circle.color, grosor: circle.strokeWidth * 2, tipo: NodoTipo.raiz),
      Nodo(nombre: 'Der', posicion: Vector2(cx + rx, cy), color: circle.color, grosor: circle.strokeWidth),
      Nodo(nombre: 'Izq', posicion: Vector2(cx - rx, cy), color: circle.color, grosor: circle.strokeWidth),
      Nodo(nombre: 'Sup', posicion: Vector2(cx, cy - ry), color: circle.color, grosor: circle.strokeWidth),
      Nodo(nombre: 'Inf', posicion: Vector2(cx, cy + ry), color: circle.color, grosor: circle.strokeWidth),
    ];
  }

  void _conectarNodosEnCadena(Marioneta m, List<Nodo> nodos, bool cerrar) {
    for (var i = 0; i < nodos.length - 1; i++) {
      m.agregarSegmento(Segmento(
        nodoOrigenId: nodos[i].id,
        nodoDestinoId: nodos[i + 1].id,
      ));
    }
    if (cerrar && nodos.length >= 3) {
      m.agregarSegmento(Segmento(
        nodoOrigenId: nodos.last.id,
        nodoDestinoId: nodos.first.id,
      ));
    }
  }

  BodyPartType? _asignarParteCercana(GachaCharacter character, Nodo nodo) {
    const umbral = 60.0;

    for (final entry in character.bodyParts.entries) {
      if (nodo.posicion.distanceTo(entry.value.position) < umbral) {
        return entry.key;
      }
    }

    final torso = character.bodyParts[BodyPartType.torso];
    if (torso != null) {
      final dy = nodo.posicion.y - torso.position.y;
      if (dy < -30) return BodyPartType.cabeza;
      if (nodo.posicion.x < -20) return BodyPartType.brazoIzquierdo;
      if (nodo.posicion.x > 20) return BodyPartType.brazoDerecho;
      if (dy > 30 && nodo.posicion.x.abs() < 15) return BodyPartType.piernaIzquierda;
    }

    return BodyPartType.accesorio;
  }
}
