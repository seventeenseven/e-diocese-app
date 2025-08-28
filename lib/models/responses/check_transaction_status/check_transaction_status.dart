import 'package:json_annotation/json_annotation.dart';

part 'check_transaction_status.g.dart';

@JsonSerializable()
class CheckTransactionStatus {
  String status;

  CheckTransactionStatus({required this.status});

  factory CheckTransactionStatus.fromJson(Map<String, dynamic> json) =>
      _$CheckTransactionStatusFromJson(json);

  Map<String, dynamic> toJson() => _$CheckTransactionStatusToJson(this);
}
