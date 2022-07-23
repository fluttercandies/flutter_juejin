// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:process_run/shell.dart';
import 'package:yaml/yaml.dart';

import '../internals/command.dart';
import '../internals/constants.dart';
import '../internals/utils.dart';

class VersionCommand extends JJCommand {
  VersionCommand() : super() {
    argParser
      ..addOption(
        KEY_VERSION,
        abbr: 'v',
        valueHelp: 'The version to change for projects. '
            'The format should be `x.y.z` .',
      )
      ..addFlag(
        KEY_INCREASE_BUILD,
        help: 'Whether the build number should be increased.',
        defaultsTo: true,
      )
      ..addOption(
        KEY_BUILD_NUMBER,
        abbr: 'b',
        help: 'Indicate a new build number.',
      )
      ..addFlag(
        KEY_COMMIT,
        abbr: 'c',
        help: 'Whether the change should be committed automatically.',
        defaultsTo: true,
      )
      ..addFlag(
        KEY_PUSH,
        abbr: 'p',
        help: 'Whether the change should be pushed automatically.',
        defaultsTo: true,
      );
  }

  @override
  String get description => 'Manage versions with Juejin projects.';

  @override
  String get name => 'version';

  @override
  Future<void> runProcess() async {
    if (_version != null &&
        _version!.isNotEmpty &&
        !RegExp(r'^\d+.\d+.\d+$').hasMatch(_version!)) {
      catchingError(
        ArgumentError('Version is invalid. Current version is $_version.'),
        name,
      );
      return;
    }

    await _handleVersionUpdate();
  }

  Future<void> _handleVersionUpdate() async {
    final YamlMap yamlMap = await obtainYamlFromPath(path.current);
    final List<String> _rawVersions = (yamlMap['version'] as String).split('+');
    final String oldVersion = _rawVersions.first;
    final int oldBuildNumber = int.parse(_rawVersions.last);
    final String newVersion = _version ?? oldVersion;
    final int newBuildNumber;
    if (_buildNumber != null) {
      newBuildNumber = _buildNumber!;
    } else if (_shouldIncreaseBuild) {
      newBuildNumber = oldBuildNumber + 1;
    } else {
      newBuildNumber = oldBuildNumber;
    }
    final String newVersionString = '$newVersion+$newBuildNumber';
    log('[$PROJECT_NAME] OLD: ${yamlMap['version']}', color: 32);
    log('[$PROJECT_NAME] NEW: $newVersionString', color: 33);
    final File f = File('${path.current}/pubspec.yaml');
    await f.writeFirstLineStartsWith('version: ', 'version: $newVersionString');
    if (_shouldCommit) {
      await _commitNewVersion(newVersionString);
    }
  }

  Future<void> _commitNewVersion(String version) async {
    final Shell shell = obtainShell(verbose: argResultVerbose);
    await shell.run('git add pubspec.yaml');
    await shell.run('git commit -m "🔖 ## $version"');
    if (_shouldPush) {
      await shell.run('git push');
    }
  }

////////////////////////////////////////////////////////////////////////////////
////////////////////////////// Builder arguments ///////////////////////////////
////////////////////////////////////////////////////////////////////////////////

  late final String? _version = validArgResults[KEY_VERSION] as String?;
  late final int? _buildNumber = validArgResults[KEY_BUILD_NUMBER] as int?;
  late final bool _shouldIncreaseBuild =
      validArgResults[KEY_INCREASE_BUILD] as bool;
  late final bool _shouldCommit = validArgResults[KEY_COMMIT] as bool;
  late final bool _shouldPush = validArgResults[KEY_PUSH] as bool;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// END Builder arguments /////////////////////////////
////////////////////////////////////////////////////////////////////////////////
}

/// The fallback run.
void main(List<String> arguments) => VersionCommand().runStandalone(arguments);
