import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vc_space/entity/user_entity.dart';

part 'room_entity.freezed.dart';
part 'room_entity.g.dart';

@freezed
class RoomEntity with _$RoomEntity {
  const factory RoomEntity(
      {required String id,
      required UserEntity owner,
      required String title,
      required String description,
      required DateTime start,
      required int maxNumber}) = _RoomEntity;

  factory RoomEntity.fromJson(Map<String, dynamic> json) =>
      _$RoomEntityFromJson(json);
}

// TODO
RoomEntity createSampleRoom(String title) {
  DateTime start = DateTime.now().add(const Duration(days: 1));
  return RoomEntity(
    id: 'id_test',
    owner: createSampleUser(),
    title: title,
    description: 'test_desc',
    start: start,
    maxNumber: 4,
  );
}
