// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/log_util.dart';
// import 'package:permission_handler/permission_handler.dart';

/// Check permissions and only return whether they succeed or not.
// Future<bool> checkPermissions(List<Permission> permissions) async {
//   try {
//     final Map<Permission, PermissionStatus> status =
//         await permissions.request();
//     // Delay until next frame.
//     await 300.milliseconds.delay;
//     return status.values.every((PermissionStatus p) => p.isGranted);
//   } catch (e, stack) {
//     LogUtil.e('Error when requesting permission: $e', stackTrace: stack);
//     return false;
//   }
// }

/// Iterate element and its children to request rebuild.
void rebuildAllChildren(BuildContext context) {
  LogUtil.d('Rebuilding all elements...', tag: 'rebuildAllChildren');
  void rebuild(Element el) {
    el.markNeedsBuild();
    el.visitChildren(rebuild);
  }

  (context as Element).visitChildren(rebuild);
}

Map<String, dynamic> decodeAsJson(String value) {
  return jsonDecode(value) as Map<String, dynamic>;
}

Future<void> exitApp() async {
  await SystemNavigator.pop(animated: true);
  exit(0);
}
