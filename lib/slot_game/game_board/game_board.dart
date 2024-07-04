import 'dart:developer';

import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/const/global_cache.dart';
import 'package:example_slot_game/const/global_data.dart';
import 'package:example_slot_game/const/global_value.dart';
import 'package:example_slot_game/extension/game_block_type.dart';
import 'package:example_slot_game/provider/provider.dart';
import 'package:example_slot_game/provider/user_info_provider.dart';
import 'package:example_slot_game/slot_game/game_board/game_board_view_model.dart';
import 'package:example_slot_game/slot_game/game_board/setting_menu/setting_menu.dart';
import 'package:example_slot_game/slot_game/horizontal_board/horizontal_board.dart';
import 'package:example_slot_game/slot_game/vertical_board/vertical_board.dart';
import 'package:example_slot_game/slot_game_center/slot_game_center.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';
import 'package:flame/layout.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/material.dart';

class GameBoard extends PositionComponent with RiverpodComponentMixin {
  GameBoard({
    required this.currentLayoutMode,
    required this.slotGameCenter,
  }): super(priority: 3);

  late GameBoardViewModel viewModel;
  List<VerticalBoard> verticalList = [];
  List<HorizontalBoard> horizontalList = [];

  SlotGameCenter slotGameCenter;
  LayoutMode currentLayoutMode;
  final SettingMenu settingMenu = SettingMenu();

  late SpriteComponent backgroundComponent;

  @override
  Future<void> onLoad() async {
    viewModel = GameBoardViewModel(ref: ref);
    viewModel.init();

    // 載入背景
    await _loadMainBlockBackgroundImg();

    _loadMatrixAndClip();

    /// 載入跑馬燈
    _loadMarquee();

    /// 載入按鈕
    _buildLine();
    _buildDarkMask();
    _loadOrderBtn();
    _loadRefreshBtn();
    _loadAutoSpinBtn();
    _loadFlashBtn();
    _loadSettingBtn();

    _loadWiFiIcon();
    _loadWinIcon();
    _buildWinNumber();
    _buildBalance();
    super.onLoad();
  }

  @override
  void update(double dt) {
    // TODO: implement update
    super.update(dt);
  }

  _buildLine() async {
    final Sprite sprite = await Sprite.load('Common_Item/Ctrl_Panel/Ctrl_Line.png');
    final SpriteComponent spriteComponent = SpriteComponent(
      sprite: sprite,
      scale: Vector2(1.2, 1.2),
      anchor: Anchor.center,
      position: Vector2(0, 500),
    );
    add(spriteComponent);
  }

  _buildDarkMask() {
    final Paint paint = Paint()
      ..color = Colors.black.withOpacity(0.2);
    final RectangleComponent component = RectangleComponent(
        anchor: Anchor.center,
        position: Vector2(0, 600),
        paint: paint, size: Vector2(GlobalData.resolutionLow, 300)
    );
    add(component);
  }

  _loadBtn({
    String? backgroundPath,
    required String spritePath,
    required Vector2 position,
    Vector2? size,
    Vector2? scale,
    String title = '',
    required Function() onPressed
  }) async {
    _loadBtnBackGround(backgroundPath: backgroundPath, position: position, size: size, scale: scale);

    final Sprite btnSprite = await Sprite.load(spritePath);
    final TextComponent textComponent = TextComponent(text: title, position: Vector2(10, 80));
    final SpriteButtonComponent btnComponent = SpriteButtonComponent(
        anchor: Anchor.center,
        button: btnSprite,
        size: size,
        scale: scale,
        position: position,
        children: [
          textComponent,
        ],
        onPressed: () => onPressed()
    );
    add(btnComponent);
  }

  _loadBtnBackGround({
    String? backgroundPath,
    required Vector2 position,
    Vector2? size,
    Vector2? scale,
  }) async {
    if(backgroundPath == null) return ;
    final Sprite btnBackGroundSprite = await Sprite.load(backgroundPath);
    final SpriteComponent spriteComponent = SpriteComponent(
        sprite: btnBackGroundSprite,
        position: position,
        anchor: Anchor.center,
        scale: scale,
        size: size,
    );
    add(spriteComponent);
  }

  _loadFlashBtn() async {
    final Vector2 position = currentLayoutMode == LayoutMode.landscape ? Vector2(600, 500) : Vector2(250, 630);
    _loadBtn(
        backgroundPath: 'Common_Item/Btn/Spin_02.png',
        spritePath: 'Common_Item/Btn/QuickStart_Off.png',
        position: position,
        size: Vector2(80, 80),
        onPressed: () => viewModel.flash()
    );
  }

  _loadAutoSpinBtn() {
    final Vector2 position = currentLayoutMode == LayoutMode.landscape ? Vector2(500, 500) : Vector2(150, 630);
    _loadBtn(
        backgroundPath: 'Common_Item/Btn/Spin_02.png',
        spritePath: 'Common_Item/Btn/AutonPlay_Start.png',
        position: position,
        size: Vector2(80, 80),
        onPressed: () => viewModel.playAuto(verticalList: verticalList, horizontalList: horizontalList)
    );
  }

  _loadOrderBtn() {
    final Vector2 position = currentLayoutMode == LayoutMode.landscape ? Vector2(-500, 500) : Vector2(-150, 630);
    _loadBtn(
        backgroundPath: 'Common_Item/Btn/Spin_02.png',
        spritePath: 'Common_Item/Btn/Bet.png',
        position: position,
        title: 'Bet 3',
        size: Vector2(80, 80),
        onPressed: () {
          print('order');
        }
    );
  }

  _loadSettingBtn() { //
    final Vector2 position = currentLayoutMode == LayoutMode.landscape ? Vector2(-600, 500) : Vector2(-350, 630);
    _loadBtn(
        backgroundPath: 'Common_Item/Btn/Spin_02.png',
        spritePath: 'Common_Item/Btn/setting.png',
        position: position,
        size: Vector2(80, 80),
        onPressed: () => _loadSettingMenu()
    );
  }

  _loadRefreshBtn() { //
    final Vector2 position = currentLayoutMode == LayoutMode.landscape ? Vector2(-600, 500) : Vector2(0, 630);
    _loadBtn(
        backgroundPath: 'Common_Item/Btn/Spin_02.png',
        spritePath: 'Common_Item/Btn/Spin.png',
        position: position,
        size: Vector2(150, 150),
        onPressed: () => viewModel.playOnce(verticalList: verticalList, horizontalList: horizontalList)
    );
  }

  _loadWiFiIcon() async {
    final Sprite sprite = await Sprite.load('Common_Item/Wifi_Icon/Wifi_4.png');
    final SpriteComponent btnComponent = SpriteComponent(
        sprite: sprite,
        anchor: Anchor.center,
        position: Vector2(400, 800),
    );
    add(btnComponent);
  }

  _loadWinIcon() async {
    final Sprite sprite = await Sprite.load('GameTXT/Super_Win_2.png');
    final SpriteComponent btnComponent = SpriteComponent(
      sprite: sprite,
      anchor: Anchor.center,
      size: Vector2(100, 50),
      position: Vector2(-150, 530),
    );
    add(btnComponent);
  }

  _buildWinNumber() {
    final TextComponent textComponent = TextComponent(
        text: '0.00',
        textRenderer: TextPaint(style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600)),
        position: Vector2(-30, 510),
    );
    add(textComponent);
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
    backgroundComponent = SpriteComponent(
        anchor: Anchor.center,
        sprite: backgroundSprite,
        size: newSize,
        position: Vector2(0, 80)
    );
    add(backgroundComponent);
  }

  _loadMatrixAndClip() {
    /// 載入方塊 x 6
    for(int i = 0; i < viewModel.allVerticalGameBlockMap.length; i++) {
      _loadVerticalBoard(i);
    }
    _loadHorizontalBoard();

    /// Clip Vertical
    final ClipComponent verticalClipComponent = ClipComponent.rectangle(
        anchor: Anchor.center,
        size: Vector2(GlobalValue.blockVector.x * 6, GlobalValue.blockVector.y * 5),
        position: Vector2(0, 150),
        children: verticalList
    );
    add(verticalClipComponent);

    /// Clip Horizontal
    final ClipComponent horizontalClipComponent = ClipComponent.rectangle(
        anchor: Anchor.center,
        size: Vector2(GlobalValue.blockVector.x * 4, GlobalValue.blockVector.y * 1),
        position: Vector2(0, -180),
        children: horizontalList,
    );
    add(horizontalClipComponent);
  }

  _loadVerticalBoard(int horizontalIndex) {
    VerticalBoard verticalBoard = VerticalBoard(
      horizontalIndex: horizontalIndex,
      verticalGameBlockMap: viewModel.allVerticalGameBlockMap[horizontalIndex]
    );
    verticalList.add(verticalBoard);
  }

  _loadHorizontalBoard() {
    final HorizontalBoard horizontalBoard = HorizontalBoard(horizontalGameBlockMap: viewModel.horizontalGameBlockMap);
    horizontalList.add(horizontalBoard);
  }

  _loadSettingMenu() async {
    if(settingMenu.isMounted) {
      settingMenu.removeFromParent();
      return ;
    }
    add(settingMenu);
  }

  _buildBalance() {
    final TextComponent balance = TextComponent(
      text: '2,000.00',
      position: Vector2(110, 0),
      textRenderer: TextPaint(style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w600, letterSpacing: -1)),
    );
    final TextComponent textComponent = TextComponent(
      text: 'Balance',
      textRenderer: TextPaint(style: TextStyle(color: Colors.yellowAccent, fontSize: 30)),
      position: Vector2(-150, 730),
      children: [
        balance
      ]
    );
    add(textComponent);
  }

  @override
  void onRemove() {
    removeAll(children);
    super.onRemove();
  }

  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(userInfoProvider, (provider, listener) {
      switch (listener.slotGameStatus) {
        case SlotGameStatus.mainGame:
          _changeMainGameBoard();
          print('mainGame');
          break;
        case SlotGameStatus.freeGame:
          _changeToFreeGameBoard();
          print('freeGame');
          break;
        default:
          break;
      }
    }));
    super.onMount();
  }

  _changeMainGameBoard() async {
    final Sprite backgroundSprite = await Sprite.load('Block BG/Normal_BlockBG.png');
    backgroundComponent.sprite = backgroundSprite;
  }

  _changeToFreeGameBoard() async {
    final Sprite backgroundSprite = await Sprite.load('Block BG/FGMode_BlockBG.png');
    backgroundComponent.sprite = backgroundSprite;
  }
}
