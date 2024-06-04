import 'package:example_slot_game/slot_game/game_board/setting_menu/setting_menu_view_model.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';

class SettingMenu extends PositionComponent {
  SettingMenu(): super(
    size: Vector2(100, 100),
    position: Vector2(100, 100),
    anchor: Anchor.center,
  );
  late SettingMenuViewModel viewModel;
  late SpriteButtonComponent soundComponent;

  @override
  Future<void> onLoad() async {
    viewModel = SettingMenuViewModel();
    _loadMenu();
    return super.onLoad();
  }

  Future<void> _loadMenu() async {
    final Sprite sprite = await Sprite.load('navigation/setting_mezu.png');
    final Sprite soundSprite = await Sprite.load(viewModel.isSoundOn ? 'navigation/icons_09.png' : 'navigation/icons_03.png');
    final Sprite refreshSprite = await Sprite.load('navigation/icons_23.png');
    final Sprite helpSprite = await Sprite.load('navigation/icons_18.png');

    final SpriteButtonComponent refreshComponent = _loadBtn(sprite: refreshSprite, position: Vector2(33, 35), onPressed: viewModel.refresh);
    final SpriteButtonComponent helpComponent = _loadBtn(sprite: helpSprite, position: Vector2(33, 95), onPressed: viewModel.help);
    soundComponent = _loadBtn(sprite: soundSprite, position: Vector2(33, 155), onPressed: () => viewModel.sound(soundComponent));
    final SpriteComponent spriteComponent = SpriteComponent(
        anchor: Anchor.center,
        position: Vector2(-450, 400),
        scale: Vector2(1, 1),
        sprite: sprite,
        children: [
          refreshComponent,
          helpComponent,
          soundComponent
        ]
    );
    add(spriteComponent);
  }

  SpriteButtonComponent _loadBtn({
    required Sprite sprite,
    required Vector2 position,
    required Function() onPressed
  }) {
    return SpriteButtonComponent(
        anchor: Anchor.center,
        button: sprite,
        scale: Vector2(1, 1),
        position: position,
        onPressed: onPressed
    );
  }
}
