import 'package:uuid/uuid.dart';

class Frame {
  final String id;
  int index;
  int duration;
  bool isKeyframe;
  final Map<String, dynamic> content;
  List<String>? soundIds;
  String? label;
  String? actionScript;

  Frame({
    String? id,
    this.index = 0,
    this.duration = 1,
    this.isKeyframe = true,
    Map<String, dynamic>? content,
    this.soundIds,
    this.label,
    this.actionScript,
  }) : id = id ?? const Uuid().v4(),
       content = content ?? {};

  Map<String, dynamic> toJson() => {
    'id': id,
    'index': index,
    'duration': duration,
    'isKeyframe': isKeyframe,
    'content': content,
    if (soundIds != null) 'soundIds': soundIds,
    if (label != null) 'label': label,
    if (actionScript != null) 'actionScript': actionScript,
  };

  factory Frame.fromJson(Map<String, dynamic> json) => Frame(
    id: json['id'] as String,
    index: json['index'] as int,
    duration: json['duration'] as int,
    isKeyframe: json['isKeyframe'] as bool,
    content: Map<String, dynamic>.from(json['content']),
    soundIds: (json['soundIds'] as List?)?.cast<String>(),
    label: json['label'] as String?,
    actionScript: json['actionScript'] as String?,
  );
}
