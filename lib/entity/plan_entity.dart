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

  final TextEditingController titleController = TextEditingController();

  PlanEntity(this.id, this.owner, this.title, this.description, this.start,
      this.maxNumber) {
    titleController.text = title;
  }

  @override
  String toString() {
    return """{
      id: $id,
      title: $title,
    }""";
  }
}
