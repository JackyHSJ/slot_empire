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
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class VerticalBoard extends PositionComponent {
  VerticalBoard({
    required this.horizontalIndex,
    required this.verticalGameBlockMap,
  }): super(position: Vector2(0, -420), anchor: Anchor.center); // 顯示6 ~ 10 行

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
    final GameBlockModel gameBlockModel = verticalGameBlockMap[verticalIndex];
    final num coverNum = gameBlockModel.coverNumber;
    final String imgPath = gameBlockModel.getBlockImgPath;
    if(imgPath == '') return ;
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
    final bool isGold = gameBlockModel.isGold;

    final SingleBlock gameBlockComponent = SingleBlock(
      startPosition: startPosition,
      gameBlockSprite: gameBlockSprite,
      coverNum: coverNum,
      isGold: isGold
    );

    if(addFallingBlocks == false) {
      gameBlockComponentList.add(gameBlockComponent);
      add(gameBlockComponent);
    }

    if (addFallingBlocks == true) {
      final String imgName = viewModel.getImgName(matrixX: horizontalIndex, matrixY: verticalIndex);
      final bool isGold = viewModel.getIsGold(matrixX: horizontalIndex, matrixY: verticalIndex);
      final num coverNumber = viewModel.getCoverNumber(matrixX: horizontalIndex, matrixY: verticalIndex);

      if(imgName == '' || coverNumber == 0) return ;

      gameBlockComponent.updateSprite(imgPath: 'Game BLocks/$imgName.png', coverNumber: coverNumber, isGold: isGold);

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

  removeOtherVerticalBlock() {
    final int length = children.length;
    print('123 length: $length');
  }

  /// 中獎檢查, 為中獎轉暗, 中獎轉亮
  Future<void> removeBlockEffect({
    required List<int> removeIndexList
  }) async {
    if (removeIndexList.isEmpty) return;
    List<Future> futures = [];
    for (var index in removeIndexList) {
      final singleBlock = gameBlockComponentList.firstWhere((block) {
        final double blockY = block.position.y.roundToDouble();
        final double removeBlockY = (GlobalValue.blockVector.y * index).roundToDouble();
        return blockY == removeBlockY;
      });
      futures.add(singleBlock.loadBlockAnimate());
      // futures.add(singleBlock.loadDestroyAnimate());
    }
    await Future.wait(futures);
  }

  removeDestroyEffect({
    required List<int> removeIndexList
  }) async {
    if (removeIndexList.isEmpty) return;
    List<Future> futures = [];
    for (var index in removeIndexList) {
      final singleBlock = gameBlockComponentList.firstWhere((block) {
        final double blockY = block.position.y.roundToDouble();
        final double removeBlockY = (GlobalValue.blockVector.y * index).roundToDouble();
        return blockY == removeBlockY;
      });
      futures.add(singleBlock.turnTransparent());
      futures.add(singleBlock.loadDestroyAnimate());
    }
    await Future.wait(futures);
  }

  turnAllBlockLight() {
    gameBlockComponentList.forEach((singleBlock){
      singleBlock.turnLight();
    });
  }

  turnAllBlockDark() {
    gameBlockComponentList.forEach((singleBlock){
      singleBlock.turnDark();
    });
  }

  void removeBlocks({
    required List<int> removeIndexList
  }) {
    removeIndexList.forEach((removeIndex) {
      removeWhere((component) => viewModel.removeBlocks(
          component: component,
          removeIndex: removeIndex,
      ));
      gameBlockComponentList.removeAt(removeIndex);
    });
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
  void moveEffectDone() async {
    viewModel.addFallingBlocks(
      children: children,
      verticalGameBlockMap: verticalGameBlockMap,
      horizontalIndex: horizontalIndex,
      onLoadGameBlock: (index) => _loadGameBlock(index, addFallingBlocks: true)
    );
  }

  startSpin(SpinType spinType) {
    if(spinType == SpinType.spin) {
      return ;
    }
    final Vector2 animateEnd = Vector2(0, GlobalValue.blockVector.y);
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
    final Vector2 finalPosition = viewModel.getVector2(x: -72, y: -420); // 最終顯示 6 ~ 10行
    position = finalPosition;
  }
}
