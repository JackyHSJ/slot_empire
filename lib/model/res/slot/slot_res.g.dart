// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot_res.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SlotRes _$SlotResFromJson(Map<String, dynamic> json) => SlotRes(
      totalAmount: json['totalAmount'] as num?,
      mainTotalWinAmount: json['mainTotalWinAmount'] as num?,
      betAmount: json['betAmount'] as num?,
      resultCode: json['resultCode'] as String?,
      featureTotalWinAmount: json['featureTotalWinAmount'] as num?,
      detail: DetailInfo.fromJson(json['detail']),
      uuid: json['uuid'] as String?,
      featureTotalCount: json['featureTotalCount'] as num?,
      status: json['status'] as num?,
    );

Map<String, dynamic> _$SlotResToJson(SlotRes instance) => <String, dynamic>{
      'totalAmount': instance.totalAmount,
      'mainTotalWinAmount': instance.mainTotalWinAmount,
      'betAmount': instance.betAmount,
      'resultCode': instance.resultCode,
      'featureTotalWinAmount': instance.featureTotalWinAmount,
      'detail': instance.detail,
      'uuid': instance.uuid,
      'featureTotalCount': instance.featureTotalCount,
      'status': instance.status,
    };