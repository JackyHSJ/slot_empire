import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/model/game_block_model.dart';

extension GameBlockTypeExtension on GameBlockType {
  String getBlockImgPath(num coverNum) {
    switch (this) {
      case GameBlockType.blockJ:
        return 'Game Blocks/N4$coverNum.png'; //
      case GameBlockType.blockQ:
        return 'Game Blocks/N3$coverNum.png'; //
      case GameBlockType.blockK:
        return 'Game Blocks/N2$coverNum.png'; //
      case GameBlockType.blockA:
        return 'Game Blocks/N1$coverNum.png'; //

      case GameBlockType.scatter:
        return 'Game Blocks/S1$coverNum.png'; //
      case GameBlockType.wild:
        return 'Game Blocks/Wild$coverNum.png'; //

      case GameBlockType.ten:
        return 'Game Blocks/N5$coverNum.png'; //
      case GameBlockType.totemBird:
        return 'Game Blocks/H2$coverNum.png'; //
      case GameBlockType.totemFace:
        return 'Game Blocks/H1$coverNum.png'; //
      case GameBlockType.totemGrass:
        return 'Game Blocks/H5$coverNum.png'; //
      case GameBlockType.totemKing:
        return 'Game Blocks/H3$coverNum.png'; //
      case GameBlockType.totemDoll:
        return 'Game Blocks/H4$coverNum.png'; //
      default:
        return ''; //
    }
  }
}
