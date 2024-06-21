
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_res.g.dart';

@JsonSerializable()
class BaseRes {
  BaseRes({
    this.f,
    this.resultCode,
    this.resultMsg,
    this.resultMap,
    this.rId,
  });

  @JsonKey(name: 'rId')
  final String? rId;

  @JsonKey(name: 'f')
  final String? f;

  @JsonKey(name: 'resultCode')
  final String? resultCode;

  @JsonKey(name: 'resultMsg')
  final String? resultMsg;

  @JsonKey(name: 'resultMap')
  final dynamic resultMap;

  factory BaseRes.fromJson(Map<String, dynamic> json) =>
      _$BaseResFromJson(json);
  Map<String, dynamic> toJson() => _$BaseResToJson(this);



  printLog() {
    debugPrint('===========printWebSocketResponseLog===========');
    debugPrint('rId:$rId');
    debugPrint('resultCode:$resultCode');
    debugPrint('resultMsg:$resultMsg');
    debugPrint('resultMap:$resultMap');
    debugPrint('f:$f');
  }
}