
import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/model/game_block_model.dart';
import 'package:example_slot_game/model/res/slot/slot_res.dart';

class UserInfoModel {
  UserInfoModel({
    this.slotStatus,
    this.slotGameStatus,
  });

  /// status
  SlotStatus? slotStatus;
  SlotGameStatus? slotGameStatus;

  /// 保留原本資料 new一個新記憶體空間(改變狀態用 for riverpods)
  UserInfoModel copyWith({
    SlotStatus? slotStatus,
    SlotGameStatus? slotGameStatus,

  }) {
    return UserInfoModel(
      slotStatus: slotStatus ?? this.slotStatus,
      slotGameStatus: slotGameStatus ?? this.slotGameStatus,
    );
  }
}