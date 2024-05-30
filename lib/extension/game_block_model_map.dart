import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/model/game_block_model.dart';

extension GameBlockTypeExtension on List<List<GameBlockModel>> {
  Map<GameBlockType, num> get getEachTypeHasSix {
    num blockJ = 0;
    num blockQ = 0;
    num blockK = 0;
    num blockA = 0;
    num king = 0;
    num ten = 0;
    num totemBird = 0;
    num totemFace = 0;
    num totemGrass = 0;
    num totemKing = 0;
    num totemDoll = 0;

    forEach((blockMap) {
      for (int i = 4; i >= 0; i--) {
        final block = blockMap[i];
        switch (block.type) {
          case GameBlockType.blockJ:
            blockJ++;
            break;
          case GameBlockType.blockQ:
            blockQ++;
            break;
          case GameBlockType.blockK:
            blockK++;
            break;
          case GameBlockType.blockA:
            blockA++;
            break;
          case GameBlockType.king:
            king++;
            break;
          case GameBlockType.ten:
            ten++;
            break;
          case GameBlockType.totemBird:
            totemBird++;
            break;
          case GameBlockType.totemFace:
            totemFace++;
            break;
          case GameBlockType.totemGrass:
            totemGrass++;
            break;
          case GameBlockType.totemKing:
            totemKing++;
            break;
          case GameBlockType.totemDoll:
            totemDoll++;
            break;
          default:
            break;
        }
      }
    });
    return {
      GameBlockType.blockK: blockK,
      GameBlockType.blockQ: blockQ,
      GameBlockType.blockJ: blockJ,
      GameBlockType.blockA: blockA,
      GameBlockType.king: king,
      GameBlockType.ten: ten,
      GameBlockType.totemBird: totemBird,
      GameBlockType.totemFace: totemFace,
      GameBlockType.totemGrass: totemGrass,
      GameBlockType.totemKing: totemKing,
      GameBlockType.totemDoll: totemDoll,
    };
  }
}