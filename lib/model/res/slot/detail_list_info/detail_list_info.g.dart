
part of 'detail_list_info.dart';

/// DetailListInfo
DetailListInfo _$DetailListInfoFromJson(Map<String, dynamic> json) => DetailListInfo(
  totalBonus: json['totalBonus'] as num?,
  roundList: (json['roundList'] as List).map((info) => RoundListInfo.fromJson(info)).toList(),
  itemMap: json['itemMap'] as List<List<String?>>,
  type: json['type'] as num?,
  freeCount: json['freeCount'] as num?,
);

Map<String, dynamic> _$DetailListInfoToJson(DetailListInfo instance) => <String, dynamic>{
  'totalBonus': instance.totalBonus,
  'roundList': instance.roundList,
  'itemMap': instance.itemMap,
  'type': instance.type,
  'freeCount': instance.freeCount,
};