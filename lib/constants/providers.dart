import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:juejin/exports.dart';

final authProvider = FutureProvider<UserAuthen>((ref) {
  // TODO
  return UserAuthen();
});

final userinfoProvider = FutureProvider<UserInfoModel>((ref) {
  final token = ref.watch(authProvider.future);
  // TODO
  return UserInfoModel.fromJson({});
});
