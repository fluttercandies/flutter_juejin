// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:process_run/shell.dart';
import 'package:yaml/yaml.dart';

import '../internals/command.dart';
import '../internals/constants.dart';
import '../internals/defs.dart';
import '../internals/utils.dart';

class ReleaseCommand extends JJCommand {
  ReleaseCommand() : super() {
    argParser
      ..addOption(
        KEY_APP_CHANNEL,
        defaultsTo: 'inside',
        valueHelp: 'Define the app channel.',
      )
      ..addMultiOption(
        KEY_WITH,
        allowed: <String>['all', 'android', 'ios'],
        help: 'Which platform will be built.',
      )
      ..addOption(
        KEY_ANDROID_BUILD_TYPE,
        defaultsTo: 'apk',
        allowed: <String>['apk', 'appbundle'],
      )
      ..addOption(
        KEY_IOS_METHOD,
        defaultsTo: IOS_METHOD_ADHOC,
        allowed: <String>[IOS_METHOD_ADHOC, IOS_METHOD_STORE],
        valueHelp: 'Define which method should be built for iOS.',
      );
  }

  @override
  String get name => 'release';

  @override
  String get description => 'Manage the release process of the Juejin project.';

  @override
  Future<void> runProcess() async {
    // Raise judgements first.
    if (_platforms.isEmpty) {
      throw ArgumentError('At lease one build artifacts should be used.');
    }
    if (!Platform.isMacOS && _shouldBuildIOS) {
      throw const OSError('iOS build only support on MacOS', 1);
    }
    if (_shouldBuildIOS &&
        !File('${path.current}/../$_iOSMethod-ExportOptions.plist')
            .existsSync()) {
      throw OSError("$_iOSMethod isn't a valid method.", 1);
    }

    _buildTime = DateFormat('yyyyMMddHHmm').format(DateTime.now());
    logConfigurations();

    log('‼️　Think twice before every build.', color: 35);
    await Future<void>.delayed(const Duration(seconds: 5));
    // Heeeere weeeeeeeeee gooooooooooooooooooooooooooo!
    stopwatch.start();

    try {
      if (!Directory('${path.current}/../$RELEASE_DIR').existsSync()) {
        Directory('${path.current}/../$RELEASE_DIR').createSync();
      }
      await startBuildProcess();
      log("🎉　You're good to go.", color: 32);
      await _openReleaseDirectory();
    } on ShellException catch (e, s) {
      log('ShellException thrown: ${e.message}\n$s');
      final ProcessResult? result = e.result;
      if (result != null) {
        log('[PID   ]: ${result.pid}');
        log('[EXIT  ]: ${result.exitCode}');
        log('[STDOUT]: ${result.stdout}');
        log('[STDERR]: ${result.stderr}');
      }
      stopProcess(-1);
    } catch (e, s) {
      log('Error occurred: $e\n$s');
      stopProcess(-1);
    }
  }

  @override
  Future<void> afterRan() async => stopProcess(0);

  Future<void> startBuildProcess() async {
    final YamlMap projectYamlMap = await obtainYamlFromPath(path.current);
    log('🔔　Building $PROJECT_NAME ...', color: 36);
    sleep(const Duration(seconds: 3));

    final Shell shell = Shell(
      verbose: argResultVerbose,
      commandVerbose: argResultVerbose,
      commentVerbose: argResultVerbose,
    );
    log('📦　[$PROJECT_NAME] Pub getting packages...', color: 34);
    await shell.run('flutter pub get');
    await shell.run('flutter pub upgrade');
    final Directory projectDir = Directory('${path.current}/$RELEASE_DIR');
    if (!projectDir.existsSync()) {
      projectDir.createSync();
    }
    final String arguments = await _buildDartDefines();
    await Future.wait(
      <Future<void>>[
        // If Android build is required.
        if (_shouldBuildAndroid)
          _buildAndroid(
            shell: shell,
            arguments: arguments,
            yamlMap: projectYamlMap,
          ),
        // If iOS build is required.
        if (_shouldBuildIOS)
          _buildIOS(
            shell: shell,
            arguments: arguments,
            yamlMap: projectYamlMap,
          ),
      ],
      eagerError: true,
    );
  }

  Future<String> _buildDartDefines() async {
    final YamlMap yaml = await obtainYamlFromPath(path.current);
    return '--dart-define=jjAppChannel=$_appChannel '
        '--dart-define=jjAppVersion=${yaml['version']} '
        '--dart-define=jjBuildTime=$_buildTime';
  }

  Future<void> _buildAndroid({
    required Shell shell,
    required String arguments,
    required YamlMap yamlMap,
  }) async {
    final AndroidBuildType buildType = <String, AndroidBuildType>{
      'apk': AndroidBuildType.apk(),
      'appbundle': AndroidBuildType.bundle(),
    }[_androidBuildType]!;
    log(
      '🚬　[$PROJECT_NAME] Building ${buildType.name} release for Android...',
      color: 33,
    );
    shell = shell.clone();
    await shell.run('flutter build ${buildType.name} --release $arguments');
    final String filename = await _filenameBuilder(yamlMap);
    final String targetDirectory = '${path.current}/$RELEASE_DIR/$filename';
    Directory(targetDirectory).createSync(recursive: true);
    final String newFilename = '$filename.${buildType.extension}';
    final File newFile = await File(
      '${path.current}/build/app/outputs/${buildType.outputPath}'
      '/app-release.${buildType.extension}',
    ).copy('$targetDirectory/$newFilename');
    final List<String> versions = '${yamlMap['version']}'.split('+');
    final File jsonFile = File('$targetDirectory/output.json');
    await jsonFile.writeAsString(
      const JsonEncoder.withIndent('    ').convert(<String, dynamic>{
        'channel': _appChannel,
        'filename': newFilename,
        'fileSize': await newFile.length(),
        'sha256': '${await (crypto.sha256.bind(newFile.openRead())).first}',
        'versionName': versions.first,
        'versionCode': int.parse(versions.last),
      }),
    );
    final ZipFileEncoder zipEncoder = ZipFileEncoder();
    zipEncoder.create('$targetDirectory/$filename.zip');
    await zipEncoder.addFile(newFile);
    await zipEncoder.addFile(jsonFile);
    zipEncoder.close();
    log('🤖　[$PROJECT_NAME] Android built.', color: 32);
  }

  Future<void> _buildIOS({
    required Shell shell,
    required String arguments,
    required YamlMap yamlMap,
  }) async {
    shell = shell.clone();
    shell = shell.pushd('ios');
    await shell.run('pod install');
    shell = shell.popd();

    // Start build process.
    log('🚬　[$PROJECT_NAME] Building release for iOS...', color: 33);
    await shell.run(
      'flutter build ipa --release '
      '--export-options-plist=../$_iOSMethod-ExportOptions.plist '
      '$arguments',
    );

    /// Move all built files to the target directory.
    final String filename = await _filenameBuilder(yamlMap);
    final String targetDirectory = '${path.current}/$RELEASE_DIR/$filename';
    Directory(targetDirectory).createSync(recursive: true);
    final List<FileSystemEntity> fileList = Directory(
      '${path.current}/build/ios/ipa',
    ).listSync();
    await Future.wait(
      fileList.map((FileSystemEntity e) async {
        final File file = e as File;
        await file.copy('$targetDirectory/${path.basename(file.path)}');
        await file.delete();
      }),
    );

    log('🍎　[$PROJECT_NAME] iOS built.', color: 32);
  }

  Future<String> _filenameBuilder(YamlMap yaml) async {
    final StringBuffer sb = StringBuffer();
    // 当前 App 的渠道
    if (_appChannel.isNotEmpty && _appChannel != 'inside') {
      sb.write('${_appChannel}_');
    }
    // 版本、时间、渠道
    sb.write('${PROJECT_NAME}_v${yaml['version']}_$_buildTime');
    return sb.toString();
  }

  void logConfigurations() {
    log('');
    log('   Configurations:', color: 37);
    log('   ${composeLogString('Build Time    :')} $_buildTime');
    log('   ${composeLogString('Platforms     :')} $_platforms');
    log('   ${composeLogString('Channel       :')} $_appChannel');
    if (_platforms.contains('android') || _platforms.contains('all')) {
      log(
        '   ${composeLogString('Android type  :')} $_androidBuildType',
        color: 37,
      );
    }
    if (_platforms.contains('ios') || _platforms.contains('all')) {
      log(
        '   ${composeLogString('iOS Method    :')} $_iOSMethod',
        color: 37,
      );
    }
    log('');
  }

  Future<void> _openReleaseDirectory() async {
    final Shell shell = Shell(
      verbose: argResultVerbose,
      commandVerbose: argResultVerbose,
      commentVerbose: argResultVerbose,
    );
    try {
      if (Platform.isMacOS) {
        await shell.run('open $RELEASE_DIR');
      } else if (Platform.isWindows) {
        await shell.run('explorer .\\$RELEASE_DIR');
      } else if (Platform.isLinux) {
        await shell.run('nautilus $RELEASE_DIR');
      }
    } catch (e, s) {
      if (e is ShellException && e.result?.exitCode == 1) {
        return;
      }
      log('Error when opening directory: $e\n$s');
    }
  }

  void stopProcess(int code) {
    if (stopwatch.elapsed > Duration.zero) {
      stopwatch.stop();
      log(
        "☕️　You've wasted ${stopwatch.elapsed} during this build.",
        color: 35,
      );
    }
  }

////////////////////////////////////////////////////////////////////////////////
////////////////////////////// Builder arguments ///////////////////////////////
////////////////////////////////////////////////////////////////////////////////

  late final String _buildTime;

  late final String _appChannel = validArgResults[KEY_APP_CHANNEL] as String;
  late final List<String> _platforms =
      validArgResults[KEY_WITH] as List<String>;

  late final bool _shouldBuildAndroid =
      _platforms.contains('all') || _platforms.contains('android');
  late final String _androidBuildType =
      validArgResults[KEY_ANDROID_BUILD_TYPE] as String;

  late final bool _shouldBuildIOS =
      _platforms.contains('all') || _platforms.contains('ios');

  late final String _iOSMethod = validArgResults[KEY_IOS_METHOD] as String;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// END Builder arguments /////////////////////////////
////////////////////////////////////////////////////////////////////////////////
}

extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

/// The fallback run.
void main(List<String> arguments) => ReleaseCommand().runStandalone(arguments);
