import 'dart:developer';

import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/const/global_value.dart';
import 'package:example_slot_game/extension/game_block_type.dart';
import 'package:example_slot_game/slot_game/game_board/game_board_view_model.dart';
import 'package:example_slot_game/slot_game/horizontal_board/horizontal_board.dart';
import 'package:example_slot_game/slot_game/vertical_board/vertical_board.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class GameBoard extends PositionComponent {
  GameBoard({
    required this.currentLayoutMode
  }): super(priority: 1);

  late GameBoardViewModel viewModel;
  List<VerticalBoard> verticalList = [];
  LayoutMode currentLayoutMode;
  late ClipComponent clipComponent;

  @override
  Future<void> onLoad() async {
    viewModel = GameBoardViewModel();
    viewModel.init();

    // 載入背景
    await _loadMainBlockBackgroundImg();

    _loadVerticalAndClip();

    // 載入按鈕
    _loadStartSpinBtn();
    _loadStopSpinBtn();
    super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }

  _loadMainBlockBackgroundImg() async {
    final Sprite backgroundSprite = await Sprite.load('Block BG/Normal_BlockBG.png');
    Vector2 newSize = Vector2(backgroundSprite.srcSize.x * 1.4, backgroundSprite.srcSize.y * 1.4);
    final SpriteComponent backgroundComponent = SpriteComponent(
      anchor: Anchor.center,
      sprite: backgroundSprite,
      size: newSize,
      position: Vector2(0, 80)
    );
    add(backgroundComponent);
  }

  _loadVerticalAndClip() {
    /// 載入方塊 x 6
    for(int i = 0; i < viewModel.allGameBlockMap.length; i++) {
      _loadVerticalBoard(i);
    }

    print('verticalList: ${verticalList}');
    clipComponent = ClipComponent.rectangle(
        anchor: Anchor.center,
        size: Vector2(GlobalValue.blockVector.x * 6, GlobalValue.blockVector.y * 5),
        position: Vector2(0, 150),
        children: verticalList
    );
    add(clipComponent);
  }

  _loadVerticalBoard(int horizontalIndex) {
    VerticalBoard verticalBoard = VerticalBoard(
      horizontalIndex: horizontalIndex,
      gameBlockMap: viewModel.allGameBlockMap[horizontalIndex]
    );

    verticalList.add(verticalBoard);
    // add(verticalBoard);
  }

  _loadHorizontalBoard(int horizontalIndex) {
    final HorizontalBoard horizontalBoard = HorizontalBoard(

    );
    add(horizontalBoard);
  }

  _loadStartSpinBtn() async {
    final Sprite btnSprite = await Sprite.load('Button BG/SpinBtn_BG.png');

    final Vector2 position = currentLayoutMode == LayoutMode.landscape ? Vector2(600, 500) : Vector2(300, 600);
    final SpriteButtonComponent btnComponent = SpriteButtonComponent(
      anchor: Anchor.center,
      button: btnSprite,
      size: Vector2(200, 200),
      position: position,
      onPressed: () => viewModel.actionSpin(verticalList: verticalList)
    );

    add(btnComponent);
  }

  _loadStopSpinBtn() async {
    final Sprite btnSprite = await Sprite.load('Button BG/Basic_BtnBG.png');
    final Vector2 position = currentLayoutMode == LayoutMode.landscape ? Vector2(-600, 500) : Vector2(-300, 600);
    final SpriteButtonComponent btnComponent = SpriteButtonComponent(
      anchor: Anchor.center,
      button: btnSprite,
      size: Vector2(200, 200),
      position: position,
      onPressed: () => viewModel.checkAndRemoveRewardBlock(verticalList: verticalList)
    );

    add(btnComponent);
  }

  @override
  void onRemove() {
    removeAll(children);
    super.onRemove();
  }
}
