import 'dart:async';
import 'package:example_slot_game/const/global_value.dart';
import 'package:example_slot_game/extension/game_block_type.dart';
import 'package:example_slot_game/model/game_block_model.dart';
import 'package:example_slot_game/slot_game/vertical_board/single_block/single_block_view_model.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class SingleBlock extends SpriteComponent {
  SingleBlock({
    required this.gameBlockMap,
    required this.verticalIndex,
    required this.startPosition,
    required this.gameBlockSprite,
  }) : super(
      anchor: Anchor.center,
      sprite: gameBlockSprite,
      position: startPosition,
      size: GlobalValue.blockVector,
  );

  List<GameBlockModel> gameBlockMap;
  int verticalIndex;
  Vector2 startPosition;
  late Sprite gameBlockSprite;
  late SingleBlockViewModel viewModel;

  @override
  Future<void> onLoad() async {
    viewModel = SingleBlockViewModel();
    _loadAnimate();
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

  void _loadAnimate() {
    // 可以在这里加载动画或者进行其他初始化操作
  }

  void updateSprite(String imagePath) async {
    Sprite newSprite = await Sprite.load(imagePath);
    sprite = newSprite;  // 更新 sprite 属性
  }
}

