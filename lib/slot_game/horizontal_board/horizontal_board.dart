import 'dart:developer';

import 'package:example_slot_game/const/global_value.dart';
import 'package:example_slot_game/extension/game_block_model.dart';
import 'package:example_slot_game/extension/game_block_type.dart';
import 'package:example_slot_game/model/game_block_model.dart';
import 'package:example_slot_game/model/horizontal_block_model.dart';
import 'package:example_slot_game/slot_game/horizontal_board/horizontal_board_view_model.dart';
import 'package:example_slot_game/slot_game/single_block/single_block.dart';
import 'package:example_slot_game/slot_game/vertical_board/vertical_board_view_model.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../../const/enum.dart';

class HorizontalBoard extends PositionComponent {
  HorizontalBoard({
    required this.horizontalGameBlockMap
  });

  late HorizontalBoardViewModel viewModel;
  List<GameBlockModel> horizontalGameBlockMap;
  late MoveEffect spinMoveEffect;
  late EffectController controller;

  @override
  Future<void> onLoad() async {
    viewModel = HorizontalBoardViewModel();
    for (int i = 0; i < horizontalGameBlockMap.length; i++) {
      await _loadGameBlock(i);
    }
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

  void removeBlocks({
    required int removeIndex
  }) {
    removeWhere((component) => viewModel.removeBlocks(
        component: component,
        removeIndex: removeIndex
    ));
  }

  Future<void> _loadGameBlock(int index, {
    bool addFallingBlocks = false
  }) async {
    final String imgPath = horizontalGameBlockMap[index].getBlockImgPath;
    final Sprite gameBlockSprite = await Sprite.load(imgPath);

    // Calculate the final position
    final Vector2 finalPosition = viewModel.getBlockVector2(
        x: 0, y: 0,
        blockWidth: GlobalValue.blockVector.x,
        blockHigh: GlobalValue.blockVector.y,
        index: index
    );

    // If animate is true, start from above the visible area
    final Vector2 animateStart = viewModel.getBlockAnimateStartVector2();
    final Vector2 startPosition = addFallingBlocks ? animateStart : finalPosition;

    final SingleBlock gameBlockComponent = SingleBlock(
      coverNum: 1,
      startPosition: startPosition,
      gameBlockSprite: gameBlockSprite,
    );

    if (addFallingBlocks) {
      final Vector2 animateEnd = viewModel.getBlockVector2(
          x: 0, y: 0,
          blockWidth: GlobalValue.blockVector.x,
          blockHigh: GlobalValue.blockVector.y,
          index: index
      );
      final EffectController controller = EffectController(duration: 0.4, curve: Curves.elasticInOut);
      final MoveEffect moveEffect = MoveEffect.to(animateEnd, controller);
      gameBlockComponent.add(moveEffect);
    }

    add(gameBlockComponent);
  }

  startSpin(SpinType spinType) {
    if(spinType == SpinType.spin) {
      return ;
    }
    // final Vector2 animateEnd = Vector2(0, -GlobalValue.blockVector.y * 5);
    final Vector2 animateEnd = Vector2(-GlobalValue.blockVector.x * 5, 0);
    controller = EffectController(duration: 0.1, infinite: true);
    spinMoveEffect = MoveEffect.to(animateEnd, controller);
    add(spinMoveEffect);
  }

  stopSpin(SpinType spinType) {
    if(spinType == SpinType.none || spinType == SpinType.stop) {
      return ;
    }
    spinMoveEffect.reset();
    removeAll(children.whereType<Effect>());
    final Vector2 finalPosition = viewModel.getVector2(x: -72, y: 0);
    position = finalPosition;
  }

  void updateFallingBlocks() {
    List<HorizontalBlockModel> toUpdate = [];

    viewModel.checkUpdateFallingBlocks(
        children: children,
        onAddToUpdate: (model) => toUpdate.add(model)
    );

    /// 移動需要位移的方塊
    viewModel.movingUpdateFallingBlocks(
        toUpdate: toUpdate,
        onMoveEffectDone: () => moveEffectDone()
    );
  }

  /// 全部動畫完成
  void moveEffectDone() {
    viewModel.addFallingBlocks(
        horizontalGameBlockMap: horizontalGameBlockMap,
        children: children,
        onLoadGameBlock: (index) => _loadGameBlock(index, addFallingBlocks: true)
    );
  }
}
