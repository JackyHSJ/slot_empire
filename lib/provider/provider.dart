
import 'package:example_slot_game/comm/comm.dart';
import 'package:example_slot_game/model/user_info_model.dart';
import 'package:example_slot_game/provider/user_info_provider.dart';
import 'package:flame_riverpod/flame_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final GlobalKey<RiverpodAwareGameWidgetState> gameWidgetKey = GlobalKey<RiverpodAwareGameWidgetState>();
final userInfoProvider = Provider<UserInfoModel>((ref) {
  final UserInfoModel userInfo = ref.watch(userUtilProvider);
  return userInfo;
});

/// API provider
Provider<CommAPI> commApiProvider = Provider<CommAPI>((ref) => CommAPI(ref: ref));