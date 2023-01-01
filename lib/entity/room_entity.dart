import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vc_space/entity/user_entity.dart';

part 'room_entity.freezed.dart';
part 'room_entity.g.dart';

@freezed
class RoomEntity with _$RoomEntity {
  const factory RoomEntity(
      {String? id,
      required UserEntity owner,
      required String title,
      required String description,
      required DateTime startTime,
      required List<String> tags,
      required int maxNumber}) = _RoomEntity;

  factory RoomEntity.fromJson(Map<String, dynamic> json) =>
      _$RoomEntityFromJson(json);
}

// TODO
RoomEntity createSampleRoom(String title) {
  DateTime startTime = DateTime.now().add(const Duration(days: 1));
  return RoomEntity(
    owner: createSampleUser(),
    title: title,
    description: 'test_desc',
    startTime: startTime,
    tags: ["hoge"],
    maxNumber: 4,
  );
}
