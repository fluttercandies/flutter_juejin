// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:process_run/shell.dart';
import 'package:yaml/yaml.dart';

Future<YamlMap> obtainYamlFromPath(String path) async {
  return loadYaml(
    await File('$path/pubspec.yaml').readAsString(),
  ) as YamlMap;
}

String composeLogString(Object v, {int background = 1, int color = 31}) {
  return '\x1B[$background;${color}m$v\x1B[0m';
}

/// [background] 背景色
///  * 40 - 白
///  * 41 - 红
///  * 42 - 绿
///  * 43 - 黄
///  * 44 - 橙
///  * 45 - 紫
///  * 46 - 靛
///  * 47 - 灰黑
///
/// [color] 文字颜色
///  * 31 - 红
///  * 32 - 绿
///  * 33 - 黄
///  * 34 - 蓝
///  * 35 - 紫
///  * 36 - 靛
///  * 37 - 灰黑
void log(Object content, {int background = 1, int color = 31}) {
  // ignore: avoid_print
  print(composeLogString(content, background: background, color: color));
}

void catchingError(Object e, String executionName) {
  log('$e');
  log("\nRun '$executionName -h' for available commands and options.");
  exit(-1);
}

Future<List<ProcessResult>> pullFromDirectory(
  String directory, {
  bool verbose = false,
}) {
  log(
    '📥　[git] Pulling ${directory.split('/').last}...',
    color: 34,
  );
  return Shell(
    workingDirectory: directory,
    verbose: verbose,
    commandVerbose: verbose,
    commentVerbose: verbose,
  ).run('git pull');
}

Shell obtainShell({bool verbose = false}) {
  return Shell(
    workingDirectory: path.current,
    verbose: verbose,
    commandVerbose: verbose,
    commentVerbose: verbose,
  );
}

extension FileExtension on File {
  Future<String> writeFirstLineStartsWith(
    String startsWith,
    String content,
  ) async {
    final List<String> lines = await readAsLines();
    int versionLine = 0;
    for (final String line in lines) {
      if (line.startsWith(startsWith)) {
        break;
      }
      versionLine++;
    }
    lines[versionLine] = content;
    await writeAsString(lines.join('\n'));
    return content;
  }
}
