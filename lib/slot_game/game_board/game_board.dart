import 'dart:developer';

import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/const/global_value.dart';
import 'package:example_slot_game/extension/game_block_type.dart';
import 'package:example_slot_game/slot_game/game_board/game_board_view_model.dart';
import 'package:example_slot_game/slot_game/horizontal_board/horizontal_board.dart';
import 'package:example_slot_game/slot_game/vertical_board/vertical_board.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
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

    /// 載入跑馬燈
    _loadMarquee();

    // 載入按鈕
    _loadFlashBtn();
    _loadAutoSpinBtn();
    _loadRefreshBtn();

    _loadOrderBtn();
    _loadSettingBtn();
    _loadWiFiIcon();
    _loadWinIcon();
    super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }

  _loadWiFiIcon() async {
    final Sprite sprite = await Sprite.load('icons/Wifi_4.png');
    final SpriteComponent btnComponent = SpriteComponent(
        sprite: sprite,
        anchor: Anchor.center,
        size: Vector2(50, 50),
        position: Vector2(400, 700),
    );
    add(btnComponent);
  }

  _loadWinIcon() async {
    final Sprite sprite = await Sprite.load('GameTXT/Super_Win_2.png');
    final SpriteComponent btnComponent = SpriteComponent(
      sprite: sprite,
      anchor: Anchor.center,
      size: Vector2(100, 50),
      position: Vector2(-150, 500),
    );
    add(btnComponent);
  }

  _clipMarquee(SpriteComponent spriteComponent) {
    final ClipComponent clipMarquee = ClipComponent.rectangle(
        // anchor: Anchor.center,
        size: Vector2(530, 100),
        position: Vector2(-120, -285),
        children: [spriteComponent]
    );
    add(clipMarquee);
  }

  _effectMarquee(SpriteComponent spriteComponent) {
    final EffectController controller = EffectController(duration: 5, infinite: true, startDelay: 2, atMinDuration: 2, atMaxDuration: 2);
    final endPosition = Vector2(-700, 0);
    final MoveEffect moveEffect = MoveEffect.to(endPosition, controller);
    spriteComponent.add(moveEffect);
  }

  _loadMarquee() async {
    final Sprite marqueeSprite = await Sprite.load('marquee/marquee_12.png');
    final SpriteComponent spriteComponent = SpriteComponent(sprite: marqueeSprite,);
    _clipMarquee(spriteComponent);
    _effectMarquee(spriteComponent);
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
  }

  _loadHorizontalBoard(int horizontalIndex) {
    final HorizontalBoard horizontalBoard = HorizontalBoard(

    );
    add(horizontalBoard);
  }

  _loadFlashBtn() async {
    final Vector2 position = currentLayoutMode == LayoutMode.landscape ? Vector2(600, 500) : Vector2(320, 600);
    _loadBtn(
        spritePath: 'navigation/flash_on.png',
        position: position,
        size: Vector2(100, 100),
        onPressed: () {}
    );
  }

  _loadAutoSpinBtn() {
    final Vector2 position = currentLayoutMode == LayoutMode.landscape ? Vector2(500, 500) : Vector2(200, 600);
    _loadBtn(
      spritePath: 'navigation/auto.png',
      position: position,
      size: Vector2(100, 100),
      onPressed: () => viewModel.playAuto(verticalList: verticalList)
    );
  }

  _loadOrderBtn() {
    final Vector2 position = currentLayoutMode == LayoutMode.landscape ? Vector2(-500, 500) : Vector2(-200, 600);
    _loadBtn(
        spritePath: 'navigation/order.png',
        position: position,
        size: Vector2(100, 100),
        onPressed: () {

        }
    );
  }

  _loadSettingBtn() { //
    final Vector2 position = currentLayoutMode == LayoutMode.landscape ? Vector2(-600, 500) : Vector2(-400, 600);
    _loadBtn(
        spritePath: 'navigation/setting.png',
        position: position,
        size: Vector2(100, 100),
        onPressed: () {

        }
    );
  }

  _loadRefreshBtn() { //
    final Vector2 position = currentLayoutMode == LayoutMode.landscape ? Vector2(-600, 500) : Vector2(0, 600);
    _loadBtn(
        spritePath: 'navigation/icons_23.png',
        position: position,
        size: Vector2(200, 170),
        onPressed: () => viewModel.playOnce(verticalList: verticalList)
    );
  }

  _loadBtn({
    required String spritePath,
    required Vector2 position,
    required Vector2 size,
    required Function() onPressed
  }) async {
    final Sprite btnSprite = await Sprite.load(spritePath);
    final SpriteButtonComponent btnComponent = SpriteButtonComponent(
        anchor: Anchor.center,
        button: btnSprite,
        size: size,
        position: position,
        onPressed: () => onPressed()
    );
    add(btnComponent);
  }

  @override
  void onRemove() {
    removeAll(children);
    super.onRemove();
  }
}
