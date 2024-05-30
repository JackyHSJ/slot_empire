import 'package:example_slot_game/const/enum.dart';

extension GameBlockTypeExtension on GameBlockType {
  String get getBlockImgPath {
    switch (this) {
      case GameBlockType.blockJ:
        return 'Game Blocks/N4_1.png'; //
      case GameBlockType.blockQ:
        return 'Game Blocks/N3_1.png'; //
      case GameBlockType.blockK:
        return 'Game Blocks/N2_1.png'; //
      case GameBlockType.blockA:
        return 'Game Blocks/N1_1.png'; //
      case GameBlockType.king:
        return 'Game Blocks/Scatter_1.png'; //
      case GameBlockType.ten:
        return 'Game Blocks/N5_1.png'; //
      case GameBlockType.totemBird:
        return 'Game Blocks/H2_1.png'; //
      case GameBlockType.totemFace:
        return 'Game Blocks/H1_1.png'; //
      case GameBlockType.totemGrass:
        return 'Game Blocks/H5_1.png'; //
      case GameBlockType.totemKing:
        return 'Game Blocks/H3_1.png'; //
      case GameBlockType.totemDoll:
        return 'Game Blocks/H4_1.png'; //
      default:
        return 'Game Blocks/Scatter_1.png'; //
    }
  }
}
