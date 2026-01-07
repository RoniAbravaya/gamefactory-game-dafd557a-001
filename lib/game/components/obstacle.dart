import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flutter/material.dart';

/// A component representing an obstacle in a platformer game.
/// It includes a visual representation, collision detection, and movement behavior.
class Obstacle extends PositionComponent with HasHitboxes, Collidable {
  final Vector2 _size;
  final Vector2 _position;
  final String _spritePath;
  late final SpriteComponent _spriteComponent;

  /// Creates an instance of an obstacle.
  /// 
  /// [size] specifies the size of the obstacle.
  /// [position] specifies the initial position of the obstacle.
  /// [spritePath] is the path to the sprite image. If null, the obstacle will be rendered as a colored box.
  Obstacle({
    required Vector2 size,
    required Vector2 position,
    String? spritePath,
  })  : _size = size,
        _position = position,
        _spritePath = spritePath ?? '' {
    addHitbox(HitboxRectangle(relation: _size));
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    size = _size;
    position = _position;
    if (_spritePath.isNotEmpty) {
      _spriteComponent = SpriteComponent.fromImage(await Flame.images.load(_spritePath), size: _size);
      add(_spriteComponent);
    } else {
      // Fallback to a simple colored box if no sprite path is provided
      _spriteComponent = SpriteComponent()
        ..sprite = await Sprite.load('path_to_default_image.png') // Placeholder path
        ..size = _size;
      add(_spriteComponent);
    }
    addShape(HitboxRectangle());
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Implement movement or spawning behavior here
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    // Handle damage dealing or other effects on collision
  }
}