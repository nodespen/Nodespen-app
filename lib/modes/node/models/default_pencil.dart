import 'dart:ui' show Color;
import 'package:flutter/material.dart' show Colors;
import 'nodo.dart';
import 'segmento.dart';
import 'marioneta.dart';
import '../../../core/math/vector2.dart';

class DefaultPencil {
  static const double pencilLength = 200;
  static const double bodyWidth = 24;
  static const double eraserHeight = 20;
  static const double metalHeight = 8;
  static const double tipHeight = 30;
  static const double graphiteHeight = 10;

  static const Color bodyColor = Color(0xFFFFD700);
  static const Color eraserColor = Color(0xFFFF6B6B);
  static const Color metalColor = Color(0xFFC0C0C0);
  static const Color woodColor = Color(0xFFDEB887);
  static const Color graphiteColor = Color(0xFF2D2D2D);

  static Marioneta create() {
    final marioneta = Marioneta(nombre: 'Lápiz Nodespen');

    final bodyTop = pencilLength / 2;
    final bodyBottom = -pencilLength / 2;
    final metalPos = bodyTop - eraserHeight;
    final tipStart = bodyBottom + graphiteHeight;

    // Nodos estructurales (ordenados de arriba a abajo)
    final puntaBorrador = Nodo(
      nombre: 'Punta Borrador',
      tipo: NodoTipo.normal,
      posicion: Vector2(0, bodyTop + eraserHeight),
      posicionLocal: Vector2(0, bodyTop + eraserHeight),
      longitud: eraserHeight,
      longitudPorDefecto: eraserHeight,
      segmentoTipo: SegmentoTipo.rectangulo,
      rellenoVisible: false,
      contornoVisible: true,
      color: eraserColor,
      grosor: bodyWidth * 0.7,
      ordenDibujo: 1,
    );

    final baseBorrador = Nodo(
      nombre: 'Base Borrador',
      tipo: NodoTipo.normal,
      posicion: Vector2(0, bodyTop),
      posicionLocal: Vector2(0, bodyTop),
      longitud: 0,
      longitudPorDefecto: 0,
      segmentoTipo: SegmentoTipo.linea,
      rellenoVisible: false,
      contornoVisible: false,
      color: eraserColor,
      grosor: bodyWidth,
      ordenDibujo: 2,
    );

    final anillo = Nodo(
      nombre: 'Anillo',
      tipo: NodoTipo.normal,
      posicion: Vector2(0, metalPos),
      posicionLocal: Vector2(0, metalPos),
      longitud: metalHeight,
      longitudPorDefecto: metalHeight,
      segmentoTipo: SegmentoTipo.rectangulo,
      rellenoVisible: true,
      contornoVisible: true,
      color: metalColor,
      grosor: bodyWidth + 4,
      ordenDibujo: 3,
    );

    final cuerpo = Nodo(
      nombre: 'Cuerpo',
      tipo: NodoTipo.raiz,
      posicion: Vector2(0, 0),
      posicionLocal: Vector2(0, 0),
      longitud: (metalPos - tipStart).abs(),
      longitudPorDefecto: (metalPos - tipStart).abs(),
      segmentoTipo: SegmentoTipo.rectangulo,
      rellenoVisible: true,
      contornoVisible: true,
      color: bodyColor,
      grosor: bodyWidth,
      ordenDibujo: 4,
    );

    final mangoArrastre = Nodo(
      nombre: 'Mango Arrastre',
      tipo: NodoTipo.normal,
      posicion: Vector2(0, bodyTop - 30),
      posicionLocal: Vector2(0, bodyTop - 30),
      longitud: 0,
      longitudPorDefecto: 0,
      segmentoTipo: SegmentoTipo.linea,
      rellenoVisible: false,
      contornoVisible: false,
      color: Colors.orange,
      grosor: 10,
      ordenDibujo: 100,
    );

    final madera = Nodo(
      nombre: 'Madera',
      tipo: NodoTipo.normal,
      posicion: Vector2(0, tipStart),
      posicionLocal: Vector2(0, tipStart),
      longitud: tipHeight - graphiteHeight,
      longitudPorDefecto: tipHeight - graphiteHeight,
      segmentoTipo: SegmentoTipo.triangulo,
      rellenoVisible: true,
      contornoVisible: true,
      color: woodColor,
      grosor: bodyWidth,
      ordenDibujo: 5,
    );

    final grafito = Nodo(
      nombre: 'Grafito',
      tipo: NodoTipo.normal,
      posicion: Vector2(0, bodyBottom),
      posicionLocal: Vector2(0, bodyBottom),
      longitud: graphiteHeight,
      longitudPorDefecto: graphiteHeight,
      segmentoTipo: SegmentoTipo.triangulo,
      trianguloInvertido: true,
      rellenoVisible: true,
      contornoVisible: true,
      color: graphiteColor,
      grosor: 6,
      ordenDibujo: 6,
    );

    final mangoRotacion = Nodo(
      nombre: 'Mango Rotación',
      tipo: NodoTipo.normal,
      posicion: Vector2(0, bodyBottom + 30),
      posicionLocal: Vector2(0, bodyBottom + 30),
      longitud: 0,
      longitudPorDefecto: 0,
      segmentoTipo: SegmentoTipo.linea,
      rellenoVisible: false,
      contornoVisible: false,
      color: Colors.orange,
      grosor: 10,
      ordenDibujo: 100,
    );

    // Agregar nodos a la marioneta
    marioneta.agregarNodo(puntaBorrador);
    marioneta.agregarNodo(baseBorrador);
    marioneta.agregarNodo(anillo);
    marioneta.agregarNodo(cuerpo);
    marioneta.agregarNodo(mangoArrastre);
    marioneta.agregarNodo(madera);
    marioneta.agregarNodo(grafito);
    marioneta.agregarNodo(mangoRotacion);

    // Conectar segmentos (estructura jerárquica de arriba a abajo)
    marioneta.agregarSegmento(Segmento(
      nodoOrigenId: puntaBorrador.id,
      nodoDestinoId: baseBorrador.id,
      nombre: 'Eje Borrador',
    ));
    marioneta.agregarSegmento(Segmento(
      nodoOrigenId: baseBorrador.id,
      nodoDestinoId: anillo.id,
      nombre: 'Base-Anillo',
    ));
    marioneta.agregarSegmento(Segmento(
      nodoOrigenId: anillo.id,
      nodoDestinoId: cuerpo.id,
      nombre: 'Anillo-Cuerpo',
    ));
    marioneta.agregarSegmento(Segmento(
      nodoOrigenId: cuerpo.id,
      nodoDestinoId: madera.id,
      nombre: 'Cuerpo-Madera',
    ));
    marioneta.agregarSegmento(Segmento(
      nodoOrigenId: madera.id,
      nodoDestinoId: grafito.id,
      nombre: 'Madera-Grafito',
    ));

    // Conectar mangos de control al cuerpo
    marioneta.agregarSegmento(Segmento(
      nodoOrigenId: cuerpo.id,
      nodoDestinoId: mangoArrastre.id,
      nombre: 'Mango Arrastre',
    ));
    marioneta.agregarSegmento(Segmento(
      nodoOrigenId: cuerpo.id,
      nodoDestinoId: mangoRotacion.id,
      nombre: 'Mango Rotación',
    ));

    return marioneta;
  }
}
