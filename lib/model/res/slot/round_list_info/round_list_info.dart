
import 'package:json_annotation/json_annotation.dart';
part 'round_list_info.g.dart';


class RoundListInfo {
  RoundListInfo({
    this.item,
    this.rate,
    this.line,
    this.bonus,
    this.lineCount,
  });

  /// 中獎圖標
  @JsonKey(name: 'item')
  final String? item;

  /// 賠率
  @JsonKey(name: 'rate')
  final num? rate;

  /// 符號連線位置
  @JsonKey(name: 'line')
  final List<String>? line;

  /// 中獎金額
  @JsonKey(name: 'bonus')
  final num? bonus;

  /// 賠付線數量
  @JsonKey(name: 'lineCount')
  final num? lineCount;

  factory RoundListInfo.fromJson(Map<String, dynamic> json) => _$RoundListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$RoundListInfoToJson(this);
}