// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_req.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseReq _$BaseReqFromJson(Map<String, dynamic> json) =>
    BaseReq(
      f: json['f'] as String,
      tId: json['tId'] as String,
      msg: json['msg'] as dynamic,
      rId: json['rId'] as String?,
    );

Map<String, dynamic> _$BaseReqToJson(BaseReq instance) =>
    <String, dynamic>{
      'f': instance.f,
      'tId': instance.tId,
      'msg': instance.msg,
      'rId': instance.rId,
    };
