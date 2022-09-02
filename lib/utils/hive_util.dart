import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';

class HiveUtil implements BoxCollection {
  factory HiveUtil() {
    return HiveUtil._();
  }

  HiveUtil._();

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

    initByKey(encryptionKey);
  }

  @visibleForTesting
  Future<void> initByKey(List<int> key) async {
    _collection = await BoxCollection.open(
      'UserAuthen',
      {'user_token'},
      path: './',
      key: HiveAesCipher(key),
    );
  }

  @override
  Set<String> get boxNames => _collection.boxNames;

  @override
  void close() {
    _collection.close();
  }

  @override
  Future<void> deleteFromDisk() {
    return _collection.deleteFromDisk();
  }

  @override
  String get name => _collection.name;

  @override
  Future<CollectionBox<V>> openBox<V>(
    String name, {
    bool preload = false,
    CollectionBox<V> Function(String p1, BoxCollection p2)? boxCreator,
  }) {
    return _collection.openBox(name, preload: preload, boxCreator: boxCreator);
  }

  @override
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
