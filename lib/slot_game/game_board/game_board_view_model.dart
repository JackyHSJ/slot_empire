
import 'dart:math';

import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/const/global_value.dart';
import 'package:example_slot_game/extension/game_block_model_map.dart';
import 'package:example_slot_game/extension/game_block_type.dart';
import 'package:example_slot_game/model/game_block_model.dart';
import 'package:example_slot_game/slot_game/horizontal_board/horizontal_board.dart';
import 'package:example_slot_game/slot_game/vertical_board/vertical_board.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameBoardViewModel {

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
    Random random = Random();
    for(int i = 0; i < 6; i++) {
      verticalGameBlockMap = [];
      horizontalGameBlockMap = [];
      for(int j = 0; j < 10; j++) { /// 暫時 10
        final GameBlockType type = GameBlockType.values[random.nextInt(GameBlockType.values.length)];
        final num coverNumber = random.nextInt(4) + 1;
        /// 暫時模擬
        // if(j == 7) {
        //   final GameBlockModel model = GameBlockModel(type: type, coverNumber: 3);
        //   verticalGameBlockMap.add(model);
        //   continue ;
        // }
        final GameBlockModel model = GameBlockModel(type: type, coverNumber: 1);
        verticalGameBlockMap.add(model);
      }
      allVerticalGameBlockMap.add(verticalGameBlockMap);
    }

    for(int i = 0; i < 8; i++) {
      final GameBlockType type = GameBlockType.values[random.nextInt(GameBlockType.values.length)];
      final GameBlockModel model = GameBlockModel(type: type, coverNumber: 1);
      horizontalGameBlockMap.add(model);
    }
  }

  checkAndRemoveRewardBlock({
    required List<VerticalBoard> verticalList,
    required List<HorizontalBoard> horizontalList,
  }) async {
    final Map<GameBlockType, num> resultMap = allVerticalGameBlockMap.getEachTypeHasSix;
    final List<GameBlockType> rewardTypeList = resultMap.entries
        .where((map) => map.value >= 5) /// 暫時
        .map((rewardBlocks) => rewardBlocks.key).toList();

    for(int i = 0; i < verticalList.length; i++) {
      _removeVertical(verticalList[i], rewardTypeList: rewardTypeList);
    }

    _removeHorizontal(horizontalList.single);

    print("已移除匹配方塊並更新方塊位置");
    print("stop");
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
    for(int i = verticalGameBlockMap.length - 1; i >= 5; i--) {
      final GameBlockType type = verticalGameBlockMap[i].type;
      final bool isContain = rewardTypeList.contains(type);
      if(isContain) {
        vertical.removeBlocks(removeIndex: i);
      }
    }
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

  updateSprite({
    required List<VerticalBoard> verticalList,
  }) {
    allVerticalGameBlockMap.first.first.type = GameBlockType.ten;
    verticalList.first.gameBlockComponentList.first.updateSprite(GameBlockType.ten.getBlockImgPath(1));
  }

  Future<void> actionSpin({
    required bool flashBtnEnable,
    required List<VerticalBoard> verticalList,
    required List<HorizontalBoard> horizontalList,
  }) async {
    if(spinType == SpinType.stop || spinType == SpinType.none) {
      await startSpin(verticalList: verticalList, horizontalList: horizontalList);
    }
    await _getActionDelayTime(flashBtnEnable);

    if(spinType == SpinType.spin) {
      await stopSpin(verticalList: verticalList, horizontalList: horizontalList, flashBtnEnable: flashBtnEnable);
    }
  }

  Future<void>_getActionDelayTime(bool flashBtnEnable) async {
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
    checkAndRemoveRewardBlock(verticalList: verticalList, horizontalList: horizontalList);
  }

  playAuto({
    required List<VerticalBoard> verticalList,
    required List<HorizontalBoard> horizontalList,
  }) async {
    _autoBtnEnable = !_autoBtnEnable;
    while(_autoBtnEnable) {
      await actionSpin(verticalList: verticalList, horizontalList: horizontalList, flashBtnEnable: _flashBtnEnable);
      checkAndRemoveRewardBlock(verticalList: verticalList, horizontalList: horizontalList);
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  flash() {
    _flashBtnEnable = !_flashBtnEnable;
  }
}