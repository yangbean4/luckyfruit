// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treeConfig.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TreeConfig _$TreeConfigFromJson(Map<String, dynamic> json) {
  return TreeConfig()
    ..content = json['content'] as Map<String, dynamic>
    ..tree_content = json['tree_content'] as Map<String, dynamic>
    ..recover_content = json['recover_content'] as Map<String, dynamic>;
}

Map<String, dynamic> _$TreeConfigToJson(TreeConfig instance) =>
    <String, dynamic>{
      'content': instance.content,
      'tree_content': instance.tree_content,
      'recover_content': instance.recover_content
    };
