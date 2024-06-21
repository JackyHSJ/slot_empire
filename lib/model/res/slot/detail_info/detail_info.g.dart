
part of 'detail_info.dart';

/// DetailInfo
DetailInfo _$DetailInfoFromJson(Map<String, dynamic> json) => DetailInfo(
  mainDetail: json['mainDetail'] as dynamic,
  detailList: (json['detailList'] as List).map((info) => DetailListInfo.fromJson(info)).toList(),
);

Map<String, dynamic> _$DetailInfoToJson(DetailInfo instance) => <String, dynamic>{
  'mainDetail': instance.mainDetail,
  'detailList': instance.detailList,
};