import 'dart:async';

import '../entity/user_entity.dart';
import '../entity/user_private_entity.dart';
import '../model/user_model.dart';
import '../model/user_private_model.dart';
import '../provider/login_user_private_provider.dart';
import '../provider/login_user_provider.dart';
import 'const_service.dart';
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
}
