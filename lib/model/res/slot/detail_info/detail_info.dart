
import 'package:example_slot_game/model/res/slot/detail_list_info/detail_list_info.dart';
import 'package:json_annotation/json_annotation.dart';

part 'detail_info.g.dart';

class DetailInfo {
  DetailInfo({
    this.mainDetail,
    this.detailList,
  });

  @JsonKey(name: 'mainDetail')
  final dynamic mainDetail;

  @JsonKey(name: 'detailList')
  final List<DetailListInfo>? detailList;

  factory DetailInfo.fromJson(Map<String, dynamic> json) => _$DetailInfoFromJson(json);
  Map<String, dynamic> toJson() => _$DetailInfoToJson(this);
}