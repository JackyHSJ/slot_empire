
import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/model/game_block_model.dart';
import 'package:example_slot_game/model/res/slot/slot_res.dart';

class UserInfoModel {
  UserInfoModel({
    this.slotGameStatus,
    this.slotRes,
  });

  SlotGameStatus? slotGameStatus;
  SlotRes? slotRes;

  /// 保留原本資料 new一個新記憶體空間(改變狀態用 for riverpods)
  UserInfoModel copyWith({
    SlotGameStatus? slotGameStatus,
    SlotRes? slotRes,
  }) {
    return UserInfoModel(
      slotGameStatus: slotGameStatus ?? this.slotGameStatus,
      slotRes: slotRes ?? this.slotRes,
    );
  }
}