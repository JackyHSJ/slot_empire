

import 'package:example_slot_game/const/enum.dart';

extension StringExtension on String {
  GameBlockType? get getBlockType {
    try {
      final List<String> part = split('');
      final String block = part[0] + part[1];
      switch(block) {
        case 'H1': return GameBlockType.totemFace;
        case 'H2': return GameBlockType.totemBird;
        case 'H3': return GameBlockType.totemKing;
        case 'H4': return GameBlockType.totemDoll;
        case 'H5': return GameBlockType.totemGrass;

        case 'N1': return GameBlockType.blockA;
        case 'N2': return GameBlockType.blockK;
        case 'N3': return GameBlockType.blockQ;
        case 'N4': return GameBlockType.blockJ;
        case 'N5': return GameBlockType.ten;

        case 'S1': return GameBlockType.scatter;

        case 'W1': return GameBlockType.wild;
        case 'W2': return GameBlockType.wild;
        case 'W3': return GameBlockType.wild;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  num get getBlockCoverNumber {
    try {
      final List<String> part = split('');
      final String coverNumberStr = part[2];
      return num.tryParse(coverNumberStr) ?? 1;
    } catch(e) {
      return 0;
    }
  }

  bool get isGold {
    final bool isContainGold = contains('g');
    return isContainGold;
  }
}
