
import 'package:example_slot_game/const/enum.dart';

class UserInfoModel {
  UserInfoModel({
    this.slotGameStatus
  });

  SlotGameStatus? slotGameStatus;

  /// 保留原本資料 new一個新記憶體空間(改變狀態用 for riverpods)
  UserInfoModel copyWith({
    SlotGameStatus? slotGameStatus,
  }) {
    return UserInfoModel(
      slotGameStatus: slotGameStatus ?? this.slotGameStatus,
    );
  }
}