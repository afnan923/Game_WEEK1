import 'dart:math';

import 'package:flame/camera.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_game_week1/game/components/basket.dart';
import 'package:flutter_game_week1/game/components/fruit.dart';
import 'package:flutter_game_week1/game/managers/audio_manager.dart';

class FruitCatcherGame extends FlameGame with PanDetector, HasCollisionDetection {
  late Basket basket;
  late TextComponent scoreText;
  final Random random = Random();
  double fruitSpawnTimer = 0;
  final double fruitSpawnInterval = 1.5;

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

    camera.viewport = FixedResolutionViewport(resolution: Vector2(400, 800));

    basket = Basket();
    await add(basket);

    await AudioManager().initialize();
    AudioManager().playBackgroundMusic();
  }

  @override
  void update(double dt) {
    super.update(dt);

    fruitSpawnTimer += dt;
    if (fruitSpawnTimer >= fruitSpawnInterval) {
      spawnFruit();
      fruitSpawnTimer = 0;
    }
  }

  void spawnFruit() {
    final x = random.nextDouble() * size.x;
    final fruit = Fruit(position: Vector2(x, -50));
    add(fruit);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    basket.position.x += info.delta.global.x;
    basket.position.x = basket.position.x.clamp( basket.size.x / 2, basket.size.y / 2);
  }

  void incrementScore() {
    score++;
    AudioManager().playSfx('collect.mp3');
  }

  void gameOver() {
    AudioManager().playSfx('explode.mp3');
    pauseEngine();
  }

  @override
  void onRemove() {
    AudioManager().pauseBackgroundMusic();
    super.onRemove();
  }

  @override
  Color backgroundColor() => const Color(0xFF87CEEB); // Sky blue
}
