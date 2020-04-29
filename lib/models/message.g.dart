// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) {
  return Message()
    ..id = json['id'] as String
    ..order_id = json['order_id'] as String
    ..gift_id = json['gift_id'] as String
    ..wdl_amt = json['wdl_amt'] as String
    ..wdl_status = json['wdl_status'] as String
    ..claim_code = json['claim_code'] as String
    ..chan_type = json['chan_type'] as String
    ..msg_content = json['msg_content'] as String;
}

Map<String, dynamic> _$MessageToJson(Message instance) => <String, dynamic>{
      'id': instance.id,
      'order_id': instance.order_id,
      'gift_id': instance.gift_id,
      'wdl_amt': instance.wdl_amt,
      'wdl_status': instance.wdl_status,
      'claim_code': instance.claim_code,
      'chan_type': instance.chan_type,
      'msg_content': instance.msg_content
    };
