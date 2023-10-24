// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';

import 'log_util.dart';

class DeviceUtil {
  const DeviceUtil._();

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static Object? deviceInfo;
  static AndroidDeviceInfo? androidInfo;
  static IosDeviceInfo? iOSInfo;

  static DisplayMode? _highestRefreshRateMode;

  static String deviceModel = 'Juejin device';
  static String? devicePushToken;
  static String? deviceUuid;
  static String osName = 'Others';
  static String osVersion = 'Unknown';

  static Future<void> initDeviceInfo({bool forceRefresh = false}) async {
    if (deviceInfo != null && !forceRefresh) {
      return;
    }
    await Future.wait(
      <Future<void>>[
        _getModel(),
        if (Platform.isAndroid) _getHighestRefreshRate(),
      ],
    );
  }

  static Future<void> _getModel() async {
    if (Platform.isAndroid) {
      deviceInfo = await _deviceInfoPlugin.androidInfo;
      androidInfo = deviceInfo as AndroidDeviceInfo;

      deviceModel = androidInfo!.device;
      osName = 'Android';
      osVersion = androidInfo!.version.sdkInt.toString();
    } else if (Platform.isIOS) {
      deviceInfo = await _deviceInfoPlugin.iosInfo;
      iOSInfo = deviceInfo as IosDeviceInfo;

      deviceModel = iOSInfo!.localizedModel;
      osName = 'iOS';
      osVersion = iOSInfo!.systemVersion.toString();
    } else {
      deviceInfo = await _deviceInfoPlugin.deviceInfo;
      deviceModel = deviceInfo.toString();
      osName = 'Others';
      osVersion = 'Unknown';
    }
    LogUtil.d('Device model: $deviceModel', tag: '⚙️ DeviceUtil');
  }

  /// Search for the highest refresh rate with the same screen size and save.
  static Future<void> _getHighestRefreshRate() async {
    if (!Platform.isAndroid || androidInfo?.version.sdkInt == null) {
      return;
    }
    // Apply only on Android 23+.
    final int sdkInt = androidInfo!.version.sdkInt;
    if (sdkInt < 23) {
      return;
    }
    // Delay 1 second since bindings will need to reconnect.
    await Future.delayed(const Duration(seconds: 1));
    final DisplayMode current = await FlutterDisplayMode.active;
    // Search for the highest refresh rate with the same screen size and save.
    if (_highestRefreshRateMode == null) {
      final List<DisplayMode> modes = await FlutterDisplayMode.supported;
      final Iterable<DisplayMode> matchedModes = modes.where(
        (DisplayMode mode) =>
            mode.width == current.width && mode.height == current.height,
      );
      if (matchedModes.isNotEmpty) {
        _highestRefreshRateMode = matchedModes.reduce(
          (DisplayMode value, DisplayMode element) =>
              value.refreshRate > element.refreshRate ? value : element,
        );
      }
    }
    final DisplayMode? highest = _highestRefreshRateMode;
    if (highest == null) {
      return;
    }
    // Apply when the current refresh rate is lower than the highest.
    if (current.refreshRate < highest.refreshRate) {
      _logRefreshRateChanges(current, highest);
      await FlutterDisplayMode.setPreferredMode(highest);
      final DisplayMode newMode = await FlutterDisplayMode.active;
      // Only apply resampling when the refresh rate has been updated.
      if (newMode.refreshRate > current.refreshRate) {
        GestureBinding.instance.resamplingEnabled = true;
      }
    }
  }

  static Future<void> setHighestRefreshRate() async {
    if (!Platform.isAndroid || androidInfo?.version.sdkInt == null) {
      return;
    }
    // Apply only on Android 23+.
    final int sdkInt = androidInfo!.version.sdkInt;
    if (sdkInt < 23) {
      return;
    }
    final DisplayMode current = await FlutterDisplayMode.active;
    if (_highestRefreshRateMode == null) {
      return;
    }
    final DisplayMode? highest = _highestRefreshRateMode;
    if (highest == null) {
      return;
    }
    // Apply when the current refresh rate is lower than the highest.
    if (current.refreshRate < highest.refreshRate) {
      _logRefreshRateChanges(current, highest);
      await FlutterDisplayMode.setPreferredMode(highest);
      final DisplayMode newMode = await FlutterDisplayMode.active;
      // Only apply resampling when the refresh rate has been updated.
      if (newMode.refreshRate > current.refreshRate) {
        GestureBinding.instance.resamplingEnabled = true;
      }
    }
  }

  static void _logRefreshRateChanges(DisplayMode before, DisplayMode after) {
    final String beforeString = '${before.refreshRate.toInt()}'.padRight(7);
    final String afterString = '${after.refreshRate.toInt()}'.padRight(7);
    final String sizeHeader =
        'Screen: ${after.width}×${after.height}'.padRight(17);
    LogUtil.d(
      'Refresh rate update:\n'
      '${'-' * 21}\n'
      '| $sizeHeader |\n'
      '| Before  | After   |\n'
      '| $beforeString | $afterString |\n'
      '${'-' * 21}',
      tag: '📱 DisplayMode',
    );
  }
}

extension LogAndroidInfoExtension on AndroidDeviceInfo {
  String get forLog => '$manufacturer $model (Android ${version.sdkInt})';
}

extension LogIOSInfoExtension on IosDeviceInfo {
  String get forLog => '$name (iOS $systemVersion)';
}
