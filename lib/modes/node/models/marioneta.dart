import 'dart:math' show cos, sin;
import 'package:uuid/uuid.dart';
import 'nodo.dart';
import 'segmento.dart';
import 'polyfill.dart';
import 'reel.dart';
import '../../../core/math/vector2.dart';

class Marioneta {
  final String id;
  String nombre;
  final List<Nodo> nodos;
  final List<Segmento> segmentos;
  final List<Polyfill> polyfills;
  List<Reel> reels;
  String? nodoRaizId;
  Vector2 posicion;
  double escala;
  double rotacion;
  bool bloqueada;
  bool visible;
  double opacidad;
  final DateTime createdAt;

  Marioneta({
    String? id,
    this.nombre = 'Marioneta',
    List<Nodo>? nodos,
    List<Segmento>? segmentos,
    List<Polyfill>? polyfills,
    List<Reel>? reels,
    this.nodoRaizId,
    Vector2? posicion,
    this.escala = 1.0,
    this.rotacion = 0.0,
    this.bloqueada = false,
    this.visible = true,
    this.opacidad = 1.0,
    DateTime? createdAt,
  }) : id = id ?? const Uuid().v4(),
       nodos = nodos ?? [],
       segmentos = segmentos ?? [],
       polyfills = polyfills ?? [],
       reels = reels ?? [],
       posicion = posicion ?? Vector2.zero(),
       createdAt = createdAt ?? DateTime.now();

  Nodo? get nodoRaiz => nodos.where((n) => n.id == nodoRaizId).firstOrNull;

  void agregarNodo(Nodo nodo) {
    nodos.add(nodo);
    if (nodo.tipo == NodoTipo.raiz) nodoRaizId = nodo.id;
  }

  void agregarSegmento(Segmento segmento) => segmentos.add(segmento);
  void agregarPolyfill(Polyfill polyfill) => polyfills.add(polyfill);
  void agregarReel(Reel reel) => reels.add(reel);

  Nodo? obtenerNodo(String nodoId) =>
    nodos.where((n) => n.id == nodoId).firstOrNull;

  List<Segmento> segmentosDeNodo(String nodoId) =>
    segmentos.where((s) => s.nodoOrigenId == nodoId || s.nodoDestinoId == nodoId).toList();

  List<Nodo> nodosHijos(String padreId) {
    final hijos = <Nodo>[];
    for (final seg in segmentos) {
      if (seg.nodoOrigenId == padreId) {
        final hijo = obtenerNodo(seg.nodoDestinoId);
        if (hijo != null) hijos.add(hijo);
      }
    }
    return hijos;
  }

  void recalcularPosiciones() {
    if (nodoRaiz == null) return;
    _actualizarPosicionesRecursivo(nodoRaizId!, Vector2.zero(), 0);
  }

  void _actualizarPosicionesRecursivo(String nodoId, Vector2 padrePos, double padreAng) {
    final nodo = obtenerNodo(nodoId);
    if (nodo == null) return;

    if (nodo.id != nodoRaizId) {
      final anguloFinal = padreAng + nodo.anguloLocal;
      nodo.posicion = Vector2(
        padrePos.x + (nodo.longitud * cos(anguloFinal)),
        padrePos.y + (nodo.longitud * sin(anguloFinal)),
      );
    }

    for (final hijo in nodosHijos(nodoId)) {
      _actualizarPosicionesRecursivo(hijo.id, nodo.posicion, nodo.angulo);
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'nombre': nombre,
    'nodos': nodos.map((n) => n.toJson()).toList(),
    'segmentos': segmentos.map((s) => s.toJson()).toList(),
    'polyfills': polyfills.map((p) => p.toJson()).toList(),
    'reels': reels.map((r) => r.toJson()).toList(),
    'nodoRaizId': nodoRaizId,
    'posicion': [posicion.x, posicion.y],
    'escala': escala, 'rotacion': rotacion,
    'bloqueada': bloqueada, 'visible': visible,
    'opacidad': opacidad,
    'createdAt': createdAt.toIso8601String(),
  };

  factory Marioneta.fromJson(Map<String, dynamic> json) {
    final m = Marioneta(
      id: json['id'], nombre: json['nombre'],
      nodos: (json['nodos'] as List).map((n) => Nodo.fromJson(n)).toList(),
      segmentos: (json['segmentos'] as List).map((s) => Segmento.fromJson(s)).toList(),
      polyfills: (json['polyfills'] as List).map((p) => Polyfill.fromJson(p)).toList(),
      reels: (json['reels'] as List?)?.map((r) => Reel.fromJson(r)).toList() ?? [],
      nodoRaizId: json['nodoRaizId'],
      posicion: Vector2(json['posicion'][0], json['posicion'][1]),
      escala: (json['escala'] as num).toDouble(),
      rotacion: (json['rotacion'] as num).toDouble(),
      bloqueada: json['bloqueada'],
      visible: json['visible'],
      opacidad: (json['opacidad'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt']),
    );
    return m;
  }

  Marioneta copia() => Marioneta.fromJson(toJson());
}
