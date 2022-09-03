import 'package:hive/hive.dart';

import '../exports.dart';

part 'repositories.g.dart';

@HiveType(typeId: 1, adapterName: 'UserAuthenAdapter')
class UserAuthen extends HiveObject {
  UserAuthen({
    this.token = '',
    this.refreshToken = '',
    this.expireIn = 0,
    this.timestamp = 0,
  });

  @HiveField(0)
  String token;
  @HiveField(1)
  String refreshToken;
  @HiveField(2)
  int expireIn;
  @HiveField(3)
  int timestamp;

  Json toJson() => {
        'token': token,
        'refreshToken': refreshToken,
        'expireIn': expireIn,
        'timestamp': timestamp,
      };
}
