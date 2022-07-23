// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:url_launcher/url_launcher_string.dart';

class Urls {
  const Urls._();

  static const String domain = 'juejin.cn';
  static const String apiHost = 'api.$domain';

  static Future<bool> canLaunch(String urlString) {
    return canLaunchUrlString(urlString);
  }

  static Future<bool> launchOnDevice(
    String urlString, {
    LaunchMode mode = LaunchMode.externalApplication,
    WebViewConfiguration webViewConfiguration = const WebViewConfiguration(),
    String? webOnlyWindowName,
  }) {
    return launchUrlString(
      urlString,
      mode: mode,
      webViewConfiguration: webViewConfiguration,
      webOnlyWindowName: webOnlyWindowName,
    );
  }
}
