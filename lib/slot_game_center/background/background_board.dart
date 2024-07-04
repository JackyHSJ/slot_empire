
import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/provider/provider.dart';
import 'package:flame/components.dart';
import 'package:flame_riverpod/flame_riverpod.dart';

class BackgroundBoard extends SpriteComponent with RiverpodComponentMixin {
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

  @override
  void onMount() {
    addToGameWidgetBuild(() => ref.listen(userInfoProvider, (provider, listener) {
      switch (listener.slotGameStatus) {
        case SlotGameStatus.mainGame:
          _changeMainGameBoard();
          break;
        case SlotGameStatus.freeGame:
          _changeToFreeGameBoard();
          break;
        default:
          break;
      }
    }));
    super.onMount();
  }

  _changeMainGameBoard() async {
    final Sprite backgroundSprite = await Sprite.load('Background/Bg1.png');
    sprite = backgroundSprite;
  }

  _changeToFreeGameBoard() async {
    final Sprite backgroundSprite = await Sprite.load('Background/Bg4.png');
    sprite = backgroundSprite;
  }
}