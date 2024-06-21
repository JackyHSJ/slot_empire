
part of 'round_list_info.dart';

/// RoundListInfo
RoundListInfo _$RoundListInfoFromJson(Map<String, dynamic> json) => RoundListInfo(
  item: json['item'] as String?,
  rate: json['rate'] as num?,
  line: json['line'] as List<String>?,
  bonus: json['bonus'] as num?,
  lineCount: json['lineCount'] as num?,
);

Map<String, dynamic> _$RoundListInfoToJson(RoundListInfo instance) => <String, dynamic>{
  'item': instance.item,
  'rate': instance.rate,
  'line': instance.line,
  'bonus': instance.bonus,
  'lineCount': instance.lineCount,
};