import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vc_space/entity/user_entity.dart';

part 'room_entity.freezed.dart';
part 'room_entity.g.dart';

enum EnterType {
  noLimit('制限なし'),
  follow('フォローのみ'),
  password('パスワード'),
  ;

  const EnterType(this.displayName);
  final String displayName;
}

@freezed
class RoomEntity with _$RoomEntity {
  const factory RoomEntity({
    required String ownerId,
    required String ownerImage,
    required String title,
    required String description,
    required DateTime startTime,
    required List<String> tags,
    required int maxNumber,
    required String enterType,
    required DateTime updatedAt,
  }) = _RoomEntity;

  factory RoomEntity.fromJson(Map<String, dynamic> json) =>
      _$RoomEntityFromJson(json);
}

// TODO
RoomEntity createSampleRoom(String title) {
  DateTime startTime = DateTime.now().add(const Duration(days: 1));
  return RoomEntity(
    ownerId: 'xxxx',
    ownerImage:
        'https://pbs.twimg.com/profile_images/1245965644094246912/rOuCIpPu_normal.jpg',
    title: title,
    description: 'test_desc',
    startTime: startTime,
    tags: ["hoge"],
    maxNumber: 4,
    enterType: EnterType.noLimit.name,
    updatedAt: DateTime.now(),
  );
}
