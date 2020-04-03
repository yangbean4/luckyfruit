import 'package:json_annotation/json_annotation.dart';

part 'cityInfo.g.dart';

@JsonSerializable()
class CityInfo {
    CityInfo();

    String id;
    String continent;
    String code;
    String name;
    String bg_img;
    String fruit_img;
    String sort;
    String level;
    String add_time;
    
    factory CityInfo.fromJson(Map<String,dynamic> json) => _$CityInfoFromJson(json);
    Map<String, dynamic> toJson() => _$CityInfoToJson(this);
}
