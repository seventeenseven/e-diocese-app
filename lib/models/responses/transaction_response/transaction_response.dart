import 'package:ediocese_app/models/schemas/transaction/transaction.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_response.g.dart';

@JsonSerializable()
class TransactionResponse {
  bool success;
  Transaction transaction;
  String paymentUrl;

  TransactionResponse(
      {required this.success,
      required this.transaction,
      required this.paymentUrl});

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionResponseToJson(this);
}
