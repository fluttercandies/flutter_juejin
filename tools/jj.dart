// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:process_run/shell.dart';

import 'internals/command.dart';
import 'internals/utils.dart';
import 'src/models.dart';
import 'src/release.dart';
import 'src/version.dart';

void main(List<String> arguments) {
  runZonedGuarded<void>(() async {
    final CommandRunner<void> runner = CommandRunner<void>(
      'jj',
      'Manage your Juejin app development',
    );
    _command.forEach(runner.addCommand);
    await runner.run(arguments);
  }, (Object e, StackTrace s) {
    log(composeLogString('Exception occurred: $e'));
    if (e is ShellException) {
      log(composeLogString('==========   STD ERR   =========='));
      log(composeLogString(e.result?.stderr));
    }
    if (s != StackTrace.empty) {
      log(composeLogString('========== STACK TRACE =========='));
      log(composeLogString(s));
    }
    exit(-1);
  });
}

final List<JJCommand> _command = <JJCommand>[
  ModelsCommand(),
  ReleaseCommand(),
  VersionCommand(),
];
