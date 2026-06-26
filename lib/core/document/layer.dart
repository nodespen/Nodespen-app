import 'package:uuid/uuid.dart';
import 'frame.dart';

enum LayerType { normal, mask, guide, folder, reference }
enum ContentType { draw, node, gacha }

class Layer {
  final String id;
  String name;
  LayerType type;
  ContentType contentType;
  bool visible;
  bool locked;
  double opacity;
  int blendMode;
  int? parentLayerIndex;
  final List<Frame> frames;
  int activeFrameIndex;

  Layer({
    String? id,
    this.name = 'Capa',
    this.type = LayerType.normal,
    this.contentType = ContentType.draw,
    this.visible = true,
    this.locked = false,
    this.opacity = 1.0,
    this.blendMode = 0,
    this.parentLayerIndex,
    List<Frame>? frames,
    this.activeFrameIndex = 0,
  }) : id = id ?? const Uuid().v4(),
       frames = frames ?? [Frame()];

  Frame get activeFrame => frames[activeFrameIndex];
  set activeFrame(Frame frame) {
    final index = frames.indexOf(frame);
    if (index >= 0) activeFrameIndex = index;
  }

  void addFrame(Frame frame) => frames.add(frame);

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.name,
    'contentType': contentType.name,
    'visible': visible,
    'locked': locked,
    'opacity': opacity,
    'blendMode': blendMode,
    'parentLayerIndex': parentLayerIndex,
    'frames': frames.map((f) => f.toJson()).toList(),
    'activeFrameIndex': activeFrameIndex,
  };

  factory Layer.fromJson(Map<String, dynamic> json) => Layer(
    id: json['id'] as String,
    name: json['name'] as String,
    type: LayerType.values.byName(json['type'] as String),
    contentType: ContentType.values.byName(json['contentType'] as String),
    visible: json['visible'] as bool,
    locked: json['locked'] as bool,
    opacity: (json['opacity'] as num).toDouble(),
    blendMode: json['blendMode'] as int,
    parentLayerIndex: json['parentLayerIndex'] as int?,
    frames: (json['frames'] as List).map((f) => Frame.fromJson(f)).toList(),
    activeFrameIndex: json['activeFrameIndex'] as int,
  );
}
