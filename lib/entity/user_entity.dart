import 'package:flutter/material.dart';

@immutable
class UserEntity {
  final String id;
  final String name;

  const UserEntity(this.id, this.name);
}
