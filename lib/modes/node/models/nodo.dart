import 'dart:ui' as ui;
import 'package:uuid/uuid.dart';
import '../../../core/math/vector2.dart';

enum NodoTipo { normal, estatico, anguloBloqueado, arrastreBloqueado, raiz }
enum SegmentoTipo { linea, circulo, rectangulo, triangulo, trapezoide, poligono, polyfill, curva, arco }
enum RellenoTipo { solido, gradiente, degradadoLateral, hueco }

class Nodo {
  final String id;
  String nombre;
  NodoTipo tipo;
  Vector2 posicion;
  Vector2 posicionLocal;
  double angulo;
  double anguloLocal;
  double escala;
  double grosor;
  double longitud;
  double longitudPorDefecto;
  bool esArrastrable;
  bool esEstirable;
  bool smartStretch;
  bool usarColorSegmento;
  Color color;
  Color colorGradiente;
  Color colorContorno;
  SegmentoTipo segmentoTipo;
  RellenoTipo rellenoTipo;
  bool rellenoVisible;
  bool contornoVisible;
  bool invertirGradiente;
  bool circuloHueco;
  int verticesPoligono;
  double curvatura;
  bool circuloArco;
  bool trianguloInvertido;
  double ratioTrapecio;
  int ordenDibujo;

  Nodo({
    String? id,
    this.nombre = 'Nodo',
    this.tipo = NodoTipo.normal,
    Vector2? posicion,
    Vector2? posicionLocal,
    this.angulo = 0,
    this.anguloLocal = 0,
    this.escala = 1.0,
    this.grosor = 3.0,
    this.longitud = 50,
    this.longitudPorDefecto = 50,
    this.esArrastrable = true,
    this.esEstirable = true,
    this.smartStretch = true,
    this.usarColorSegmento = false,
    this.color = const Color(0xFFFFFFFF),
    this.colorGradiente = const Color(0xFF888888),
    this.colorContorno = const Color(0xFF000000),
    this.segmentoTipo = SegmentoTipo.linea,
    this.rellenoTipo = RellenoTipo.solido,
    this.rellenoVisible = false,
    this.contornoVisible = true,
    this.invertirGradiente = false,
    this.circuloHueco = false,
    this.verticesPoligono = 6,
    this.curvatura = 0,
    this.circuloArco = false,
    this.trianguloInvertido = false,
    this.ratioTrapecio = 0.5,
    this.ordenDibujo = 0,
  }) : id = id ?? const Uuid().v4(),
       posicion = posicion ?? Vector2.zero(),
       posicionLocal = posicionLocal ?? Vector2.zero();

  Nodo copia() => Nodo(
    id: id, nombre: nombre, tipo: tipo,
    posicion: posicion, posicionLocal: posicionLocal,
    angulo: angulo, anguloLocal: anguloLocal,
    escala: escala, grosor: grosor,
    longitud: longitud, longitudPorDefecto: longitudPorDefecto,
    esArrastrable: esArrastrable, esEstirable: esEstirable,
    smartStretch: smartStretch,
    usarColorSegmento: usarColorSegmento,
    color: color, colorGradiente: colorGradiente,
    colorContorno: colorContorno,
    segmentoTipo: segmentoTipo,
    rellenoTipo: rellenoTipo,
    rellenoVisible: rellenoVisible,
    contornoVisible: contornoVisible,
    invertirGradiente: invertirGradiente,
    circuloHueco: circuloHueco,
    verticesPoligono: verticesPoligono,
    curvatura: curvatura,
    circuloArco: circuloArco,
    trianguloInvertido: trianguloInvertido,
    ratioTrapecio: ratioTrapecio,
    ordenDibujo: ordenDibujo,
  );

  Map<String, dynamic> toJson() => {
    'id': id, 'nombre': nombre, 'tipo': tipo.name,
    'posicion': [posicion.x, posicion.y],
    'posicionLocal': [posicionLocal.x, posicionLocal.y],
    'angulo': angulo, 'anguloLocal': anguloLocal,
    'escala': escala, 'grosor': grosor,
    'longitud': longitud, 'longitudPorDefecto': longitudPorDefecto,
    'esArrastrable': esArrastrable,
    'esEstirable': esEstirable, 'smartStretch': smartStretch,
    'usarColorSegmento': usarColorSegmento,
    'color': color.toHex(), 'colorGradiente': colorGradiente.toHex(),
    'colorContorno': colorContorno.toHex(),
    'segmentoTipo': segmentoTipo.name, 'rellenoTipo': rellenoTipo.name,
    'rellenoVisible': rellenoVisible, 'contornoVisible': contornoVisible,
    'invertirGradiente': invertirGradiente, 'circuloHueco': circuloHueco,
    'verticesPoligono': verticesPoligono, 'curvatura': curvatura,
    'circuloArco': circuloArco, 'trianguloInvertido': trianguloInvertido,
    'ratioTrapecio': ratioTrapecio, 'ordenDibujo': ordenDibujo,
  };

  factory Nodo.fromJson(Map<String, dynamic> json) => Nodo(
    id: json['id'], nombre: json['nombre'],
    tipo: NodoTipo.values.byName(json['tipo']),
    posicion: Vector2(json['posicion'][0], json['posicion'][1]),
    posicionLocal: Vector2(json['posicionLocal'][0], json['posicionLocal'][1]),
    angulo: (json['angulo'] as num).toDouble(),
    anguloLocal: (json['anguloLocal'] as num).toDouble(),
    escala: (json['escala'] as num).toDouble(),
    grosor: (json['grosor'] as num).toDouble(),
    longitud: (json['longitud'] as num).toDouble(),
    longitudPorDefecto: (json['longitudPorDefecto'] as num).toDouble(),
    esArrastrable: json['esArrastrable'],
    esEstirable: json['esEstirable'],
    smartStretch: json['smartStretch'],
    usarColorSegmento: json['usarColorSegmento'],
    color: Color.fromHex(json['color']),
    colorGradiente: Color.fromHex(json['colorGradiente']),
    colorContorno: Color.fromHex(json['colorContorno']),
    segmentoTipo: SegmentoTipo.values.byName(json['segmentoTipo']),
    rellenoTipo: RellenoTipo.values.byName(json['rellenoTipo']),
    rellenoVisible: json['rellenoVisible'],
    contornoVisible: json['contornoVisible'],
    invertirGradiente: json['invertirGradiente'],
    circuloHueco: json['circuloHueco'],
    verticesPoligono: json['verticesPoligono'],
    curvatura: (json['curvatura'] as num).toDouble(),
    circuloArco: json['circuloArco'],
    trianguloInvertido: json['trianguloInvertido'],
    ratioTrapecio: (json['ratioTrapecio'] as num).toDouble(),
    ordenDibujo: json['ordenDibujo'],
  );
}

extension ColorExtension on Color {
  String toHex() => '#${value.toRadixString(16).padLeft(8, '0').substring(2)}';
  static Color fromHex(String hex) {
    final h = hex.replaceFirst('#', '');
    return Color(int.parse('FF$h', radix: 16));
  }
}
