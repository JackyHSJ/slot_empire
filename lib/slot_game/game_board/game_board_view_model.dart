
import 'dart:math';

import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/const/global_cache.dart';
import 'package:example_slot_game/const/global_value.dart';
import 'package:example_slot_game/extension/game_block_type.dart';
import 'package:example_slot_game/extension/string.dart';
import 'package:example_slot_game/model/game_block_model.dart';
import 'package:example_slot_game/model/res/slot/detail_list_info/detail_list_info.dart';
import 'package:example_slot_game/model/res/slot/round_list_info/round_list_info.dart';
import 'package:example_slot_game/model/res/slot/slot_res.dart';
import 'package:example_slot_game/slot_game/horizontal_board/horizontal_board.dart';
import 'package:example_slot_game/slot_game/vertical_board/vertical_board.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

class GameBoardViewModel {
  GameBoardViewModel({
    required this.ref
  });
  ComponentRef ref;

  List<GameBlockModel> verticalGameBlockMap = [];
  List<List<GameBlockModel>> allVerticalGameBlockMap = [];
  List<GameBlockModel> horizontalGameBlockMap = [];

  SpinType spinType = SpinType.none;
  bool _autoBtnEnable = false;
  bool _flashBtnEnable = false;

  init() {
    _getRandom();
  }

  dispose() {

  }

  _getRandom() {
    final Random random = Random();
    final SlotRes slotRes = GlobalCache.slotRes;

    /// 直
    /// index 0 ~ 4 塞入隨機值
    allVerticalGameBlockMap = [];
    for(int i = 0; i < 6; i++) {
      verticalGameBlockMap = [];
      horizontalGameBlockMap = [];
      for(int j = 0; j < 10; j++) { /// 暫時 10
        final GameBlockType type = GameBlockType.values[random.nextInt(GameBlockType.values.length - 1)];
        final GameBlockModel model = GameBlockModel(type: type, coverNumber: 1);
        verticalGameBlockMap.add(model);
      }

      /// 加入真實資料
      // for(int j = 0; j < 5; j++) {
      //   final String itemStr = slotRes.detail?.detailList?[0].itemMap?[i][j] ?? '';
      //   final GameBlockType blockType = itemStr.getBlockType ?? GameBlockType.wild;
      //   final num coverNumber = itemStr.getBlockCoverNumber;
      //   final bool isGold = itemStr.isGold;
      //   final GameBlockModel gameBlockModel = GameBlockModel(type: blockType, coverNumber: coverNumber, isGold: isGold);
      //   verticalGameBlockMap.add(gameBlockModel);
      // }

      allVerticalGameBlockMap.add(verticalGameBlockMap);
    }


    /// 橫
    /// index 0 ~ 3 塞入隨機值
    // for(int i = 0; i < 4; i++) {
    //   final String itemStr = slotRes.detail?.detailList?[0].itemMap?.last[i] ?? '';
    //   final GameBlockType blockType = itemStr.getBlockType ?? GameBlockType.wild;
    //   final num coverNumber = itemStr.getBlockCoverNumber;
    //   final bool isGold = itemStr.isGold;
    //   final GameBlockModel gameBlockModel = GameBlockModel(type: blockType, coverNumber: coverNumber, isGold: isGold);
    //   horizontalGameBlockMap.add(gameBlockModel);
    // }

    for(int i = 0; i < 8; i++) {
      final GameBlockType type = GameBlockType.values[random.nextInt(GameBlockType.values.length - 1)];
      final GameBlockModel model = GameBlockModel(type: type, coverNumber: 1);
      horizontalGameBlockMap.add(model);
    }
  }

  Future<void> checkAndRemoveRewardBlock({
    required List<VerticalBoard> verticalList,
    required List<HorizontalBoard> horizontalList,
  }) async {
    /// 取得消除Type
    final SlotRes slotRes = GlobalCache.slotRes;
    final List<RoundListInfo> roundList = slotRes.detail?.detailList?.first.roundList ?? [];
    if(roundList.isEmpty) return;
    final GameBlockType removeType = roundList.first.item?.getBlockType ?? GameBlockType.none;
    final List<GameBlockType> rewardTypeList = [removeType];

    /// 全部轉暗
    _turnAllBlockTheme(verticalList, enableLight: false);

    List<Future> removeVerticalFutures = [];
    for(int i = 0; i < verticalList.length; i++) {
      removeVerticalFutures.add(_removeVertical(verticalList[i], rewardTypeList: rewardTypeList));
    }
    await Future.wait(removeVerticalFutures);
    _removeHorizontal(horizontalList.single);

    /// 全部亮起
    _turnAllBlockTheme(verticalList, enableLight: true);

    await Future.delayed(const Duration(seconds: 1));
    _sortGameBlockComponentList(verticalList);

    print("已移除匹配方塊並更新方塊位置");
    print("stop");
  }

  _turnAllBlockTheme(List<VerticalBoard> verticalList, {
    required bool enableLight
  }) {
    verticalList.forEach((vertical) {
      if(enableLight == true) vertical.turnAllBlockLight();
      if(enableLight == false) vertical.turnAllBlockDark();
    });
  }

  _sortGameBlockComponentList(List<VerticalBoard> verticalList) {
    for(int i = 0; i < verticalList.length; i++) {
      verticalList[i].gameBlockComponentList.sort((a, b) => a.position.y.compareTo(b.position.y));
    }
  }

  Future<void> _removeHorizontal(HorizontalBoard horizontal) async {
    horizontal.removeBlocks(removeIndex: 0);
    horizontal.removeBlocks(removeIndex: 2);

    await Future.delayed(const Duration(milliseconds: 100));
    horizontal.updateFallingBlocks();
  }

  Future<void> _removeVertical(VerticalBoard vertical, {
    required List<GameBlockType> rewardTypeList
  }) async {
    final List<GameBlockModel> verticalGameBlockMap = vertical.verticalGameBlockMap;
    final List<int> indicesToRemove = List<int>.generate(verticalGameBlockMap.length, (i) => i)
        .where((i) => i >= 5 && rewardTypeList.contains(verticalGameBlockMap[i].type))
        .toList();

    final List<int> list = indicesToRemove.reversed.toList();
    await vertical.removeBlockEffect(removeIndexList: list);
    await vertical.removeDestroyEffect(removeIndexList: list);
    vertical.removeBlocks(removeIndexList: list);

    await Future.delayed(const Duration(milliseconds: 100));
    vertical.updateFallingBlocks();
  }

  Future<void> startSpin({
    required List<VerticalBoard> verticalList,
    required List<HorizontalBoard> horizontalList,
    // required onLoadMoreBlockToSpin
  }) async {
    for(int i = 0; i < allVerticalGameBlockMap.length; i++) {
      verticalList[i].startSpin(spinType);
    }
    horizontalList.single.startSpin(spinType);
    spinType = SpinType.spin;
  }

  Future<void> stopSpin({
    required bool flashBtnEnable,
    required List<VerticalBoard> verticalList,
    required List<HorizontalBoard> horizontalList,
  }) async {
    horizontalList.single.stopSpin(spinType);
    for(int i = 0; i < allVerticalGameBlockMap.length; i++) {
      verticalList[i].stopSpin(spinType);
      await _getStopSpinDelayTime(flashBtnEnable);
    }
    spinType = SpinType.stop;
  }

  Future<void> _getStopSpinDelayTime(bool flashBtnEnable) async {
    /// 快速模式
    if(flashBtnEnable == true) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    if(flashBtnEnable == false) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  /// 加入後端資料
  updateSprite({
    required List<VerticalBoard> verticalList,
  }) {
    final SlotRes slotRes = GlobalCache.slotRes;
    final List<DetailListInfo> detailList = slotRes.detail?.detailList ?? [];
    final List<List<String?>> itemMap = detailList[0].itemMap ?? [];
    if(itemMap.isEmpty) return ;
    _updateAllGameBlockMapFromAPI(itemMap);

    for(int i = 0; i < 6; i++) {
      verticalList[i].verticalGameBlockMap = allVerticalGameBlockMap[i];
      for(int j = 5; j < 10; j++) {
        final GameBlockType type = allVerticalGameBlockMap[i][j].type;
        final single = verticalList[i].gameBlockComponentList.firstWhere((block) {
          final blockY = block.y.roundToDouble();
          final globalBlockY = (GlobalValue.blockVector.y * j).roundToDouble();
          return blockY == globalBlockY;
        });

        final String item = itemMap[i][j - 5] ?? '';
        final num coverNumber = item.getBlockCoverNumber;
        if(coverNumber == 0) {
          single.removeBlock();
          continue;
        }
        single.updateSprite(
          imgPath: type.getBlockImgPath(coverNumber),
          coverNumber: coverNumber,
          isGold: item.isGold
        );
        // verticalList[i].gameBlockComponentList[j].updateSprite(type.getBlockImgPath(1));
      }
    }
  }

  _updateAllGameBlockMapFromAPI(List<List<String?>> itemMap) {
    for(int i = 0; i < 6; i++) {
      for (int j = 0; j < 5; j++) {
        final String item = itemMap[i][j] ?? '';
        final GameBlockType type = item.getBlockType ?? GameBlockType.none;
        final num coverNumber = item.getBlockCoverNumber;
        final bool isGold = item.isGold;
        allVerticalGameBlockMap[i][j + 5] = GameBlockModel(type: type, coverNumber: coverNumber, isGold: isGold);
      }
    }
  }

  Future<void> actionSpin({
    required bool flashBtnEnable,
    required List<VerticalBoard> verticalList,
    required List<HorizontalBoard> horizontalList,
  }) async {
    if(spinType == SpinType.stop || spinType == SpinType.none) {
      await startSpin(verticalList: verticalList, horizontalList: horizontalList);
    }

    updateSprite(verticalList: verticalList);
    await _getActionDelayTime(flashBtnEnable);

    if(spinType == SpinType.spin) {
      await stopSpin(verticalList: verticalList, horizontalList: horizontalList, flashBtnEnable: flashBtnEnable);
    }
  }

  Future<void> _getActionDelayTime(bool flashBtnEnable) async {
    if(flashBtnEnable == false) {
      await Future.delayed(const Duration(seconds: 2));
    }
    if(flashBtnEnable == true) {
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  playOnce({
    required List<VerticalBoard> verticalList,
    required List<HorizontalBoard> horizontalList,
  }) async {
    await actionSpin(verticalList: verticalList, horizontalList: horizontalList, flashBtnEnable: _flashBtnEnable);
    await checkAndRemoveRewardBlock(verticalList: verticalList, horizontalList: horizontalList);
  }

  playAuto({
    required List<VerticalBoard> verticalList,
    required List<HorizontalBoard> horizontalList,
  }) async {
    _autoBtnEnable = !_autoBtnEnable;
    while(_autoBtnEnable) {
      await actionSpin(verticalList: verticalList, horizontalList: horizontalList, flashBtnEnable: _flashBtnEnable);
      await checkAndRemoveRewardBlock(verticalList: verticalList, horizontalList: horizontalList);
      await Future.delayed(const Duration(seconds: 1));
    }
  }

  flash() {
    _flashBtnEnable = !_flashBtnEnable;
  }
}