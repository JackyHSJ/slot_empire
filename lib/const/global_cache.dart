
import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/model/res/slot/slot_res.dart';

class GlobalCache {
  static SlotRes slotRes = SlotRes();
  static SlotStatus slotStatus = SlotStatus.init;
  static SlotGameStatus slotGameStatus = SlotGameStatus.mainGame;

  /// 回合數
  static num comboRoundCount = 1;

  static bool get checkFreeGame {
    final int currentRound = comboRoundCount.toInt();
    final num scatterNumber = slotRes.detail?.detailList?[currentRound].scatter ?? 0;
    return scatterNumber >= 4;
  }
}