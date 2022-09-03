import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../models/repositories.dart';

class HiveUtil {
  HiveUtil._();

  static const hiveData = 'hive';

  static const userToken = 'user_token';

  static BoxCollection? _collection;

  static BoxCollection get collection => _collection!;

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

    _collection = await BoxCollection.open(
      hiveData,
      {userToken},
      path: '${path.replaceFirst(RegExp(r'[\\/]$'), '')}/',
      key: HiveAesCipher(key),
    );
  }

  static Set<String> get boxNames => collection.boxNames;

  static void close() {
    collection.close();
  }

  static Future<void> deleteFromDisk() {
    return collection.deleteFromDisk();
  }

  static String get name => collection.name;

  static Future<CollectionBox<V>> openBox<V>(
    String name, {
    bool preload = false,
    CollectionBox<V> Function(String, BoxCollection)? boxCreator,
  }) {
    return collection.openBox<V>(
      name,
      preload: preload,
      boxCreator: boxCreator,
    );
  }

  static Future<void> transaction(
    Future<void> Function() action, {
    List<String>? boxNames,
    bool readOnly = false,
  }) {
    return collection.transaction(
      action,
      boxNames: boxNames,
      readOnly: readOnly,
    );
  }
}
