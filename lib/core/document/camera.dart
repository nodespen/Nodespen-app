import '../math/vector2.dart' show Vector2, Matrix3;

class Camera {
  Vector2 position;
  double zoom;
  double rotation;
  Vector2 focalPoint;
  bool isEnabled;

  Camera({
    Vector2? position,
    this.zoom = 1.0,
    this.rotation = 0.0,
    Vector2? focalPoint,
    this.isEnabled = false,
  }) : position = position ?? Vector2.zero(),
       focalPoint = focalPoint ?? Vector2.zero();

  void pan(Vector2 delta) => position += delta;
  void zoomTo(double factor, Vector2 focal) {
    focalPoint = focal;
    zoom = (zoom * factor).clamp(0.01, 100.0);
  }
  void rotateTo(double angle) => rotation = angle;

  Matrix3 get viewMatrix {
    final t = Matrix3.translation(position);
    final s = Matrix3.scale(Vector2(zoom, zoom));
    final r = Matrix3.rotation(rotation);
    return t * s * r;
  }

  Map<String, dynamic> toJson() => {
    'position': [position.x, position.y],
    'zoom': zoom,
    'rotation': rotation,
    'isEnabled': isEnabled,
  };

  factory Camera.fromJson(Map<String, dynamic> json) => Camera(
    position: Vector2(json['position'][0], json['position'][1]),
    zoom: (json['zoom'] as num).toDouble(),
    rotation: (json['rotation'] as num).toDouble(),
    isEnabled: json['isEnabled'] as bool,
  );
}
