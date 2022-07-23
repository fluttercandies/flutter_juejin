// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import 'constants.dart';
import 'utils.dart';

abstract class JJCommand extends Command<void> {
  /// Remember to call `super` when constructing with a subclass.
  JJCommand() {
    argParser.addFlag(
      KEY_VERBOSE,
      help: 'Display full outputs.',
    );
  }

  ArgResults get validArgResults => argResults ?? _fallbackResults;
  late ArgResults _fallbackResults;
  late final bool argResultVerbose =
      validArgResults[KEY_VERBOSE] as bool? ?? false;
  final Stopwatch stopwatch = Stopwatch();

  Future<void> runProcess();

  FutureOr<void> afterRan() async {}

  @override
  Future<void> run() async {
    _throwIfNotSupported();
    try {
      stopwatch.start();
      await runProcess();
      stopwatch.stop();
      await afterRan();
    } catch (e) {
      log(composeLogString('Exception occurred: $e'));
      log(composeLogString('========== STACK TRACE =========='));
      log(composeLogString(e.nullableStackTrace.toString()));
      exit(-1);
    }
  }

  /// This allow the command to be ran as a standalone.
  void runStandalone(List<String> arguments) {
    _fallbackResults = argParser.parse(arguments);
    runZonedGuarded<void>(runProcess, (Object e, StackTrace s) {
      log(composeLogString('Exception occurred: $e'));
      log(composeLogString('========== STACK TRACE =========='));
      log(composeLogString(s));
      exit(-1);
    });
  }

  void _throwIfNotSupported() {
    if (!Platform.isMacOS && !Platform.isWindows && !Platform.isLinux) {
      throw OSError('${Platform.operatingSystem} is not supported.');
    }
  }
}

extension _NullableObjectExtension on Object? {
  StackTrace? get nullableStackTrace {
    if (this is Error?) {
      return (this as Error?)?.stackTrace;
    }
    return null;
  }
}
