

import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/const/global_cache.dart';
import 'package:example_slot_game/const/global_value.dart';
import 'package:example_slot_game/model/game_block_model.dart';
import 'package:example_slot_game/model/res/slot/detail_list_info/detail_list_info.dart';
import 'package:example_slot_game/model/res/slot/slot_res.dart';
import 'package:example_slot_game/model/vertical_block_model.dart';
import 'package:example_slot_game/slot_game/single_block/single_block.dart';
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
    required int verticalIndex,
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

  bool _checkSpaceHasBlock({
    required ComponentSet children,
    required Vector2 currentPosition,
  }) {
    final bool isSpaceHasBlock = children.toList().any((b) {
      final position = (b as SpriteComponent).position;
      final positionY = position.y.round();
      final currentPositionY = currentPosition.y.round();
      return positionY - currentPositionY == 0;
    });
    return isSpaceHasBlock;
  }

  SingleBlock? _getSingleBlock({
    required ComponentSet children,
    required Vector2 currentPosition,
  }) {
    final List<SingleBlock> blockList = children.map((child) => child as SingleBlock).toList();
    try {
      final SingleBlock resultBlock = blockList.firstWhere((block) {
        final positionY = block.position.y.round();
        final currentPositionY = currentPosition.y.round();
        return positionY - currentPositionY == 0;
      });
      return resultBlock;
    } catch(e) {
      return null;
    }
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
      final bool isSpaceHasBlock = _checkSpaceHasBlock(children: children, currentPosition: currentPosition);
      final SingleBlock? singleBlock = _getSingleBlock(children: children, currentPosition: currentPosition);
      final isTransparentOrNull = singleBlock?.isTransparent ?? true;
      if(isTransparentOrNull) {
        blockEmptySum += verticalGameBlockMap[i].coverNumber.toInt();

        /// 檢查是否為全部空白
        if(blockEmptySum == 5) {
          final VerticalBlockModel model = VerticalBlockModel(spriteComponent: SpriteComponent(), dropNumber: -1);
          onAddToUpdate(model);
        }
        continue;
      }

      /// 第一個方塊(i != 0) 不需計算掉落
      if (isSpaceHasBlock) {
        final num coverNumber = verticalGameBlockMap[i].coverNumber.toInt();
        /// 取得方塊大小, 計算範圍內方塊需要掉落數目
        for(int j = 0; j < coverNumber; j++) {
          final SpriteComponent spriteComponent = children.toList().firstWhere((child) {
            final SpriteComponent spriteComponent = child as SpriteComponent;
            final blockPositionY = (GlobalValue.blockVector.y * (i - j)) + GlobalValue.blockOffsetY;
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
  }

  movingUpdateFallingBlocks({
    required List<VerticalBlockModel> toUpdate,
    required Function onMoveEffectDone
  }) {
    int onCompleteSum = 0;
    for (var model in toUpdate) {
      if(model.dropNumber == -1) {
        onMoveEffectDone();
        return ;
      }
      final double newPositionX = (model.spriteComponent.position.x).roundToDouble() ?? 0;
      final double newPositionY = (model.spriteComponent.position.y + (GlobalValue.blockVector.y * model.dropNumber)).roundToDouble();
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

  /// 補齊缺少區塊, 並計算需要掉落幾塊則callback幾次
  void addFallingBlocks({
    required ComponentSet children,
    required List<GameBlockModel> verticalGameBlockMap,
    required num horizontalIndex,
    required Function(int) onLoadGameBlock
  }) {
    final SlotRes slotRes = GlobalCache.slotRes;
    final num currentRound = GlobalCache.comboRoundCount;
    final num nextRound = GlobalCache.comboRoundCount + 1;
    final List<String> line = slotRes.detail?.detailList?[currentRound.toInt()].roundList?.expand((round) => round.line as List<String>).toList() ?? [];
    final int totalLackNumber = line.where((info) {
      final List<String> part = info.split(',');
      final num index = num.tryParse(part[0]) ?? 999;
      return index == horizontalIndex;
    }).fold<int>(0, (sum, info) {
      final List<String> part = info.split(',');
      final int y = int.tryParse(part[1]) ?? 999;
      final List<String?> itemList = slotRes.detail?.detailList?[currentRound.toInt()].itemMap?[horizontalIndex.toInt()] ?? [];
      final String item = itemList[y - 1] ?? '';
      final String numberStr = item.split('')[2];
      final int number = int.tryParse(numberStr) ?? 0;
      return sum + number;
    });

    if(totalLackNumber == 0) return;

    /// 根據下一場需要替補多少給予位置與callback次數
    for(int i = totalLackNumber; i > 0; i--) {
      final nextItemList = slotRes.detail?.detailList?[nextRound.toInt()].itemMap?[horizontalIndex.toInt()] ?? [];
      final startIndex = 5 - i;
      final String nextItem = nextItemList[startIndex] ?? '';
      if(nextItem != '') {
        onLoadGameBlock(4 - startIndex);
      }
    }
  }

  String getImgName({
    required int matrixX,
    required int matrixY,
  }) {
    final int currentRound = GlobalCache.comboRoundCount.toInt();
    final DetailListInfo? info = GlobalCache.slotRes.detail?.detailList?[currentRound + 1];
    final List<String?> list = info?.itemMap?[matrixX].reversed.toList() ?? [];
    final String nameStr = list[matrixY] ?? '';
    if(nameStr.isEmpty) return '';
    final List<String> part = nameStr.split('');
    final String name = part[0] + part[1] + part[2];
    print('name: $name');
    return name;
  }

  bool getIsGold({
    required int matrixX,
    required int matrixY,
  }) {
    final int currentRound = GlobalCache.comboRoundCount.toInt();
    final DetailListInfo? info = GlobalCache.slotRes.detail?.detailList?[currentRound + 1];
    final List<String?> list = info?.itemMap?[matrixX].reversed.toList() ?? [];
    final String nameStr = list[matrixY] ?? '';
    if(nameStr.isEmpty) return false;
    final List<String> part = nameStr.split('');
    bool isGold;
    try {
      isGold = part[3] == 'g';
    } catch (e) {
      isGold = false;
    }
    return isGold;
  }

  num getCoverNumber({
    required int matrixX,
    required int matrixY,
}) {
    final int currentRound = GlobalCache.comboRoundCount.toInt();
    final DetailListInfo? info = GlobalCache.slotRes.detail?.detailList?[currentRound + 1];
    final List<String?> list = info?.itemMap?[matrixX].reversed.toList() ?? [];
    final String nameStr = list[matrixY] ?? '';
    if(nameStr.isEmpty) return 0;
    final List<String> part = nameStr.split('');
    final num coverNumber = num.tryParse(part[2]) ?? 0;
    return coverNumber;
  }
}