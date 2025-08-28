import 'package:ediocese_app/models/schemas/price/price.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_price_response.g.dart';

@JsonSerializable()
class GetPriceResponse {
  bool success;
  List<Price> prices;

  GetPriceResponse({required this.success, required this.prices});

  factory GetPriceResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPriceResponseFromJson(json);
  Map<String, dynamic> toJson() => _$GetPriceResponseToJson(this);
}
