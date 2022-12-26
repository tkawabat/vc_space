import 'package:flutter/material.dart';
import 'package:vc_space/entity/user_entity.dart';

@immutable
class PlanEntity {
  final String id;
  final UserEntity owner;
  final String title;
  final String description;
  final DateTime start;
  final int maxNumber;

  const PlanEntity(this.id, this.owner, this.title, this.description,
      this.start, this.maxNumber);

  @override
  String toString() {
    return """{
      id: $id,
      title: $title,
    }""";
  }
}
