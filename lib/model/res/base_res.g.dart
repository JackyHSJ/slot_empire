// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseRes _$BaseResFromJson(Map<String, dynamic> json) => BaseRes(
      resultCode: json['resultCode'] as String?,
      resultMsg: json['resultMsg'] as String?,
      resultMap: json['resultMap'] as dynamic,
      f: json['f'] as String?,
      rId: json['rId'] as String?
    );

Map<String, dynamic> _$BaseResToJson(BaseRes instance) => <String, dynamic>{
      'resultCode': instance.resultCode,
      'resultMsg': instance.resultMsg,
      'resultMap': instance.resultMap,
      'f': instance.f,
      'rId': instance.rId
    };
