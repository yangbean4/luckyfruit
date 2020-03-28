import 'package:json_annotation/json_annotation.dart';

part 'treeConfig.g.dart';

@JsonSerializable()
class TreeConfig {
    TreeConfig();

    Map<String,dynamic> content;
    Map<String,dynamic> tree_content;
    Map<String,dynamic> recover_content;
    
    factory TreeConfig.fromJson(Map<String,dynamic> json) => _$TreeConfigFromJson(json);
    Map<String, dynamic> toJson() => _$TreeConfigToJson(this);
}
