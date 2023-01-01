import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vc_space/entity/room_entity.dart';

class RoomModel {
  static Future<Stream<RoomEntity>> createRoom(RoomEntity room) {
    return FirebaseFirestore.instance
        .collection('room')
        .add(room.toJson())
        .then((result) => result
            .snapshots()
            .map((snapshot) => RoomEntity.fromJson(snapshot.data()!)));
  }

  static Future<List<RoomEntity>> getRoomList() {
    return FirebaseFirestore.instance
        .collection('room')
        .get()
        .then((results) => results.docs
            .map((snapshot) => RoomEntity.fromJson(snapshot.data()))
            .toList())
        .catchError((error) {
      debugPrint(error);
      return [] as List<RoomEntity>;
    });
  }

  static Future<RoomEntity?> getRoom(String id) {
    return FirebaseFirestore.instance
        .collection('room')
        .doc(id)
        .get()
        .then((result) {
      if (!result.exists) {
        return null;
      }
      return RoomEntity.fromJson(result.data()!);
    }).catchError((error) {
      debugPrint(error);
      return null;
    });
  }
}
