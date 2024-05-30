

import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/const/global_value.dart';
import 'package:example_slot_game/model/game_block_model.dart';
import 'package:example_slot_game/model/vertical_block_model.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

class VerticalBoardViewModel {
  VerticalBoardViewModel();

  late EffectController effectController;

  Vector2 getVector2({
    required double x,
    required double y,
  }) {
    return Vector2(x + GlobalValue.blockOffsetX, y + GlobalValue.blockOffsetY);
  }

  /// 原點 -275, -170
  Vector2 getBlockVector2({
    required double x,
    required double y,
    required double blockWidth,
    required double blockHigh,
    required int horizontalIndex,
    required int verticalIndex
  }) {
    final double horizontalWidth = horizontalIndex * blockWidth;
    final double verticalHigh = verticalIndex * blockHigh;
    return Vector2(x + GlobalValue.blockOffsetX + horizontalWidth, y + GlobalValue.blockOffsetY + verticalHigh);
  }

  Vector2 getBlockAnimateStartVector2({
    required int horizontalIndex,
  }) {
    final Vector2 animateStart = getVector2(x: 0 + GlobalValue.blockVector.x * horizontalIndex - 1, y: -GlobalValue.blockVector.y);
    return animateStart;
  }

  bool removeBlocks({
    required Component component,
    required int removeIndex
  }) {
    final SpriteComponent spriteComponent = component as SpriteComponent;
    final blockPositionY = GlobalValue.blockVector.y * removeIndex + GlobalValue.blockOffsetY;
    final num blockY = blockPositionY.round();
    final num componentY = spriteComponent.y.round();
    final bool isCurrentPosition = blockY == componentY;
    return isCurrentPosition;
  }

  void checkUpdateFallingBlocks({
    // required List<GameBlockModel> gameBlockMap,
    required ComponentSet children,
    required int horizontalIndex,
    required Function(VerticalBlockModel) onAddToUpdate
  }) {
    int blockEmptySum = 0;
    for (int i = 5 - 1; i >= 0; i--) {
      final Vector2 currentPosition = getVector2(x: GlobalValue.blockVector.x * horizontalIndex + 0, y: GlobalValue.blockVector.y * i);
      final bool isSpaceHasBlock = children.toList().any((b) {
        final position = (b as SpriteComponent).position;
        final positionY = position.y.round();
        final currentPositionY = currentPosition.y.round();
        return positionY - currentPositionY == 0;
      }); /// 檢查每空格是否具有方塊
      if(isSpaceHasBlock == false) {
        blockEmptySum++;
      }

      /// 第一個方塊(i != 0) 不需計算掉落
      if (isSpaceHasBlock) {
        final SpriteComponent spriteComponent = children.toList().firstWhere((child) {
          final SpriteComponent spriteComponent = child as SpriteComponent;
          final blockPositionY = GlobalValue.blockVector.y * i + GlobalValue.blockOffsetY;
          final num blockY = blockPositionY.round();
          final num componentY = spriteComponent.y.round();
          final bool isContain = blockY == componentY;
          return isContain;
        }) as SpriteComponent;
        final VerticalBlockModel model = VerticalBlockModel(spriteComponent: spriteComponent, dropNumber: blockEmptySum);
        onAddToUpdate(model);
      }
    }
  }

  movingUpdateFallingBlocks({
    required List<VerticalBlockModel> toUpdate,
    required Function onMoveEffectDone
  }) {
    int onCompleteSum = 0;
    for (var model in toUpdate) {
      final Vector2 newPosition = model.spriteComponent.position + Vector2(0, GlobalValue.blockVector.y * model.dropNumber);
      final EffectController controller = EffectController(duration: 0.4, curve: Curves.elasticInOut);
      final MoveEffect moveEffect = MoveEffect.to(
        newPosition,
        controller,
        onComplete: () {
          onCompleteSum++;
          if(onCompleteSum == toUpdate.length) {
            onMoveEffectDone();
          }
        }
      );
      model.spriteComponent.add(moveEffect);
    }
  }

  /// 補齊缺少區塊
  void addFallingBlocks({
    required List<GameBlockModel> gameBlockMap,
    required ComponentSet children,
    required Function(int) onLoadGameBlock
  }) {
    final int missingBlocksCount = gameBlockMap.length - children.length;
    for (int i = missingBlocksCount - 1; i >= 0; i--) {
      onLoadGameBlock(i);
    }
  }
}