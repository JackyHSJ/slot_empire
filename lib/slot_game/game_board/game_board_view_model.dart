
import 'dart:math';

import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/const/global_value.dart';
import 'package:example_slot_game/extension/game_block_model_map.dart';
import 'package:example_slot_game/extension/game_block_type.dart';
import 'package:example_slot_game/model/game_block_model.dart';
import 'package:example_slot_game/slot_game/vertical_board/vertical_board.dart';
import 'package:flame/effects.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class GameBoardViewModel {

  List<GameBlockModel> gameBlockMap = [];
  List<List<GameBlockModel>> allGameBlockMap = [];
  SpinType spinType = SpinType.none;
  bool _autoBtnEnable = false;

  init() {
    _getRandom();
  }

  dispose() {

  }

  _getRandom() {
    Random random = Random();
    for(int i = 0; i < 6; i++) {
      gameBlockMap = [];
      for(int j = 0; j < 10; j++) {
        final GameBlockType type = GameBlockType.values[random.nextInt(GameBlockType.values.length)];
        final GameBlockModel model = GameBlockModel(type: type);
        gameBlockMap.add(model);
      }
      allGameBlockMap.add(gameBlockMap);
    }
  }

  checkAndRemoveRewardBlock({
    required List<VerticalBoard> verticalList,
  }) async {
    final Map<GameBlockType, num> resultMap = allGameBlockMap.getEachTypeHasSix;
    final List<GameBlockType> rewardTypeList = resultMap.entries
        .where((map) => map.value >= 5)
        .map((rewardBlocks) => rewardBlocks.key).toList();

    for(int i = 0; i < verticalList.length; i++) {
      _remove(verticalList[i], rewardTypeList: rewardTypeList);
    }

    print("已移除匹配方塊並更新方塊位置");
    print("stop");
  }

  Future<void> _remove(VerticalBoard vertical, {
    required List<GameBlockType> rewardTypeList
  }) async {
    final List<GameBlockModel> gameBlockMap = vertical.gameBlockMap;
    for(int i = 5 - 1; i >= 0; i--) {
      final GameBlockType type = gameBlockMap[i].type;
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
    // required onLoadMoreBlockToSpin
  }) async {
    for(int i = 0; i < allGameBlockMap.length; i++) {
      verticalList[i].startSpin(spinType);
      await Future.delayed(const Duration(milliseconds: 500));
    }
    spinType = SpinType.spin;
  }

  Future<void> stopSpin({
    required List<VerticalBoard> verticalList,
  }) async {
    for(int i = 0; i < allGameBlockMap.length; i++) {
      verticalList[i].stopSpin(spinType, verticalIndex: i);
      await Future.delayed(const Duration(milliseconds: 500));
    }
    spinType = SpinType.stop;
  }

  updateSprite({
    required List<VerticalBoard> verticalList,
  }) {
    allGameBlockMap.first.first.type = GameBlockType.ten;
    verticalList.first.gameBlockComponentList.first.updateSprite(GameBlockType.ten.getBlockImgPath);
  }

  Future<void> actionSpin({
    required List<VerticalBoard> verticalList,
  }) async {
    if(spinType == SpinType.stop || spinType == SpinType.none) {
      await startSpin(verticalList: verticalList);
    }

    if(spinType == SpinType.spin) {
      await stopSpin(verticalList: verticalList);
    }
  }

  playOnce({
    required List<VerticalBoard> verticalList,
  }) async {
    await actionSpin(verticalList: verticalList);
    checkAndRemoveRewardBlock(verticalList: verticalList);
  }

  playAuto({
    required List<VerticalBoard> verticalList,
  }) async {
    _autoBtnEnable = !_autoBtnEnable;
    while(_autoBtnEnable) {
      await actionSpin(verticalList: verticalList);
      checkAndRemoveRewardBlock(verticalList: verticalList);
      await Future.delayed(const Duration(seconds: 2));
    }
  }
}