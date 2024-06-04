

import 'package:example_slot_game/base_view_model.dart';
import 'package:example_slot_game/component/dialog/base_dialog.dart';
import 'package:example_slot_game/slot_game/game_board/setting_menu/help/help.dart';
import 'package:example_slot_game/slot_game/game_board/setting_menu/spin_setting/spin_setting.dart';
import 'package:example_slot_game/util/web/launcher_manager.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

class SettingMenuViewModel {
  bool isSoundOn = true;
  Sprite? soundSprite;

  refresh() {
    final context = BaseViewModel.getGlobalContext();
    BaseDialog(context).showTransparentDialog(widget: const SpinSetting());
    print('refresh');
  }

  help() {
    final Uri url = Uri.parse('https://jiligames.com/PlusIntro/103?showGame=false');
    LauncherManager.launchInBrowser(url);
    // final context = BaseViewModel.getGlobalContext();
    // BaseViewModel.pushPage(context, const Help());
    print('help');
  }

  sound(SpriteButtonComponent sound) async {
    isSoundOn = !isSoundOn;
    sound.button = await getSoundSprite();
  }

  Future<Sprite> getSoundSprite() async {
    final Sprite soundSprite = await Sprite.load(isSoundOn ? 'navigation/icons_09.png' : 'navigation/icons_03.png');
    return soundSprite;
  }
}