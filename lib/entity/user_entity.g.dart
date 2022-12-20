// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_UserEntity _$$_UserEntityFromJson(Map json) => _$_UserEntity(
      id: json['id'] as String,
      name: json['name'] as String,
      photo: json['photo'] as String,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      twitterId: json['twitterId'] as String,
    );

Map<String, dynamic> _$$_UserEntityToJson(_$_UserEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photo': instance.photo,
      'tags': instance.tags,
      'twitterId': instance.twitterId,
    };
