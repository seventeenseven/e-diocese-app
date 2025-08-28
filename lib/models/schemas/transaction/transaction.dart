import 'package:json_annotation/json_annotation.dart';

part 'transaction.g.dart';

@JsonSerializable()
class Transaction {
  String id;
  int amount;
  String currency;
  String status;
  String phone;
  String? txRef;
  String? serviceTransactionRef;

  Transaction(
      {required this.id,
      required this.amount,
      required this.currency,
      required this.status,
      required this.phone,
      this.txRef,
      this.serviceTransactionRef});

  factory Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}
