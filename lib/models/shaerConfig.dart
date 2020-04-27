import 'package:json_annotation/json_annotation.dart';

part 'shaerConfig.g.dart';

@JsonSerializable()
class ShaerConfig {
    ShaerConfig();

    String uriPrefix;
    String fireLink;
    String title;
    String subtitle;
    List<String> imageUrl;
    
    factory ShaerConfig.fromJson(Map<String,dynamic> json) => _$ShaerConfigFromJson(json);
    Map<String, dynamic> toJson() => _$ShaerConfigToJson(this);
}
