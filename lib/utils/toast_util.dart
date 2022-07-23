// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:oktoast/oktoast.dart' as ok;

import '../constants/styles.dart' show failedColor;

void showToast(String text, {Duration? duration}) {
  ok.showToast(text, duration: duration);
}

void showCenterToast(String text) {
  ok.showToast(
    text,
    position: ok.ToastPosition.center,
  );
}

void showErrorToast(String text) {
  ok.showToast(
    text,
    backgroundColor: failedColor,
  );
}

void showCenterErrorToast(String text) {
  ok.showToast(
    text,
    position: ok.ToastPosition.center,
    backgroundColor: failedColor,
  );
}

void showTopToast(String text) {
  ok.showToast(
    text,
    position: ok.ToastPosition.top,
  );
}

void showToastWithPosition(String text, {ok.ToastPosition? position}) {
  ok.showToast(
    text,
    position: position,
  );
}

void showErrorToastWithPosition(String text, {ok.ToastPosition? position}) {
  ok.showToast(
    text,
    position: position,
  );
}

void dismissAllToast({bool showAnim = false}) {
  ok.dismissAllToast(showAnim: showAnim);
}
