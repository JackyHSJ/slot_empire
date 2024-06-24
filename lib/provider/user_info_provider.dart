
import 'package:example_slot_game/const/enum.dart';
import 'package:example_slot_game/model/res/slot/slot_res.dart';
import 'package:example_slot_game/model/user_info_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 想進行UserInfo 資料修改使用這個 StateNotifierProvider
final userUtilProvider = StateNotifierProvider<UserNotifier, UserInfoModel>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<UserInfoModel> {
  UserNotifier() : super(UserInfoModel());

  /// launch 時調用
  Future<void> loadDataPrefs() async {
    try {
      final UserInfoModel userInfo = UserInfoModel(
        slotStatus: SlotStatus.init,
        slotGameStatus: SlotGameStatus.mainGame,
      );
      state = userInfo;
    } catch (e) {
      print('load token error: $e');
      throw Exception('load token error: $e');
    }
  }

  Future<void> setDataToPrefs({
    SlotStatus? slotStatus,
    SlotGameStatus? slotGameStatus,
  }) async {
    try {
      final UserInfoModel userInfo = UserInfoModel(
        slotStatus: slotStatus ?? state.slotStatus,
        slotGameStatus: slotGameStatus ?? state.slotGameStatus,
      );
      state = userInfo;
    } catch (e) {
      print('set token error: $e');
      throw Exception('set token error: $e');
    }
  }

  Future<void> clearUserInfo() async {
    try {
      state = UserInfoModel();
    } catch (e) {
      print('clear UserInfo error: $e');
      throw Exception('clear UserInfo error: $e');
    }
  }
}