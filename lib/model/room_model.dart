import 'dart:async';
import 'package:collection/collection.dart';

import '../entity/room_user_entity.dart';
import '../entity/room_entity.dart';
import '../service/const_service.dart';
import '../service/const_system.dart';
import '../service/error_service.dart';
import '../service/time_service.dart';
import 'model_base.dart';

class RoomModel extends ModelBase {
  static final RoomModel _instance = RoomModel._internal();
  final String tableName = 'room';
  final String columns = '''
      *,
      room_user!inner (
        *,
        user!inner (
          name,
          photo,
          discord_name
        )
      )
    ''';

  factory RoomModel() {
    return _instance;
  }

  RoomModel._internal();

  Future hoge() async {
    // TODO
    // supabase
    // .rpc('insert_room_owner')

    // supabase
    //     .from('room')
    //     .update({'max_number': 10})
    //     .eq('room_id', 10010)
    //     .then((_) => debugPrint('success'))
    //     .catchError(ErrorService().onError(null, 'hoge'));
  }

  List<RoomEntity> _getEntityList(dynamic result) {
    if (result == null) return [];
    if (result is! List) return [];
    return result.map((e) => _getEntity(e)!).toList();
  }

  RoomEntity? _getEntity(dynamic result) {
    if (result == null) return null;
    if (result is! Map<String, dynamic>) return null;
    final room = RoomEntity.fromJson(result);
    final users = room.users.sorted((a, b) {
      if (a.roomUserType.value < b.roomUserType.value) return -1;
      if (a.roomUserType.value > b.roomUserType.value) return 1;
      return a.uid.compareTo(b.uid);
    });
    return room.copyWith(users: users);
  }

  Future<RoomEntity?> getById(int roomId) {
    return supabase
        .from(tableName)
        .select(columns)
        .eq('room_id', roomId)
        .lt('room_status', RoomStatus.deleted.value)
        .lt('room_user.room_user_type', RoomUserType.kick.value)
        .single()
        .then(_getEntity)
        .catchError(ErrorService().onError(null, '$tableName.getById'));
  }

  Stream<List<Map<String, dynamic>>> getStream(int roomId) {
    return supabase
        .from(tableName)
        .stream(primaryKey: ['room_id']).eq('room_id', roomId);
  }

  Future<List<RoomEntity>> getList(int page, RoomEntity searchRoom) async {
    final start = page * ConstService.listStep;
    final to = start + ConstService.listStep - 1;
    final startTime = searchRoom.startTime.toUtc().toIso8601String();

    var query = supabase
        .from(tableName)
        .select(columns)
        .lt('room_status', RoomStatus.deleted.value)
        .lt('room_user.room_user_type', RoomUserType.kick.value)
        .gte('start_time', startTime);

    if (searchRoom.tags.isNotEmpty) {
      query.contains('tags', searchRoom.tags);
    }

    return query
        .order('start_time', ascending: true)
        .range(start, to)
        .then(_getEntityList)
        .catchError(
            ErrorService().onError<List<RoomEntity>>([], '$tableName.getList'));
  }

  Future<List<RoomEntity>> getPastList(int page, RoomEntity searchRoom) async {
    final start = page * ConstService.listStep;
    final to = start + ConstService.listStep - 1;
    final startTime = DateTime.now()
        .add(const Duration(hours: ConstService.roomSearchDefaultHour))
        .toUtc()
        .toIso8601String();

    var query = supabase
        .from(tableName)
        .select(columns)
        .lt('room_status', RoomStatus.deleted.value)
        .lt('room_user.room_user_type', RoomUserType.kick.value)
        .lt('start_time', startTime);

    if (searchRoom.tags.isNotEmpty) {
      query.contains('tags', searchRoom.tags);
    }

    return query
        .order('start_time', ascending: false)
        .range(start, to)
        .then(_getEntityList)
        .catchError(
            ErrorService().onError<List<RoomEntity>>([], '$tableName.getList'));
  }

  Future<List<RoomEntity>> getJoinList(String uid) async {
    final startTime = TimeService().today().toUtc().toIso8601String();

    return supabase
        .from(tableName)
        .select('$columns, check:room_user!inner (uid)')
        .in_('check.uid', [uid])
        .lt('room_status', RoomStatus.deleted.value)
        .lt('check.room_user_type', RoomUserType.kick.value)
        .lt('room_user.room_user_type', RoomUserType.kick.value)
        .gte('start_time', startTime)
        .order('start_time', ascending: true)
        .order('updated_at')
        .then(_getEntityList)
        .catchError(ErrorService()
            .onError<List<RoomEntity>>([], '$tableName.getJoinList'));
  }

  Future<List<RoomEntity>> getJoinPastList(
    int page,
    String uid,
    RoomEntity? searchRoom,
  ) async {
    final start = page * ConstService.listStep;
    final to = start + ConstService.listStep - 1;
    final startTime = DateTime.now()
        .add(const Duration(hours: ConstService.roomSearchDefaultHour))
        .toUtc()
        .toIso8601String();

    var query = supabase
        .from(tableName)
        .select('$columns, check:room_user!inner (uid)')
        .in_('check.uid', [uid])
        .lt('room_status', RoomStatus.deleted.value)
        .lt('room_user.room_user_type', RoomUserType.kick.value)
        .lt('start_time', startTime);

    if (searchRoom != null && searchRoom.tags.isNotEmpty) {
      query.contains('tags', searchRoom.tags);
    }

    return query
        .order('start_time')
        .range(start, to)
        .then(_getEntityList)
        .catchError(ErrorService()
            .onError<List<RoomEntity>>([], '$tableName.getJoinPastList'));
  }

  Future<int> insert(RoomEntity room) async {
    var json = room.toJson();
    json.remove('room_id');
    json.remove('room_user');
    json['password'] = encodePassword(json['password']);

    return supabase
        .from(tableName)
        .insert(json)
        .select('room_id')
        .single()
        .then((value) {
      return value['room_id'] as int;
    }).catchError(ErrorService()
            .onError(ConstSystem.idNotFound, '$tableName.insert'));
  }

  Future<bool> update(
    RoomEntity room, {
    List<String>? targetColumnList,
  }) async {
    var json = room.toJson();
    json.remove('room_id');
    json.remove('owner');
    json.remove('room_user');

    json = selectUpdateColumn(json, targetColumnList);

    return supabase
        .from(tableName)
        .update(json)
        .eq('room_id', room.roomId)
        .then((_) => true)
        .catchError(ErrorService().onError(false, '$tableName.update'));
  }
}
