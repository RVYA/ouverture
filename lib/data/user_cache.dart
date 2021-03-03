import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart' show HiveX;

import '../models/user.dart';
import '../repositories/user_repository.dart';


class UserCacheDoesNotExistsException implements Exception {
  const UserCacheDoesNotExistsException({this.message});

  final String message;

  @override
  String toString() => message ?? this.runtimeType;
}


const String _kBoxUserCache = "userCacheBox";
const String _kKeyCachedUserId = "signedInUserId";


class UserCache {
  const UserCache._internal();

  factory UserCache() => _instance;
  static final UserCache _instance = const UserCache._internal();


  Future<void> initialize() async {
    await Hive.initFlutter();
    final bool doesBoxExists = await Hive.boxExists(_kBoxUserCache);

    if (doesBoxExists) await Hive.openBox<String>(_kBoxUserCache);
  }

  Future<void> cacheSignedUserId(String userId) async {
    final Box cache = await Hive.openBox<String>(_kBoxUserCache);
    return cache.put(_kKeyCachedUserId, userId);
  }

  Future<void> dispose() {
    return Hive.close();
  }

  Future<User> recoverUser() async {
    final bool doesCacheExists = await Hive.boxExists(_kBoxUserCache);

    if (doesCacheExists) {
      final Box<String> cache = await Hive.openBox<String>(_kBoxUserCache);
      final String cachedUserId = cache.get(_kKeyCachedUserId);

      return
        await UserRepository().getUserWith(
                                id: cachedUserId,
                                doReturnCurrentPlace: true,
                                doReturnPhoneNumber: true,
                                doReturnPhotographUrl: true,
                              );
    } else {
      throw UserCacheDoesNotExistsException();
    }
  }

  Future<void> wipeUserCache() {
    return Hive.deleteBoxFromDisk(_kBoxUserCache);
  }
}