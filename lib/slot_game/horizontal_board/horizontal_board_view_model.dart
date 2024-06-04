

import 'package:example_slot_game/const/global_value.dart';
import 'package:example_slot_game/model/game_block_model.dart';
import 'package:example_slot_game/model/horizontal_block_model.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/animation.dart';

class HorizontalBoardViewModel {

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
    required int index,
  }) {
    final double horizontalWidth = index * blockWidth;
    return Vector2(x + GlobalValue.blockOffsetX + horizontalWidth, y + GlobalValue.blockOffsetY);
  }

  Vector2 getBlockAnimateStartVector2() {
    final Vector2 animateStart = getVector2(x: 0 + GlobalValue.blockVector.x * 4, y: 0);
    return animateStart;
  }

  bool removeBlocks({
    required Component component,
    required int removeIndex
  }) {
    final SpriteComponent spriteComponent = component as SpriteComponent;
    final blockPositionY = GlobalValue.blockVector.x * removeIndex + GlobalValue.blockOffsetX;
    final num blockX = blockPositionY.round();
    final num componentX = spriteComponent.x.round();
    final bool isCurrentPosition = blockX == componentX;
    return isCurrentPosition;
  }

  void checkUpdateFallingBlocks({
    required ComponentSet children,
    required Function(HorizontalBlockModel) onAddToUpdate
  }) {
    int blockEmptySum = 0;
    for (int i = 0; i < 4; i++) {
      final Vector2 currentPosition = getVector2(x: GlobalValue.blockVector.x * i, y: 0);
      final bool isSpaceHasBlock = children.toList().any((b) {
        final position = (b as SpriteComponent).position;
        final positionX = position.x.round();
        final currentPositionX = currentPosition.x.round();
        return positionX - currentPositionX == 0;
      }); /// 檢查每空格是否具有方塊
      if(isSpaceHasBlock == false) {
        blockEmptySum++;
      }

      /// 第一個方塊(i != 0) 不需計算掉落
      if (isSpaceHasBlock) {
        final SpriteComponent spriteComponent = children.toList().firstWhere((child) {
          final SpriteComponent spriteComponent = child as SpriteComponent;
          final blockPositionX = GlobalValue.blockVector.x * i + GlobalValue.blockOffsetX;
          final num blockX = blockPositionX.round();
          final num componentX = spriteComponent.x.round();
          final bool isContain = blockX == componentX;
          return isContain;
        }) as SpriteComponent;
        final HorizontalBlockModel model = HorizontalBlockModel(spriteComponent: spriteComponent, dropNumber: blockEmptySum);
        onAddToUpdate(model);
      }
    }
  }

  movingUpdateFallingBlocks({
    required List<HorizontalBlockModel> toUpdate,
    required Function onMoveEffectDone
  }) {
    int onCompleteSum = 0;
    for (var model in toUpdate) {
      final Vector2 newPosition = model.spriteComponent.position + Vector2(-GlobalValue.blockVector.x * model.dropNumber, 0);
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
    required List<GameBlockModel> horizontalGameBlockMap,
    required ComponentSet children,
    required Function(int) onLoadGameBlock
  }) {
    final int missingBlocksCount = horizontalGameBlockMap.length - children.length;
    for (int i = missingBlocksCount; i < 4; i++) {
      onLoadGameBlock(i);
    }
  }
}