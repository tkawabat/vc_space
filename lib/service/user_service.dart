import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../entity/user_entity.dart';
import '../entity/user_private_entity.dart';
import '../model/user_model.dart';
import '../model/user_private_model.dart';
import '../provider/login_user_private_provider.dart';
import '../provider/login_user_provider.dart';
import '../provider/user_list_provider.dart';
import 'analytics_service.dart';
import 'const_service.dart';
import 'const_system.dart';
import 'page_service.dart';

class UserService {
  static final UserService _instance = UserService._internal();

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  bool isFollowed(UserEntity user, String targetUid) {
    return user.follows.contains(targetUid);
  }

  FutureOr<bool> update(UserEntity user) {
    return UserModel().update(user).then((_) {
      PageService().ref!.read(loginUserProvider.notifier).set(user);
      PageService().ref!.read(userListProvider.notifier).set(user);
      PageService().snackbar('保存しました。', SnackBarType.info);
      logEvent(LogEventName.user_save, 'user');
      return true;
    }).catchError((_) {
      PageService().snackbar('保存に失敗しました。', SnackBarType.error);
      return false;
    });
  }

  FutureOr<bool> follow(UserEntity user, String targetUid) {
    if (user.follows.length >= ConstService.followMax) {
      PageService().snackbar(
          'フォローできるユーザーは${ConstService.followMax}人までです', SnackBarType.error);
      return false;
    }
    if (user.follows.contains(targetUid)) {
      PageService().snackbar('すでにフォロー中です', SnackBarType.error);
      return false;
    }

    return UserModel().follow(targetUid).then((_) {
      PageService().ref!.read(loginUserProvider.notifier).follow(targetUid);
      PageService().snackbar('フォローしました', SnackBarType.info);
      logEvent(LogEventName.follow, 'user');
      return true;
    }).catchError((_) {
      PageService().snackbar('フォローでエラーが発生しました', SnackBarType.error);
      return false;
    });
  }

  Future<bool> unfollow(String targetUid) {
    return UserModel().unfollow(targetUid).then((_) {
      PageService().ref!.read(loginUserProvider.notifier).unfollow(targetUid);
      PageService().snackbar('フォロー解除しました', SnackBarType.info);
      logEvent(LogEventName.unfollow, 'user');
      return true;
    }).catchError((_) {
      PageService().snackbar('フォロー解除でエラーが発生しました', SnackBarType.error);
      return false;
    });
  }

  bool isBlocked(UserPrivateEntity userPrivate, String targetUid) {
    return userPrivate.blocks.contains(targetUid);
  }

  FutureOr<bool> block(UserPrivateEntity userPrivate, String targetUid) {
    if (userPrivate.blocks.length >= ConstService.blockMax) {
      PageService().snackbar(
          'ブロックできるユーザーは${ConstService.blockMax}人までです', SnackBarType.error);
      return false;
    }
    if (userPrivate.blocks.contains(targetUid)) {
      PageService().snackbar('すでにブロック中です', SnackBarType.error);
      return false;
    }

    final blocks = [...userPrivate.blocks];
    blocks.add(targetUid);
    final newObj = userPrivate.copyWith(blocks: blocks);

    return UserPrivateModel().update(newObj).then((_) {
      PageService().ref!.read(loginUserPrivateProvider.notifier).set(newObj);
      PageService().snackbar('ブロックしました', SnackBarType.info);
      logEvent(LogEventName.block, 'user');
      return true;
    }).catchError((_) {
      PageService().snackbar('ブロックでエラーが発生しました', SnackBarType.error);
      return false;
    });
  }

  FutureOr<bool> unblock(UserPrivateEntity userPrivate, String targetUid) {
    if (!userPrivate.blocks.contains(targetUid)) {
      PageService().snackbar('すでにブロック解除されています', SnackBarType.error);
      return false;
    }

    final blocks = [...userPrivate.blocks];
    blocks.remove(targetUid);
    final newObj = userPrivate.copyWith(blocks: blocks);
    return UserPrivateModel().update(newObj).then((_) {
      PageService().ref!.read(loginUserPrivateProvider.notifier).set(newObj);
      PageService().snackbar('ブロック解除しました', SnackBarType.info);
      logEvent(LogEventName.unblock, 'user');
      return true;
    }).catchError((_) {
      PageService().snackbar('フォロー解除でエラーが発生しました', SnackBarType.error);
      return false;
    });
  }

  FutureOr<bool> readNotice() {
    if (PageService().ref == null) return false;
    final loginUserPrivate = PageService().ref!.read(loginUserPrivateProvider);

    if (loginUserPrivate == null) return false;

    final newObj = loginUserPrivate.copyWith(noticeReadTime: DateTime.now());

    return UserPrivateModel().update(newObj).then((_) {
      PageService().ref!.read(loginUserPrivateProvider.notifier).set(newObj);
      return true;
    }).catchError((_) {
      return false;
    });
  }

  FutureOr<bool> addFcmToken() async {
    if (PageService().ref == null) return false;

    String? token = await FirebaseMessaging.instance
        .getToken(vapidKey: dotenv.get('FCM_VAPID_KEY', fallback: ''))
        .catchError((error) {
      return null;
    });
    if (token == null) {
      PageService().snackbar('プッシュ通知登録エラー', SnackBarType.error);
      return false;
    }

    final loginUserPrivate = PageService().ref!.read(loginUserPrivateProvider);

    if (loginUserPrivate == null) return false;

    // 追加済み
    if (loginUserPrivate.fcmTokens.contains(token)) {
      PageService().snackbar('このデバイスはすでに登録済みです', SnackBarType.error);
      return false;
    }

    // update
    final tokens = [...loginUserPrivate.fcmTokens];
    while (tokens.length >= ConstSystem.fcmTokenNum) {
      tokens.removeAt(0);
    }
    tokens.add(token);
    final newObj = loginUserPrivate.copyWith(fcmTokens: tokens);

    return UserPrivateModel().update(newObj).then((_) {
      PageService().ref!.read(loginUserPrivateProvider.notifier).set(newObj);
      PageService().snackbar('プッシュ通知のデバイス登録をしました', SnackBarType.info);
      logEvent(LogEventName.push_token_add, 'user');
      return true;
    }).catchError((_) {
      return false;
    });
  }

  FutureOr<bool> deleteFcmTokens() {
    final loginUserPrivate = PageService().ref!.read(loginUserPrivateProvider);
    if (loginUserPrivate == null) return false;

    final newObj = loginUserPrivate.copyWith(fcmTokens: []);

    return UserPrivateModel().update(newObj).then((_) {
      PageService().ref!.read(loginUserPrivateProvider.notifier).set(newObj);
      PageService().snackbar('プッシュ通知のデバイスを削除しました', SnackBarType.info);
      logEvent(LogEventName.push_token_delete, 'user');
      return true;
    }).catchError((_) {
      return false;
    });
  }
}
