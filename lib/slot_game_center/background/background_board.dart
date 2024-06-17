
import 'package:example_slot_game/const/enum.dart';
import 'package:flame/components.dart';

class BackgroundBoard extends SpriteComponent {
  BackgroundBoard({
    required this.currentLayoutMode,
    required this.boardSize
  }): super(priority: 1);

  LayoutMode currentLayoutMode;
  Vector2 boardSize;

  @override
  Future<void> onLoad() async {
    _loadLayoutMode();
  }

  _loadLayoutMode() {
    if(currentLayoutMode == LayoutMode.portrait) {
      _loadBackground();
    }

    if(currentLayoutMode == LayoutMode.landscape) {
      _loadBackground();
    }
  }

  _loadBackground() async {
    final Sprite backgroundSprite = await Sprite.load('Background/Bg1.png');
    sprite = backgroundSprite;
    anchor = Anchor.center;
    position = Vector2(0 , -300);
    size = boardSize;
    scale = Vector2(1, 1.5);
  }

  @override
  void onRemove() {
    removeAll(children);
    super.onRemove();
  }
}