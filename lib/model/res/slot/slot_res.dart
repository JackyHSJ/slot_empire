
import 'package:example_slot_game/model/res/slot/detail_info/detail_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'slot_res.g.dart';

@JsonSerializable()
class SlotRes {
  SlotRes({
    this.totalAmount,
    this.mainTotalWinAmount,
    this.betAmount,
    this.resultCode,
    this.featureTotalWinAmount,
    this.detail,
    this.uuid,
    this.featureTotalCount,
    this.status,
  });

  /// 總輸鸁金額
  @JsonKey(name: 'totalAmount')
  final num? totalAmount;

  @JsonKey(name: 'mainTotalWinAmount')
  final num? mainTotalWinAmount;

  /// 下注金額
  @JsonKey(name: 'betAmount')
  final num? betAmount;

  /// 結果代碼
  @JsonKey(name: 'resultCode')
  final String? resultCode;

  @JsonKey(name: 'featureTotalWinAmount')
  final num? featureTotalWinAmount;

  /// 細項
  @JsonKey(name: 'detail')
  final DetailInfo? detail;

  /// 系統自動產生
  @JsonKey(name: 'uuid')
  final String? uuid;

  @JsonKey(name: 'featureTotalCount')
  final num? featureTotalCount;

  /// 結果狀態
  @JsonKey(name: 'status')
  final num? status;

  factory SlotRes.fromJson(Map<String, dynamic> json) => _$SlotResFromJson(json);
  Map<String, dynamic> toJson() => _$SlotResToJson(this);
}

