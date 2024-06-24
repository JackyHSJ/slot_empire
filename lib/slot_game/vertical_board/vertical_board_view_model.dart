

import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/const/global_cache.dart';
import 'package:example_slot_game/const/global_value.dart';
import 'package:example_slot_game/model/game_block_model.dart';
import 'package:example_slot_game/model/res/slot/slot_res.dart';
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
    final double resultX = x + GlobalValue.blockOffsetX + horizontalWidth;
    final double resultY = y + GlobalValue.blockOffsetY + verticalHigh;
    return Vector2(resultX.roundToDouble(), resultY.roundToDouble());
  }

  Vector2 getBlockAnimateStartVector2({
    required int horizontalIndex,
  }) {
    final double resultX = 0 + GlobalValue.blockVector.x * horizontalIndex - 1;
    final double resultY = -GlobalValue.blockVector.y;
    final Vector2 animateStart = getVector2(x: resultX.roundToDouble(), y: resultY.roundToDouble());
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
    required List<GameBlockModel> verticalGameBlockMap,
    required ComponentSet children,
    required int horizontalIndex,
    required Function(VerticalBlockModel) onAddToUpdate
  }) {
    int blockEmptySum = 0;
    for (int i = verticalGameBlockMap.length - 1; i >= 5; i--) {
      final Vector2 currentPosition = getVector2(x: GlobalValue.blockVector.x * horizontalIndex + 0, y: GlobalValue.blockVector.y * i);
      final bool isSpaceHasBlock = children.toList().any((b) {
        final position = (b as SpriteComponent).position;
        final positionY = position.y.round();
        final currentPositionY = currentPosition.y.round();
        return positionY - currentPositionY == 0;
      });

      /// 檢查每空格是否具有方塊
      if(isSpaceHasBlock == false) {
        blockEmptySum += verticalGameBlockMap[i].coverNumber.toInt();
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
      final double newPositionX = (model.spriteComponent.position.x).roundToDouble();
      final double newPositionY = (model.spriteComponent.position.y +(GlobalValue.blockVector.y * model.dropNumber)).roundToDouble();
      final Vector2 newPosition = Vector2(newPositionX, newPositionY);
      final EffectController controller = EffectController(duration: 0.4, curve: Curves.elasticInOut);
      print('new position: ${newPosition}');
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
    required num horizontalIndex,
    required Function(int) onLoadGameBlock
  }) {
    final SlotRes slotRes = GlobalCache.slotRes;
    final List<String> line = slotRes.detail?.detailList?.first.roundList?.first.line ?? [];
    final List<String> resultList = line.where((info) {
      final List<String> part = info.split(',');
      final num index = num.tryParse(part[0]) ?? 999;
      return index == horizontalIndex;
    }).toList();

    for (int i = resultList.length - 1; i >= 0; i--) {
      onLoadGameBlock(i);
    }
  }
}