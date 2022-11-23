import 'package:flutter/material.dart';

@immutable
class PlanEntity {
  final String id;
  final String title;

  const PlanEntity(this.id, this.title);
}
