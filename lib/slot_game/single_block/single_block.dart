import 'dart:async';
import 'package:example_slot_game/const/global_value.dart';
import 'package:example_slot_game/slot_game/single_block/single_block_view_model.dart';
import 'package:flame/components.dart';

class SingleBlock extends SpriteComponent {
  SingleBlock({
    required this.coverNum,
    required this.startPosition,
    required this.gameBlockSprite,
  }) : super(
      anchor: Anchor.topCenter,
      sprite: gameBlockSprite,
      position: startPosition,
      size: Vector2(GlobalValue.blockVector.x, GlobalValue.blockVector.y * coverNum),
  );

  num coverNum;
  Vector2 startPosition;
  late Sprite gameBlockSprite;
  late SingleBlockViewModel viewModel;

  @override
  Future<void> onLoad() async {
    viewModel = SingleBlockViewModel();
    _loadAnimate();
    // _loadOutLine();
    super.onLoad();
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  void onRemove() {
    removeAll(children);
    super.onRemove();
  }

  _loadOutLine() async {
    final Sprite sprite = await Sprite.load('Game BLocks/Outline_1.png');
    final SpriteComponent spriteComponent = SpriteComponent(sprite: sprite, size: GlobalValue.blockVector);
    add(spriteComponent);
  }

  void _loadAnimate() {

  }

  void updateSprite(String imagePath) async {
    Sprite newSprite = await Sprite.load(imagePath);
    sprite = newSprite;  // 更新 sprite 属性
  }
}

