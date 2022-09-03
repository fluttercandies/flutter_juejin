import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:juejin/exports.dart';

void main() {
  HiveUtil().initByKey(
    [
      69, 65, 214, 189, 167, 95, 128, 69, //
      125, 194, 153, 172, 57, 105, 57, 253,
      20, 174, 135, 53, 77, 167, 78, 244,
      248, 168, 30, 29, 185, 35, 89, 139,
    ],
    '${Directory.current.path}/test/hive',
  );
  test('user_token', () async {
    final box = await HiveUtil().openBox<UserAuthen>(HiveUtil.userToken);

    expect(box.name, '${HiveUtil.hiveData}_${HiveUtil.userToken}');

    await box.clear();
    await box.put('token', UserAuthen(token: 'test-token'));

    final token = await box.get('token');
    expect(token?.token, 'test-token');

    HiveUtil().close();
  });
}
