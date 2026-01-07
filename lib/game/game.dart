import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import 'game_state.dart';
import 'level_config.dart';
import 'player.dart';
import 'obstacle.dart';
import 'score_system.dart';
import 'lives_system.dart';
import 'game_controller.dart';
import 'ui_overlay.dart';
import 'analytics_service.dart';

/// The main Flame game class for the Batch-20260107-125440-platformer-01 game.
class Batch-20260107-125440-platformer-01Game extends FlameGame with TapDetector {
  /// The current game state.
  GameState _gameState = GameState.playing;

  /// The player component.
  late Player _player;

  /// The score system.
  late ScoreSystem _scoreSystem;

  /// The lives system.
  late LivesSystem _livesSystem;

  /// The game controller.
  late GameController _gameController;

  /// The UI overlay.
  late UIOverlay _uiOverlay;

  /// The analytics service.
  final AnalyticsService _analyticsService = AnalyticsService();

  @override
  Future<void> onLoad() async {
    // Set up the camera and world
    camera.viewport = FixedResolutionViewport(Vector2(800, 600));
    camera.followComponent(_player);

    // Load the level configuration
    await loadLevelConfig();

    // Initialize the player, score, and lives systems
    _player = Player();
    _scoreSystem = ScoreSystem();
    _livesSystem = LivesSystem();

    // Add the player, obstacles, and UI components to the game
    add(_player);
    addObstacles();
    _gameController = GameController(this);
    _uiOverlay = UIOverlay(this, _scoreSystem, _livesSystem);
    add(_uiOverlay);

    // Subscribe to game events
    _gameController.onTap = _handleTap;
    _livesSystem.onGameOver = _handleGameOver;
    _scoreSystem.onLevelComplete = _handleLevelComplete;
  }

  /// Loads the level configuration from the provided data.
  Future<void> loadLevelConfig() async {
    // Load the level configuration from the provided data
    final levelConfig = LevelConfig.fromJson(levelData);

    // Create the obstacles based on the level configuration
    for (final obstacleData in levelConfig.obstacles) {
      final obstacle = Obstacle(obstacleData.position, obstacleData.size);
      add(obstacle);
    }
  }

  /// Handles a tap input from the player.
  void _handleTap() {
    if (_gameState == GameState.playing) {
      _player.jump();
    }
  }

  /// Handles a game over event.
  void _handleGameOver() {
    _gameState = GameState.gameOver;
    _analyticsService.logEvent('level_fail');
    // Show the game over UI and handle retry/quit actions
  }

  /// Handles a level complete event.
  void _handleLevelComplete() {
    _gameState = GameState.levelComplete;
    _analyticsService.logEvent('level_complete');
    // Show the level complete UI and handle next level/unlock actions
  }
}