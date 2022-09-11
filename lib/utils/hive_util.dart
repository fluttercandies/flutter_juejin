import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../models/repositories.dart';

class HiveUtil {
  HiveUtil._();

  static const userToken = 'user_token';

  static Box<UserAuthen>? _box;
  static Box<UserAuthen> get box => _box!;

  static Future<void> init() async {
    const secureStorage = FlutterSecureStorage();
    String? secureKey = await secureStorage.read(key: 'key');
    if (secureKey == null) {
      final key = Hive.generateSecureKey();
      await secureStorage.write(
        key: 'key',
        value: base64UrlEncode(key),
      );
      secureKey = (await secureStorage.read(key: 'key'))!;
    }

    final encryptionKey = base64Url.decode(secureKey);

    final appDocDir = await getApplicationDocumentsDirectory();

    initByKey(encryptionKey, appDocDir.path);
  }

  @visibleForTesting
  static Future<void> initByKey(List<int> key, String path) async {
    Hive.registerAdapter<UserAuthen>(UserAuthenAdapter());

    _box = await Hive.openBox<UserAuthen>(
      HiveUtil.userToken,
      encryptionCipher: HiveAesCipher(key),
      path: '${path.replaceFirst(RegExp(r'[\\/]$'), '')}/',
    );
  }

  /// open another box
  static Future<Box<V>> openBox<V>(String name) {
    assert(name != HiveUtil.userToken, 'Please use HiveUtil.box');
    return Hive.openBox<V>(
      name,
      path: box.path,
    );
  }

  static String get name => box.name;

  static void close() {
    box.close();
  }

  static Future<void> deleteFromDisk() {
    return box.deleteFromDisk();
  }
}
