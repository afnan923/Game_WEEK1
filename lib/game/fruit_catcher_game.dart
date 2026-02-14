import 'dart:math';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_week1/game/components/basket.dart';
import 'package:flutter_game_week1/game/managers/audio_manager.dart';

class FruitCatcherGame extends FlameGame
    with PanDetector, HasCollisionDetection {
  late Basket basket;
  late TextComponent scoreText;
  final Random random = Random();
  double fruitSpawnTimer = 0;
  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  int _score = 0;
  int get score => _score;
  set score(int value) {
    _score = value;
    scoreNotifier.value = value;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Set background color
    camera.viewport = FixedResolutionViewport(resolution: Vector2(400, 800));
    // Add basket
    basket = Basket();
    await add(basket);
    // Play background music
    AudioManager().playBackgroundMusic();
  }

}
