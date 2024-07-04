
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
    required num coverNum,
    required this.startPosition,
    required this.gameBlockSprite,
    this.isGold = false,
  }) : super(
      anchor: Anchor.bottomCenter,
      sprite: gameBlockSprite,
      position: startPosition,
      size: Vector2(GlobalValue.blockVector.x, GlobalValue.blockVector.y * coverNum),
  ) {
    _currentCoverNumber = coverNum;
  }

  late num _currentCoverNumber;
  Vector2 startPosition;
  bool isGold;
  late Sprite gameBlockSprite;
  late SingleBlockViewModel viewModel;
  late SpineComponent destroySpine;
  late SpineComponent blockSpine;
  late SpriteComponent outlineSpriteComponent;

  @override
  Future<void> onLoad() async {
    viewModel = SingleBlockViewModel();
    _loadGoldOutLine(isGold: isGold, coverNum: _currentCoverNumber);
    // _loadOutLine();
    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onTapUp(TapUpEvent event) async {
    print('tap');
    print('x: ${position.x}, y: ${position.y}');
    // await loadBlockAnimate();
    // turnTransparent();
    // loadDestroyAnimate();
  }

  Future<bool> loadBlockAnimate() async {
    Completer<bool> completer = Completer<bool>();
    String imgName = viewModel.getImgName(position);
    if(imgName == '') completer.complete(false);
    if(imgName != '') {
      if(imgName == 'S1') {
        imgName = 'H1';
      }
      blockSpine = await SpineComponent.fromAssets(
        atlasFile: 'assets/spine/export/slot_001.atlas',
        skeletonFile: 'assets/spine/export/$imgName.json',
        position: Vector2(-70, -80),
      );

      blockSpine.animationState.setAnimationByName(0, 'anim_$_currentCoverNumber', true);
      blockSpine.animationState.setListener((EventType type, TrackEntry trackEntry, Event? event){
        if(type == EventType.complete) {
          blockSpine.dispose();
          // remove(blockSpine);
          completer.complete(true);
        }
      });

      add(blockSpine);
    }
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

    destroySpine.animationState.setAnimationByName(0, 'anim_$_currentCoverNumber', false);
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

  _loadGoldOutLine({
    required bool isGold,
    required num coverNum
  }) async {

    final Sprite sprite = await Sprite.load('Game BLocks/Outline_$coverNum.png');
    final color = isGold ? Colors.white : Colors.transparent;
    final Paint paint = Paint()
      ..color = color;
    outlineSpriteComponent = SpriteComponent(sprite: sprite, scale: Vector2(1.4, 1.4), paint: paint);
    add(outlineSpriteComponent);
  }

  Future<void> updateSprite({
    required String imgPath,
    required num coverNumber,
    bool isGold = false
  }) async {
    _currentCoverNumber = coverNumber;
    paint.color = Colors.white;
    Sprite newSprite = await Sprite.load(imgPath);
    sprite = newSprite;
    final double sizeY = GlobalValue.blockVector.y * coverNumber;
    size = Vector2(GlobalValue.blockVector.x, sizeY);

    /// 金外匡
    final color = isGold ? Colors.white : Colors.transparent;
    final Sprite outlineSprite = await Sprite.load('Game BLocks/Outline_$coverNumber.png');
    outlineSpriteComponent
        ..paint.color = color
        ..sprite = outlineSprite;
  }

  void turnDark() {
    if(isTransparent) return ;
    paint.color = Colors.black.withOpacity(0.5);
  }

  bool get isTransparent => paint.color == Colors.transparent;

  Future<void> turnTransparent() async {
    paint.color = Colors.transparent;
  }

  Future<void> turnLight() async {
    if(isTransparent) return ;
    paint.color = Colors.white.withOpacity(1);
  }

  removeBlock() {
    removeAll(children);
    removeFromParent();
  }
}

