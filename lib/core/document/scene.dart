import 'package:uuid/uuid.dart';
import 'layer.dart';
import 'camera.dart';

class Scene {
  final String id;
  String name;
  final List<Layer> layers;
  int activeLayerIndex;
  double width;
  double height;
  Camera? sceneCamera;
  final Map<String, dynamic> properties;

  Scene({
    String? id,
    this.name = 'Escena',
    List<Layer>? layers,
    this.activeLayerIndex = 0,
    this.width = 1920,
    this.height = 1080,
    this.sceneCamera,
    Map<String, dynamic>? properties,
  }) : id = id ?? const Uuid().v4(),
       layers = layers ?? [Layer(name: 'Capa 1')],
       properties = properties ?? {};

  Layer get activeLayer => layers[activeLayerIndex];
  set activeLayer(Layer layer) {
    final index = layers.indexOf(layer);
    if (index >= 0) activeLayerIndex = index;
  }

  void addLayer(Layer layer) => layers.add(layer);
  void removeLayer(int index) {
    if (layers.length > 1) layers.removeAt(index);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'layers': layers.map((l) => l.toJson()).toList(),
    'activeLayerIndex': activeLayerIndex,
    'width': width,
    'height': height,
    'sceneCamera': sceneCamera?.toJson(),
    'properties': properties,
  };

  factory Scene.fromJson(Map<String, dynamic> json) => Scene(
    id: json['id'] as String,
    name: json['name'] as String,
    layers: (json['layers'] as List).map((l) => Layer.fromJson(l)).toList(),
    activeLayerIndex: json['activeLayerIndex'] as int,
    width: (json['width'] as num).toDouble(),
    height: (json['height'] as num).toDouble(),
    sceneCamera: json['sceneCamera'] != null
      ? Camera.fromJson(json['sceneCamera'])
      : null,
    properties: Map<String, dynamic>.from(json['properties'] ?? {}),
  );
}
