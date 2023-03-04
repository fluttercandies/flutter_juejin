import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/data_model.dart';
import '../models/repositories.dart';
import '../utils/hive_util.dart';

const _tokenKey = 'token';

class TokenNotifier extends StateNotifier<UserAuthen> {
  TokenNotifier(super.state);

  bool get isLogin => state.token.isNotEmpty;

  void restore() {
    final data = HiveUtil.box.get(_tokenKey);
    if (data != null) {
      state = data;
    }
  }

  void update(String token) {
    state = UserAuthen(
      token: token,
      expireIn: 7200,
      timestamp: DateTime.now().millisecond,
    );
    saveState();
  }

  void logout() {
    state = UserAuthen();
    saveState();
  }

  void saveState() {
    if (state.token.isEmpty) {
      HiveUtil.box.delete(_tokenKey);
    } else {
      HiveUtil.box.put(_tokenKey, state);
    }
  }
}

class UserPassportNotifier extends StateNotifier<UserPassportModel> {
  UserPassportNotifier(super.state);

  void update(UserPassportModel data) {
    state = data;
  }
}

final tokenProvider = StateNotifierProvider<TokenNotifier, UserAuthen>((ref) {
  final userPassport = ref.watch(userProvider);
  if (userPassport.isEmpty) {
    return TokenNotifier(UserAuthen());
  }
  return TokenNotifier(
    UserAuthen(
      token: userPassport.sessionKey,
      expireIn: 7200,
      timestamp: DateTime.now().millisecond,
    ),
  )..saveState();
});

final userProvider =
    StateNotifierProvider<UserPassportNotifier, UserPassportModel>((ref) {
  return UserPassportNotifier(const UserPassportModel.empty());
});
