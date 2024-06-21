

import 'package:example_slot_game/const/demo_res.dart';
import 'package:example_slot_game/model/res/base_res.dart';
import 'package:example_slot_game/model/res/slot/slot_res.dart';
import 'package:example_slot_game/provider/provider.dart';
import 'package:example_slot_game/provider/user_info_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LaunchViewModel {
  LaunchViewModel({
    required this.ref
  });
  WidgetRef ref;
  
  init() {

  }

  dispose() {

  }

  Future<void> afterFirstLayout() async {
    final SlotRes slotRes = ref.read(commApiProvider).getDemoRes();
    ref.read(userUtilProvider.notifier).loadSlot(slotRes);
  }
}