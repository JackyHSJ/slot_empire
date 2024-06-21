import 'package:encrypt/encrypt.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_req.g.dart';

@JsonSerializable()
class BaseReq {
  BaseReq({
    required this.f,
    required this.tId,
    required this.msg,
    this.rId,
  });

  factory BaseReq.create({
    required String f,
    required String tId,
    required String msg,
    String? rId
  }) {
    return BaseReq(f: f, tId: tId, msg: msg, rId: rId);
  }

  @JsonKey(name: 'rId')
  String? rId;

  @JsonKey(name: 'f')
  String f;

  @JsonKey(name: 'tId')
  String tId;

  @JsonKey(name: 'msg')
  dynamic msg;

  factory BaseReq.fromJson(Map<String, dynamic> json) =>
      _$BaseReqFromJson(json);
  Map<String, dynamic> toJson() => _$BaseReqToJson(this);

  // API 不帶參數的屬性不傳出
  Map<String, dynamic> toBody() {
    Map<String, dynamic> json = toJson();
    json.removeWhere((key, value) => value == null);
    return json;
  }
}
