import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../exports.dart';

class HiveUtil {
  factory HiveUtil() {
    _instance ??= HiveUtil._();
    return _instance!;
  }

  HiveUtil._();

  static HiveUtil? _instance;

  static const hiveData = 'hive';

  static const userToken = 'user_token';

  late final BoxCollection _collection;

  Future<void> init() async {
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
  Future<void> initByKey(List<int> key, String path) async {
    Hive.registerAdapter<UserAuthen>(UserAuthenAdapter());

    _collection = await BoxCollection.open(
      hiveData,
      {userToken},
      path: '${path.replaceFirst(RegExp(r'[\\/]$'), '')}/',
      key: HiveAesCipher(key),
    );
  }

  Set<String> get boxNames => _collection.boxNames;

  void close() {
    _collection.close();
  }

  Future<void> deleteFromDisk() {
    return _collection.deleteFromDisk();
  }

  String get name => _collection.name;

  Future<CollectionBox<V>> openBox<V>(
    String name, {
    bool preload = false,
    CollectionBox<V> Function(String, BoxCollection)? boxCreator,
  }) {
    return _collection.openBox<V>(
      name,
      preload: preload,
      boxCreator: boxCreator,
    );
  }

  Future<void> transaction(
    Future<void> Function() action, {
    List<String>? boxNames,
    bool readOnly = false,
  }) {
    return _collection.transaction(
      action,
      boxNames: boxNames,
      readOnly: readOnly,
    );
  }
}
