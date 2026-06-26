import 'package:uuid/uuid.dart';
import 'nodo.dart';

class Segmento {
  final String id;
  final String nodoOrigenId;
  final String nodoDestinoId;
  String nombre;
  bool activo;

  Segmento({
    String? id,
    required this.nodoOrigenId,
    required this.nodoDestinoId,
    this.nombre = 'Segmento',
    this.activo = true,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() => {
    'id': id,
    'nodoOrigenId': nodoOrigenId,
    'nodoDestinoId': nodoDestinoId,
    'nombre': nombre,
    'activo': activo,
  };

  factory Segmento.fromJson(Map<String, dynamic> json) => Segmento(
    id: json['id'],
    nodoOrigenId: json['nodoOrigenId'],
    nodoDestinoId: json['nodoDestinoId'],
    nombre: json['nombre'],
    activo: json['activo'],
  );
}
