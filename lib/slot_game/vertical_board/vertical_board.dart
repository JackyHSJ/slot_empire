import 'dart:developer';
import 'dart:async';
import 'dart:ui';
import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/const/global_value.dart';
import 'package:example_slot_game/extension/game_block_model.dart';
import 'package:example_slot_game/extension/game_block_type.dart';
import 'package:example_slot_game/model/game_block_model.dart';
import 'package:example_slot_game/model/vertical_block_model.dart';
import 'package:example_slot_game/slot_game/single_block/single_block.dart';
import 'package:example_slot_game/slot_game/vertical_board/vertical_board_view_model.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class VerticalBoard extends PositionComponent {
  VerticalBoard({
    required this.horizontalIndex,
    required this.verticalGameBlockMap,
  }): super(position: Vector2(0, -520)); // 顯示6 ~ 10 行

  int horizontalIndex;
  List<GameBlockModel> verticalGameBlockMap;
  late VerticalBoardViewModel viewModel;
  List<SingleBlock> gameBlockComponentList = [];
  late MoveEffect spinMoveEffect;
  late EffectController controller;

  @override
  Future<void> onLoad() async {
    viewModel = VerticalBoardViewModel();
    for (int i = 0; i < verticalGameBlockMap.length; i++) {
      await _loadGameBlock(i);
    }
    super.onLoad();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }


  @override
  void update(double dt) {
    super.update(dt);
  }

  Future<void> _loadGameBlock(int verticalIndex, {
    bool addFallingBlocks = false
  }) async {
    final num coverNum = verticalGameBlockMap[verticalIndex].coverNumber;
    final String imgPath = verticalGameBlockMap[verticalIndex].getBlockImgPath;
    final Sprite gameBlockSprite = await Sprite.load(imgPath);

    // Calculate the final position
    final Vector2 finalPosition = viewModel.getBlockVector2(
        x: 0, y: 0,
        blockWidth: GlobalValue.blockVector.x,
        blockHigh: GlobalValue.blockVector.y,
        horizontalIndex: horizontalIndex,
        verticalIndex: verticalIndex
    );

    // If animate is true, start from above the visible area
    final Vector2 animateStart = viewModel.getBlockAnimateStartVector2(horizontalIndex: horizontalIndex);
    final Vector2 startPosition = addFallingBlocks ? animateStart : finalPosition;

    final SingleBlock gameBlockComponent = SingleBlock(
        startPosition: startPosition,
        gameBlockSprite: gameBlockSprite,
        coverNum: coverNum
    );

    if(addFallingBlocks == false) {
      gameBlockComponentList.add(gameBlockComponent);
      add(gameBlockComponent);
    }

    if (addFallingBlocks == true) {
      final Vector2 animateEnd = viewModel.getBlockVector2(
          x: 0, y: 0,
          blockWidth: GlobalValue.blockVector.x,
          blockHigh: GlobalValue.blockVector.y,
          horizontalIndex: horizontalIndex,
          verticalIndex: 5 + verticalIndex
      );
      final EffectController controller = EffectController(duration: 0.4, curve: Curves.elasticInOut);
      final MoveEffect moveEffect = MoveEffect.to(animateEnd, controller);
      gameBlockComponent.add(moveEffect);
      gameBlockComponentList.add(gameBlockComponent);
      add(gameBlockComponent);
    }
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

    gameBlockComponentList.removeAt(removeIndex);
  }


  void updateFallingBlocks() {
    List<VerticalBlockModel> toUpdate = [];

    /// 檢查每個方塊下方 5個方塊
    viewModel.checkUpdateFallingBlocks(
      verticalGameBlockMap: verticalGameBlockMap,
      children: children,
      horizontalIndex: horizontalIndex,
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
      verticalGameBlockMap: verticalGameBlockMap,
      children: children,
      onLoadGameBlock: (index) => _loadGameBlock(index, addFallingBlocks: true)
    );
  }

  startSpin(SpinType spinType) {
    if(spinType == SpinType.spin) {
      return ;
    }
    final Vector2 animateEnd = Vector2(0, 0);
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
    final Vector2 finalPosition = viewModel.getVector2(x: -72, y: -520); // 最終顯示 6 ~ 10行
    position = finalPosition;
  }
}
