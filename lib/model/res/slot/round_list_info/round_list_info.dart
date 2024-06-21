
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

  @JsonKey(name: 'item')
  final String? item;

  @JsonKey(name: 'rate')
  final num? rate;

  @JsonKey(name: 'line')
  final List<String>? line;

  @JsonKey(name: 'bonus')
  final num? bonus;

  @JsonKey(name: 'lineCount')
  final num? lineCount;

  factory RoundListInfo.fromJson(Map<String, dynamic> json) => _$RoundListInfoFromJson(json);
  Map<String, dynamic> toJson() => _$RoundListInfoToJson(this);
}