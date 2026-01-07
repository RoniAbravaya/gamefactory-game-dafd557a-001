import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame_audio/flame_audio.dart';

/// A component representing a collectible item in a platformer game.
/// It can detect collisions for pickup, has a score value, and may have an optional animation.
class Collectible extends SpriteComponent with Hitbox, Collidable {
  /// The score value this collectible adds when collected.
  final int scoreValue;

  /// The path to the sound effect to play when this collectible is collected.
  final String? collectionSoundPath;

  /// Creates a new [Collectible] instance.
  ///
  /// [sprite] is the visual representation of the collectible.
  /// [size] is the size of the collectible.
  /// [position] is the position of the collectible in the game world.
  /// [scoreValue] is the amount of score this collectible represents.
  /// [collectionSoundPath] is the path to the sound effect to play upon collection.
  Collectible({
    required Sprite sprite,
    required Vector2 size,
    required Vector2 position,
    this.scoreValue = 10,
    this.collectionSoundPath,
  }) : super(sprite: sprite, size: size, position: position) {
    addShape(HitboxRectangle());
  }

  @override
  Future<void>? onLoad() {
    super.onLoad();
    // Optionally, initialize animations or other setup tasks here.
  }

  /// Handles the logic when this collectible is collected by the player.
  void collect() {
    // Play the collection sound effect if provided.
    if (collectionSoundPath != null) {
      FlameAudio.play(collectionSoundPath!);
    }

    // Logic to add the score value to the player's score.
    // This might involve accessing a game ref or a global state manager.
    // For example: gameRef.player.score += scoreValue;

    // Remove the collectible from the game.
    removeFromParent();
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, Collidable other) {
    super.onCollision(intersectionPoints, other);
    // Check if the other component is a player or a player-like entity to collect the item.
    // This might involve checking the type of `other` or using tags.
    // For example: if (other is Player) collect();
  }

  @override
  void onCollisionEnd(Collidable other) {
    super.onCollisionEnd(other);
    // Optional: Handle any logic when collision with a player ends, if needed.
  }
}