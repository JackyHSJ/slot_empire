
import 'dart:async';

import 'package:example_slot_game/const/global_value.dart';
import 'package:example_slot_game/model/game_block_model.dart';
import 'package:example_slot_game/slot_game/game_board/game_board_view_model.dart';
import 'package:example_slot_game/slot_game/single_block/single_block_view_model.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/material.dart';

class SingleBlock extends SpriteComponent with TapCallbacks {
  SingleBlock({
    required this.coverNum,
    required this.startPosition,
    required this.gameBlockSprite,
  }) : super(
      anchor: Anchor.topCenter,
      sprite: gameBlockSprite,
      position: startPosition,
      size: Vector2(GlobalValue.blockVector.x, GlobalValue.blockVector.y * coverNum),
  );

  num coverNum;
  Vector2 startPosition;
  late Sprite gameBlockSprite;
  late SingleBlockViewModel viewModel;
  late SpineComponent destroySpine;
  late SpineComponent blockSpine;

  @override
  Future<void> onLoad() async {
    viewModel = SingleBlockViewModel();
    _loadAnimate();
    // _loadOutLine();
    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onRemove() {
    removeAll(children);
    super.onRemove();
  }

  @override
  void onTapUp(TapUpEvent event) {
    print('tap');
  }

  Future<bool> loadBlockAnimate() async {
    Completer<bool> completer = Completer<bool>();

    blockSpine = await SpineComponent.fromAssets(
      atlasFile: 'assets/spine/export/slot_001.atlas',
      skeletonFile: 'assets/spine/export/H1.json',
      position: Vector2(-70, -80),
    );

    blockSpine.animationState.setAnimationByName(0, 'anim_1', true);
    blockSpine.animationState.setListener((EventType type, TrackEntry trackEntry, Event? event){
      if(type == EventType.complete) {
        blockSpine.dispose();
        remove(blockSpine);
        completer.complete(true);
      }
    });

    add(blockSpine);
    return completer.future;
  }

  Future<bool> loadDestroyAnimate() async {
    Completer<bool> completer = Completer<bool>();
    destroySpine = await SpineComponent.fromAssets(
        atlasFile: 'assets/spine/export/slot_001.atlas',
        skeletonFile: 'assets/spine/export/Destroy.json',
        scale: Vector2(0.9, 0.9),
        position: Vector2(-20, -20),
    );

    destroySpine.animationState.setAnimationByName(0, 'anim_1', false);
    destroySpine.animationState.setListener((EventType type, TrackEntry trackEntry, Event? event){
      if(type == EventType.complete) {
        destroySpine.dispose();
        remove(destroySpine);
        completer.complete(true);
      }
    });

    add(destroySpine);
    return completer.future;
  }

  _loadOutLine() async {
    final Sprite sprite = await Sprite.load('Game BLocks/Outline_1.png');
    final SpriteComponent spriteComponent = SpriteComponent(sprite: sprite, size: GlobalValue.blockVector);
    add(spriteComponent);
  }

  void _loadAnimate() {

  }

  void updateSprite(String imagePath) async {
    Sprite newSprite = await Sprite.load(imagePath);
    sprite = newSprite;  // 更新 sprite 属性
  }

  void turnDark() {
    paint.color = Colors.black.withOpacity(0.5);
  }

  Future<void> turnTransparent() async {
    paint.color = Colors.transparent;
  }

  Future<void> turnLight() async {
    paint.color = Colors.white.withOpacity(1);
  }

  void playRewardEffect() {

  }
}

