
import 'dart:ui';

import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/const/global_data.dart';
import 'package:example_slot_game/provider/provider.dart';
import 'package:example_slot_game/slot_game/game_board/game_board.dart';
import 'package:example_slot_game/slot_game_center/background/background_board.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flame_spine/flame_spine.dart';
import 'package:flutter/material.dart';

class SlotGameCenter extends FlameGame with RiverpodGameMixin {
  SlotGameCenter(): super();

  late Function stateCallbackHandler;
  //當前使用的 layout mode.
  LayoutMode _layoutMode = LayoutMode.none;
  late SpineComponent spineSnowGlobe;
  late SpineComponent spineTest;

  /// 當前的排版模式。
  LayoutMode get currentLayoutMode {
    return _layoutMode;
  }

  @override
  Future<void> onLoad() async {
    //根據當前 game size aspect ratio 來設定 LayoutMode, 同時決定攝影機 fixedResolution.
    _layoutBySize(size);

    //這邊設定專案的設計解析度。(美術決定)
    // camera.viewport.anchor = Anchor.center;

    //The white rect. Just for showing the debug frame.
    // final RectangleComponent rectangle = RectangleComponent(
    //     size: Vector2(GlobalData.resolutionLow, GlobalData.resolutionHigh),
    //     anchor: Anchor.center,
    //     paint: Paint()..color = Colors.transparent
    // );
    // world.add(rectangle);

    //This is the slot machine!
    // slotMachine = SlotMachine();
    // world.add(slotMachine!);

    /// load background
    _loadBackground();

    /// Spin
    // await _loadTest();
    await loadSpinAnimate();

    _loadGameBoard();

    super.onLoad();
  }

  _loadTest() async {
    spineTest = await SpineComponent.fromAssets(
      atlasFile: 'assets/spine/snowglobe/snowglobe-pro.atlas',
      skeletonFile: 'assets/spine/snowglobe/snowglobe-pro.json',
      scale: Vector2(0.2, 0.2),
      anchor: Anchor.center,
      // position: Vector2(0, -350),
      priority: 4
    );
    spineTest.animationState.setAnimationByName(0, 'shake', true);
    await world.add(spineTest);
  }

  @override
  void onGameResize(Vector2 size) {
    //偵測視窗或者 canvas 變化來作出響應。
    _layoutBySize(size);
    // log('[onGameResize]: $size');
    super.onGameResize(size);
  }

  _loadBackground() async {
    final BackgroundBoard backgroundBoard = BackgroundBoard(currentLayoutMode: currentLayoutMode, boardSize: size);
    world.add(backgroundBoard);
  }

  _loadGameBoard() async {
    final GameBoard gameBoard = GameBoard(currentLayoutMode: currentLayoutMode, slotGameCenter: this);
    world.add(gameBoard);
  }

  loadSpinAnimate() async {
    spineSnowGlobe = await SpineComponent.fromAssets(
      atlasFile: 'assets/spine/Character/Character.atlas',
      skeletonFile: 'assets/spine/Character/Character.json',
      scale: Vector2(1.2, 1.2),
      anchor: Anchor.center,
      position: Vector2(0, -350),
      priority: 2
    );
    // final slots = spineSnowGlobe.skeleton.getSlots();
    // print('slots: ${slots.length}');

    // spineSnowGlobe.skeleton.setAttachment('H1_1', 'Wild_1');
    // spineSnowGlobe.animationState.setListener((EventType type, TrackEntry trackEntry, Event? event) {
    //   if (type == EventType.complete) {
    //     print("Animation '${trackEntry.getAnimation().getName()}' completed.");
    //   } else if (type == EventType.start) {
    //     print("Animation '${trackEntry.getAnimation().getName()}' started.");
    //   } else if (type == EventType.event) {
    //     print("Event '${event?.getData().getName()}' occurred at animation '${trackEntry.getAnimation().getName()}'.");
    //   }
    // });
    spineSnowGlobe.animationState.setAnimationByName(0, 'anim_1', true);
    await world.add(spineSnowGlobe);
  }

  removeSpinAnimate() {
    world.remove(spineSnowGlobe);
  }

  void _layoutBySize(Vector2 size) {
    double aspectRatio = size.x / size.y;
    LayoutMode detectMode = aspectRatio >= 1 ? LayoutMode.landscape : LayoutMode.portrait;
    if (_layoutMode != detectMode) {
      _layoutMode = detectMode;
      //重設攝影機。
      _setCameraByLayout(_layoutMode);
      _refreshUIsByLayout(_layoutMode);
    }
  }

  /// 根據傳入的 layoutMode 來定義攝影機，注意這被呼叫時就會重設攝影機。
  void _setCameraByLayout(LayoutMode layoutMode) {
    if (layoutMode == LayoutMode.portrait) {
      //Use portrait mode camera.
      camera = CameraComponent.withFixedResolution(width: GlobalData.resolutionLow, height: GlobalData.resolutionHigh);
      camera.viewfinder.position = Vector2(0, 100);
    } else {
      //Use landscape mode camera.
      camera = CameraComponent.withFixedResolution(width: GlobalData.resolutionHigh, height: GlobalData.resolutionLow);
      camera.viewfinder.position = Vector2(0, 150);
    }
  }

  /// 重新整理介面，根據 layout 模式。
  void _refreshUIsByLayout(LayoutMode layoutMode) {
    _loadBackground();
  }

  @override
  void onDetach() {
    spineSnowGlobe.dispose();
    super.onDetach();
  }

  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(userInfoProvider, (provider, listener) {
      switch (listener.slotGameStatus) {
        case SlotGameStatus.init:
          print('SlotGameStatus init');
          break;
        case SlotGameStatus.spin:
          print('SlotGameStatus spin');
          break;
        case SlotGameStatus.stop:
          print('SlotGameStatus stop');
          break;
        case SlotGameStatus.win:
          print('SlotGameStatus win');
          break;
        default:
          break;
      }
    }));
    super.onMount();
  }
}