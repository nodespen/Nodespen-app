import 'package:uuid/uuid.dart';
import 'camera.dart';
import 'scene.dart';
import 'timeline.dart';

enum ProjectMode { draw, node, gacha }

class NodespenDocument {
  final String id;
  String name;
  ProjectMode activeMode;
  final List<Scene> scenes;
  int activeSceneIndex;
  final Camera camera;
  final Timeline timeline;
  final Map<String, dynamic> metadata;
  DateTime createdAt;
  DateTime modifiedAt;
  int version;

  NodespenDocument({
    String? id,
    this.name = 'Sin título',
    this.activeMode = ProjectMode.node,
    List<Scene>? scenes,
    this.activeSceneIndex = 0,
    Camera? camera,
    Timeline? timeline,
    Map<String, dynamic>? metadata,
    DateTime? createdAt,
    DateTime? modifiedAt,
    this.version = 1,
  }) : id = id ?? const Uuid().v4(),
       scenes = scenes ?? [Scene(name: 'Escena 1')],
       camera = camera ?? Camera(),
       timeline = timeline ?? Timeline(),
       metadata = metadata ?? {},
       createdAt = createdAt ?? DateTime.now(),
       modifiedAt = modifiedAt ?? DateTime.now();

  Scene get activeScene => scenes[activeSceneIndex];
  set activeScene(Scene scene) {
    final index = scenes.indexOf(scene);
    if (index >= 0) activeSceneIndex = index;
  }

  void addScene(Scene scene) => scenes.add(scene);
  void removeScene(int index) {
    if (scenes.length > 1) scenes.removeAt(index);
  }

  void markModified() {
    modifiedAt = DateTime.now();
    version++;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'activeMode': activeMode.name,
    'scenes': scenes.map((s) => s.toJson()).toList(),
    'activeSceneIndex': activeSceneIndex,
    'camera': camera.toJson(),
    'timeline': timeline.toJson(),
    'metadata': metadata,
    'createdAt': createdAt.toIso8601String(),
    'modifiedAt': modifiedAt.toIso8601String(),
    'version': version,
  };

  factory NodespenDocument.fromJson(Map<String, dynamic> json) =>
    NodespenDocument(
      id: json['id'] as String,
      name: json['name'] as String,
      activeMode: ProjectMode.values.byName(json['activeMode'] as String),
      scenes: (json['scenes'] as List).map((s) => Scene.fromJson(s)).toList(),
      activeSceneIndex: json['activeSceneIndex'] as int,
      camera: Camera.fromJson(json['camera']),
      timeline: Timeline.fromJson(json['timeline']),
      metadata: Map<String, dynamic>.from(json['metadata']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      modifiedAt: DateTime.parse(json['modifiedAt'] as String),
      version: json['version'] as int,
    );
}
