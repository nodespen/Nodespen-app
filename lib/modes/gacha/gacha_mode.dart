import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../mode.dart';
import '../../core/document/document.dart';
import '../../core/canvas/renderer.dart';
import '../../core/math/vector2.dart';
import 'models/gacha_character.dart';
import 'models/body_part.dart';
import 'models/clothing_item.dart';
import 'tools/gacha_tool.dart';
import 'tools/dress_tool.dart';
import 'tools/color_tool.dart';
import 'tools/pose_tool.dart';

class GachaMode extends Mode {
  late GachaCharacter _character;
  late GachaWorkspace _workspace;
  bool _initialized = false;

  GachaTool _currentTool = PoseTool();
  final List<GachaTool> _tools = [PoseTool(), DressTool(), ColorTool()];

  @override String get name => 'Gacha';
  @override String get icon => '🎀';
  @override String get description => 'Modo de personajes y escenas Gacha';
  @override ProjectMode get modeType => ProjectMode.gacha;

  GachaCharacter get character => _character;
  GachaWorkspace get workspace => _workspace;
  GachaTool get currentTool => _currentTool;
  List<GachaTool> get tools => _tools;

  void setTool(GachaToolType type) {
    _currentTool.onDeactivate();
    _currentTool = _tools.firstWhere((t) => t.toolType == type);
    _currentTool.onActivate();
  }

  @override
  void onActivate(NodespenDocument document) {
    if (!_initialized) {
      _character = GachaCharacter(name: 'Mi Personaje');
      _workspace = GachaWorkspace(character: _character);
      _initialized = true;
    }
  }

  void equipItem(ClothingItem item) {
    _character.equip(item);
  }

  void unequipCategory(ClothingCategory cat) {
    _character.unequip(cat);
  }

  @override
  void onTap(Vector2 position, NodespenDocument document) {
    _currentTool.onTap(position, _workspace);
  }

  @override
  void onDragStart(Vector2 position, NodespenDocument document) {
    _currentTool.onDragStart(position, _workspace);
  }

  @override
  void onDragUpdate(Vector2 position, NodespenDocument document) {
    _currentTool.onDragUpdate(position, _workspace);
  }

  @override
  void onDragEnd(Vector2 position, NodespenDocument document) {
    _currentTool.onDragEnd(position, _workspace);
  }

  @override
  void render(Canvas canvas, Size size, NodespenRenderer renderer) {
    if (!_initialized) return;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(_character.scale);

    _renderCharacter(canvas);
    _currentTool.renderOverlay(canvas, _workspace);

    canvas.restore();
  }

  void _renderCharacter(Canvas canvas) {
    _renderBodyPart(canvas, BodyPartType.piernaIzquierda);
    _renderBodyPart(canvas, BodyPartType.piernaDerecha);
    _renderBodyPart(canvas, BodyPartType.pieIzquierdo);
    _renderBodyPart(canvas, BodyPartType.pieDerecho);
    _renderBodyPart(canvas, BodyPartType.torso);
    _renderBodyPart(canvas, BodyPartType.brazoIzquierdo);
    _renderBodyPart(canvas, BodyPartType.brazoDerecho);
    _renderBodyPart(canvas, BodyPartType.manoIzquierda);
    _renderBodyPart(canvas, BodyPartType.manoDerecha);
    _renderWornItems(canvas, BodyPartType.torso);
    _renderBodyPart(canvas, BodyPartType.cabeza);
    _renderWornItems(canvas, BodyPartType.cabeza);
    _renderFacialFeatures(canvas);
  }

  void _renderBodyPart(Canvas canvas, BodyPartType type) {
    final part = _character.bodyParts[type];
    if (part == null || !part.visible) return;

    canvas.save();
    canvas.translate(part.position.x, part.position.y);
    canvas.rotate(part.angle);

    final paint = Paint()..color = part.color;
    if (type == BodyPartType.cabeza) {
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: part.width, height: part.height), paint);
      canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: part.width, height: part.height), Paint()
        ..color = Colors.black26
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1);
    } else if (type == BodyPartType.torso) {
      final rect = Rect.fromCenter(center: Offset.zero, width: part.width, height: part.height);
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(4));
      canvas.drawRRect(rrect, paint);
    } else {
      canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromCenter(center: Offset.zero, width: part.width, height: part.height),
        const Radius.circular(3),
      ), paint);
    }

    canvas.restore();
  }

  void _renderWornItems(Canvas canvas, BodyPartType attachment) {
    for (final item in _character.wornItems) {
      if (item.attachmentPoint != attachment) continue;
      final part = _character.bodyParts[attachment];
      if (part == null) continue;

      canvas.save();
      canvas.translate(part.position.x, part.position.y);

      switch (item.category) {
        case ClothingCategory.peinado:
          _renderHair(canvas, item);
        case ClothingCategory.sombrero:
          _renderHat(canvas, item);
        case ClothingCategory.ojos:
          _renderEyes(canvas, item);
        case ClothingCategory.camisa:
        case ClothingCategory.chaqueta:
          _renderTop(canvas, item);
        case ClothingCategory.vestido:
          _renderDress(canvas, item);
        case ClothingCategory.pantalon:
          _renderPants(canvas, item);
        case ClothingCategory.falda:
          _renderSkirt(canvas, item);
        case ClothingCategory.zapatos:
          _renderShoes(canvas, item);
        case ClothingCategory.ala:
          _renderWings(canvas, item);
        case ClothingCategory.accesorioCuello:
          _renderNecklace(canvas, item);
        case ClothingCategory.prop:
          _renderProp(canvas, item);
        default:
          break;
      }

      canvas.restore();
    }
  }

  void _renderHair(Canvas canvas, ClothingItem item) {
    final paint = Paint()..color = item.color;
    final path = Path()
      ..moveTo(-22, -10)
      ..quadraticBezierTo(-28, -35, -15, -40)
      ..quadraticBezierTo(0, -45, 15, -40)
      ..quadraticBezierTo(28, -35, 22, -10)
      ..quadraticBezierTo(15, -15, 0, -12)
      ..quadraticBezierTo(-15, -15, -22, -10)
      ..close();
    canvas.drawPath(path, paint);

    final sides = Paint()..color = item.color;
    final leftSide = Path()
      ..moveTo(-22, -10)
      ..quadraticBezierTo(-20, 5, -14, 10)
      ..lineTo(-12, 10)
      ..quadraticBezierTo(-16, 5, -18, -8)
      ..close();
    canvas.drawPath(leftSide, sides);
    final rightSide = Path()
      ..moveTo(22, -10)
      ..quadraticBezierTo(20, 5, 14, 10)
      ..lineTo(12, 10)
      ..quadraticBezierTo(16, 5, 18, -8)
      ..close();
    canvas.drawPath(rightSide, sides);
  }

  void _renderHat(Canvas canvas, ClothingItem item) {
    final paint = Paint()..color = item.color;
    canvas.drawRect(Rect.fromCenter(center: const Offset(0, -30), width: 30, height: 8), paint);
    canvas.drawRect(Rect.fromCenter(center: const Offset(0, -42), width: 18, height: 16), paint);
  }

  void _renderEyes(Canvas canvas, ClothingItem item) {
    final paint = Paint()..color = item.color;
    canvas.drawCircle(const Offset(-10, -4), 4, paint);
    canvas.drawCircle(const Offset(10, -4), 4, paint);
    final pupil = Paint()..color = const Color(0xFF2D2D2D);
    canvas.drawCircle(const Offset(-10, -4), 2, pupil);
    canvas.drawCircle(const Offset(10, -4), 2, pupil);
    final highlight = Paint()..color = Colors.white;
    canvas.drawCircle(const Offset(-8, -6), 1, highlight);
    canvas.drawCircle(const Offset(12, -6), 1, highlight);
  }

  void _renderTop(Canvas canvas, ClothingItem item) {
    final torso = _character.bodyParts[BodyPartType.torso]!;
    final paint = Paint()..color = item.color;
    final rect = Rect.fromCenter(center: Offset.zero, width: torso.width + 4, height: torso.height * 0.7);
    canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), paint);
  }

  void _renderDress(Canvas canvas, ClothingItem item) {
    final torso = _character.bodyParts[BodyPartType.torso]!;
    final paint = Paint()..color = item.color;
    final path = Path()
      ..moveTo(-torso.width / 2 - 2, -torso.height / 2)
      ..lineTo(torso.width / 2 + 2, -torso.height / 2)
      ..lineTo(torso.width / 2 + 10, torso.height / 2 + 10)
      ..lineTo(-torso.width / 2 - 10, torso.height / 2 + 10)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, Paint()
      ..color = item.colorSecundario
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1);
  }

  void _renderPants(Canvas canvas, ClothingItem item) {
    final paint = Paint()..color = item.color;
    canvas.drawRect(Rect.fromCenter(center: const Offset(-8, 20), width: 14, height: 30), paint);
    canvas.drawRect(Rect.fromCenter(center: const Offset(8, 20), width: 14, height: 30), paint);
  }

  void _renderSkirt(Canvas canvas, ClothingItem item) {
    final paint = Paint()..color = item.color;
    final path = Path()
      ..moveTo(-16, 0)
      ..lineTo(16, 0)
      ..lineTo(22, 22)
      ..lineTo(-22, 22)
      ..close();
    canvas.drawPath(path, paint);
  }

  void _renderShoes(Canvas canvas, ClothingItem item) {
    final paint = Paint()..color = item.color;
    canvas.drawRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(center: const Offset(-8, 35), width: 14, height: 8),
      const Radius.circular(3),
    ), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(
      Rect.fromCenter(center: const Offset(8, 35), width: 14, height: 8),
      const Radius.circular(3),
    ), paint);
  }

  void _renderWings(Canvas canvas, ClothingItem item) {
    final paint = Paint()..color = item.color.withValues(alpha: 0.6);
    final wingPath1 = Path()
      ..moveTo(-5, -10)
      ..quadraticBezierTo(-30, -40, -50, -20)
      ..quadraticBezierTo(-40, -10, -30, -5)
      ..quadraticBezierTo(-35, 5, -40, 15)
      ..quadraticBezierTo(-20, 0, -5, 5)
      ..close();
    canvas.drawPath(wingPath1, paint);
    final wingPath2 = Path()
      ..moveTo(5, -10)
      ..quadraticBezierTo(30, -40, 50, -20)
      ..quadraticBezierTo(40, -10, 30, -5)
      ..quadraticBezierTo(35, 5, 40, 15)
      ..quadraticBezierTo(20, 0, 5, 5)
      ..close();
    canvas.drawPath(wingPath2, paint);
  }

  void _renderNecklace(Canvas canvas, ClothingItem item) {
    final paint = Paint()..color = item.color;
    final path = Path()
      ..moveTo(-12, -24)
      ..quadraticBezierTo(0, -18, 12, -24)
      ..quadraticBezierTo(10, -22, 0, -20)
      ..quadraticBezierTo(-10, -22, -12, -24)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(const Offset(0, -20), 2, Paint()..color = item.colorSecundario);
  }

  void _renderProp(Canvas canvas, ClothingItem item) {
    final paint = Paint()..color = item.color;
    canvas.save();
    canvas.translate(40, -10);
    canvas.rotate(0.5);
    canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: 4, height: 40), paint);
    canvas.drawCircle(const Offset(0, -22), 5, Paint()..color = item.colorSecundario);
    canvas.drawCircle(const Offset(0, -22), 3, Paint()..color = item.color);
    canvas.restore();
  }

  void _renderFacialFeatures(Canvas canvas) {
    if (!_character.isEquipped(ClothingCategory.ojos)) {
      final mouth = Paint()
        ..color = const Color(0xFFCC6666)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;
      final head = _character.bodyParts[BodyPartType.cabeza]!;
      canvas.save();
      canvas.translate(head.position.x, head.position.y);
      canvas.drawArc(Rect.fromCenter(center: const Offset(0, 6), width: 10, height: 6), 0, math.pi, false, mouth);
      canvas.restore();
    }

    final head = _character.bodyParts[BodyPartType.cabeza]!;
    canvas.save();
    canvas.translate(head.position.x, head.position.y);

    canvas.drawOval(Rect.fromCenter(
      center: const Offset(0, -4),
      width: 18, height: 6,
    ), Paint()..color = const Color(0xFFFFAAAA));

    canvas.restore();
  }
}
