// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionResponse _$TransactionResponseFromJson(Map<String, dynamic> json) =>
    TransactionResponse(
      success: json['success'] as bool,
      transaction: Transaction.fromJson(
        json['transaction'] as Map<String, dynamic>,
      ),
      paymentUrl: json['paymentUrl'] as String,
    );

Map<String, dynamic> _$TransactionResponseToJson(
        TransactionResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'transaction': instance.transaction,
      'paymentUrl': instance.paymentUrl,
    };
