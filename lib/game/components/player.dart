import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

/// The Player component for the platformer game.
class Player extends SpriteAnimationComponent with HasGameRef {
  static const double _playerSpeed = 200.0;
  static const double _playerJumpForce = 500.0;
  static const double _playerGravity = 1200.0;
  static const double _playerMaxHealth = 100.0;
  static const double _playerInvulnerabilityDuration = 1.0;

  double _health = _playerMaxHealth;
  double _velocity = 0.0;
  bool _isJumping = false;
  bool _isInvulnerable = false;
  double _invulnerabilityTimer = 0.0;

  /// Creates a new instance of the Player component.
  Player() : super(size: Vector2.all(50.0));

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load the player's sprite animation
    final spriteSheet = SpriteSheet(
      image: await gameRef.images.load('player.png'),
      srcSize: Vector2(32.0, 32.0),
    );
    animation = spriteSheet.createAnimation(row: 0, stepTime: 0.1, to: 4);
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Handle player movement and jumping
    _handleMovement(dt);
    _handleJumping(dt);

    // Handle player invulnerability
    _handleInvulnerability(dt);
  }

  void _handleMovement(double dt) {
    // Apply horizontal movement
    position.x += _playerSpeed * dt;

    // Apply gravity
    _velocity += _playerGravity * dt;
    position.y += _velocity * dt;
  }

  void _handleJumping(double dt) {
    // Handle jumping
    if (gameRef.input.isPressed(LogicalKeyboardKey.space) && !_isJumping) {
      _velocity = -_playerJumpForce;
      _isJumping = true;
    }

    if (_velocity >= 0) {
      _isJumping = false;
    }
  }

  void _handleInvulnerability(double dt) {
    // Handle player invulnerability
    if (_isInvulnerable) {
      _invulnerabilityTimer += dt;
      if (_invulnerabilityTimer >= _playerInvulnerabilityDuration) {
        _isInvulnerable = false;
        _invulnerabilityTimer = 0.0;
      }
    }
  }

  void takeDamage(double amount) {
    // Reduce player's health and set invulnerability
    if (!_isInvulnerable) {
      _health = (_health - amount).clamp(0.0, _playerMaxHealth);
      _isInvulnerable = true;
    }
  }

  void collectItem(double value) {
    // Increase player's health
    _health = (_health + value).clamp(0.0, _playerMaxHealth);
  }

  bool get isDead => _health <= 0.0;
}