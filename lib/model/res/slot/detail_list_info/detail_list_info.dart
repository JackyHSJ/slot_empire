

import 'package:example_slot_game/model/res/slot/round_list_info/round_list_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_list_info.g.dart';

class DetailListInfo {
  DetailListInfo({
    this.totalBonus,
    this.roundList,
    this.itemMap,
    this.type,
    this.freeCount,
  });

  @JsonKey(name: 'totalBonus')
  final num? totalBonus;

  @JsonKey(name: 'roundList')
  final List<RoundListInfo>? roundList;

  @JsonKey(name: 'itemMap')
  final List<List<String?>>? itemMap;

  @JsonKey(name: 'type')
  final num? type;

  @JsonKey(name: 'freeCount')
  final num? freeCount;

  factory DetailListInfo.fromJson(Map<String, dynamic> json) => _$DetailListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DetailListInfoToJson(this);
}