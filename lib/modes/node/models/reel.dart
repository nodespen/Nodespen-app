import 'package:uuid/uuid.dart';
import '../../../core/document/frame.dart';
import '../../../core/document/camera.dart';

class Reel {
  final String id;
  String nombre;
  final List<Frame> frames;
  final Camera camera;
  bool looping;
  int fps;
  double escala;

  Reel({
    String? id,
    this.nombre = 'Reel',
    List<Frame>? frames,
    Camera? camera,
    this.looping = true,
    this.fps = 24,
    this.escala = 1.0,
  }) : id = id ?? const Uuid().v4(),
       frames = frames ?? [Frame()],
       camera = camera ?? Camera();

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'frames': frames.map((f) => f.toJson()).toList(),
    'camera': camera.toJson(),
    'looping': looping,
    'fps': fps,
    'escala': escala,
  };

  factory Reel.fromJson(Map<String, dynamic> json) => Reel(
    id: json['id'],
    nombre: json['nombre'],
    frames: (json['frames'] as List).map((f) => Frame.fromJson(f)).toList(),
    camera: Camera.fromJson(json['camera']),
    looping: json['looping'],
    fps: json['fps'],
    escala: (json['escala'] as num).toDouble(),
  );
}
