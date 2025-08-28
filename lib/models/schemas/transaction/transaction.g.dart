// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      id: json['_id'] as String,
      amount: json['amount'] as int,
      currency: json['currency'] as String,
      status: json['status'] as String,
      phone: json['phone'] as String,
      txRef: json['txRef'] == null ? null : json['txRef'] as String,
      serviceTransactionRef: json['serviceTransactionRef'] == null
          ? null
          : json['serviceTransactionRef'] as String,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'amount': instance.amount,
      'currency': instance.currency,
      'status': instance.status,
      'phone': instance.phone,
      'txRef': instance.txRef,
      'serviceTransactionRef': instance.serviceTransactionRef,
    };
