import 'package:json_annotation/json_annotation.dart';

part 'deblokCity.g.dart';

@JsonSerializable()
class DeblokCity {
    DeblokCity();

    String city_id;
    String is_open_box;
    
    factory DeblokCity.fromJson(Map<String,dynamic> json) => _$DeblokCityFromJson(json);
    Map<String, dynamic> toJson() => _$DeblokCityToJson(this);
}
