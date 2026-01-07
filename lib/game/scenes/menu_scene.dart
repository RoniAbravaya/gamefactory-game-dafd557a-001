import 'package:flame/components.dart';
import 'package:flame/geometry.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';

/// Represents the main menu scene for the platformer game.
class MenuScene extends Component with HasGameRef, TapDetector {
  late final SpriteComponent title;
  late final SpriteButtonComponent playButton;
  late final SpriteButtonComponent levelSelectButton;
  late final SpriteButtonComponent settingsButton;
  late final SpriteComponent background;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await _loadBackground();
    await _loadTitle();
    await _loadPlayButton();
    await _loadLevelSelectButton();
    await _loadSettingsButton();
  }

  /// Loads and sets up the background animation.
  Future<void> _loadBackground() async {
    background = SpriteComponent()
      ..sprite = await gameRef.loadSprite('background.png')
      ..size = gameRef.size;
    add(background);
  }

  /// Loads and sets up the title display.
  Future<void> _loadTitle() async {
    title = SpriteComponent()
      ..sprite = await gameRef.loadSprite('title.png')
      ..size = Vector2(300, 100)
      ..position = gameRef.size / 2 - Vector2(150, 200);
    add(title);
  }

  /// Loads and sets up the play button.
  Future<void> _loadPlayButton() async {
    playButton = SpriteButtonComponent(
      button: await gameRef.loadSprite('play_button.png'),
      buttonDown: await gameRef.loadSprite('play_button_pressed.png'),
      size: Vector2(150, 75),
      position: gameRef.size / 2 - Vector2(75, 0),
      onPressed: () {
        // Navigate to the game play scene
      },
    );
    add(playButton);
  }

  /// Loads and sets up the level select button.
  Future<void> _loadLevelSelectButton() async {
    levelSelectButton = SpriteButtonComponent(
      button: await gameRef.loadSprite('level_select_button.png'),
      buttonDown: await gameRef.loadSprite('level_select_button_pressed.png'),
      size: Vector2(150, 75),
      position: gameRef.size / 2 - Vector2(75, 100),
      onPressed: () {
        // Navigate to the level select scene
      },
    );
    add(levelSelectButton);
  }

  /// Loads and sets up the settings button.
  Future<void> _loadSettingsButton() async {
    settingsButton = SpriteButtonComponent(
      button: await gameRef.loadSprite('settings_button.png'),
      buttonDown: await gameRef.loadSprite('settings_button_pressed.png'),
      size: Vector2(150, 75),
      position: gameRef.size / 2 - Vector2(75, 200),
      onPressed: () {
        // Navigate to the settings scene
      },
    );
    add(settingsButton);
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);
    final touchArea = info.eventPosition.game;
    if (playButton.containsPoint(touchArea)) {
      playButton.onPressed();
    } else if (levelSelectButton.containsPoint(touchArea)) {
      levelSelectButton.onPressed();
    } else if (settingsButton.containsPoint(touchArea)) {
      settingsButton.onPressed();
    }
  }
}