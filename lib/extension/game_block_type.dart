import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/model/game_block_model.dart';

extension GameBlockTypeExtension on GameBlockType {
  String getBlockImgPath(num coverNum) {
    switch (this) {
      case GameBlockType.blockJ:
        return 'Game Blocks/N4_$coverNum.png'; //
      case GameBlockType.blockQ:
        return 'Game Blocks/N3_$coverNum.png'; //
      case GameBlockType.blockK:
        return 'Game Blocks/N2_$coverNum.png'; //
      case GameBlockType.blockA:
        return 'Game Blocks/N1_$coverNum.png'; //
      case GameBlockType.king:
        return 'Game Blocks/Scatter_$coverNum.png'; //
      case GameBlockType.ten:
        return 'Game Blocks/N5_$coverNum.png'; //
      case GameBlockType.totemBird:
        return 'Game Blocks/H2_$coverNum.png'; //
      case GameBlockType.totemFace:
        return 'Game Blocks/H1_$coverNum.png'; //
      case GameBlockType.totemGrass:
        return 'Game Blocks/H5_$coverNum.png'; //
      case GameBlockType.totemKing:
        return 'Game Blocks/H3_$coverNum.png'; //
      case GameBlockType.totemDoll:
        return 'Game Blocks/H4_$coverNum.png'; //
      default:
        return 'Game Blocks/Scatter_$coverNum.png'; //
    }
  }
}
