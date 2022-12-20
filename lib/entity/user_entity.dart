import 'package:flutter/material.dart';

@immutable
class UserEntity {
  final String id;
  final String name;
  final String photo;
  final String twitterId;
  final List<String> tags;

  const UserEntity(this.id, this.name, this.photo, this.twitterId, this.tags);

  @override
  String toString() {
    return """{
      id: $id,
      name: $name,
    }""";
  }
}
