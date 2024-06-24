

import 'package:example_slot_game/const/demo_res.dart';
import 'package:example_slot_game/model/res/base_res.dart';
import 'package:example_slot_game/model/res/slot/slot_res.dart';
import 'package:example_slot_game/slot_game/slot_game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CommAPI {
  static SlotRes getDemoRes() {
    final Map<String, dynamic>  demoMap = DemoRes.map;
    final BaseRes baseRes = BaseRes.fromJson(demoMap);
    final SlotRes slotRes = SlotRes.fromJson(baseRes.resultMap);
    return slotRes;
  }
}