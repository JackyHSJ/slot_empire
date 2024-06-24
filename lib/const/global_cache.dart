
import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/model/res/slot/slot_res.dart';

class GlobalCache {
  static SlotRes slotRes = SlotRes();
  static SlotStatus slotStatus = SlotStatus.init;
  static SlotGameStatus slotGameStatus = SlotGameStatus.mainGame;
}