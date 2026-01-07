import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flutter/services.dart';

/// Represents the player character in the platformer game.
/// Handles animations, movement, jumping, collision detection, and scoring.
class Player extends SpriteAnimationComponent
    with HasGameRef, Hitbox, Collidable, KeyboardHandler {
  Vector2 velocity = Vector2(0, 0);
  final double gravity = 500;
  final double jumpSpeed = -300;
  bool onGround = false;
  int lives = 3;
  int score = 0;

  /// Animation states for the player.
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation jumpingAnimation;

  Player() : super(size: Vector2(50, 50), anchor: Anchor.center);

  @override
  Future<void>? onLoad() async {
    await super.onLoad();
    // Load animations
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('player_spritesheet.png'),
      srcSize: Vector2(50, 50),
    );
    idleAnimation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 4);
    runningAnimation = spriteSheet.createAnimation(row: 1, stepTime: 0.1, to: 4);
    jumpingAnimation = spriteSheet.createAnimation(row: 2, stepTime: 0.1, to: 4);
    animation = idleAnimation;

    // Setup collision detection
    addShape(HitboxRectangle());
  }

  @override
  void update(double dt) {
    super.update(dt);
    velocity.y += gravity * dt;
    position += velocity * dt;

    // Check if the player is on the ground
    if (position.y > gameRef.size.y - size.y / 2) {
      position.y = gameRef.size.y - size.y / 2;
      onGround = true;
      velocity.y = 0;
    } else {
      onGround = false;
    }

    // Update animation based on the player's state
    if (!onGround) {
      animation = jumpingAnimation;
    } else if (velocity.x.abs() > 0) {
      animation = runningAnimation;
    } else {
      animation = idleAnimation;
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent) {
      if (keysPressed.contains(LogicalKeyboardKey.space) && onGround) {
        velocity.y = jumpSpeed;
        onGround = false;
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }

  /// Increments the player's score.
  void addScore(int points) {
    score += points;
  }

  /// Decreases the player's life by one and resets the player's position if lives are still available.
  void loseLife() {
    lives -= 1;
    if (lives > 0) {
      position = Vector2(100, gameRef.size.y - 150); // Reset position
    } else {
      // Handle game over state
      print('Game Over');
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    // Handle collision with obstacles or ground
  }
}