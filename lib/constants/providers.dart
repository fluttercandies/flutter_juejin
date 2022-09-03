import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/data_model.dart';
import '../models/repositories.dart';

final authProvider = FutureProvider<UserAuthen>((ref) {
  // TODO(shirne): fetch authentication from api and managment lifecycle
  return UserAuthen();
});

final userinfoProvider = FutureProvider<UserInfoModel>((ref) {
  final token = ref.watch(authProvider.future);
  // TODO(shirne): fetch userinfo with token from api
  return UserInfoModel.fromJson({});
});
