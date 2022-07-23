// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:process_run/shell_run.dart';

import '../internals/command.dart';
import '../internals/utils.dart';

const String _constKey = 'FromJson(';
const String _prefixKey = r'_$';
const String _prefixKeyFreezed = r'_$_';

class ModelsCommand extends JJCommand {
  ModelsCommand() : super() {
    argParser
      ..addOption(
        'model',
        abbr: 'm',
        defaultsTo: 'lib/models/data_model.dart',
        help: 'Your model file path.',
      )
      ..addOption(
        'generated',
        abbr: 'g',
        defaultsTo: 'lib/models/data_model.g.dart',
        help: 'Your generated file path.',
      )
      ..addOption(
        'data',
        abbr: 'd',
        defaultsTo: 'lib/models/data_model.d.dart',
        help: 'Your data factories file path.',
      )
      ..addOption(
        'name',
        abbr: 'n',
        defaultsTo: 'dataModelFactories',
        help: 'Your factories name.',
      );
  }

  @override
  String get name => 'model';

  @override
  String get description => 'Manage model generations for projects';

  @override
  Future<void> runProcess() async {
    log('⏱　Building with build_runner...', color: 33);
    final Shell shell = obtainShell(verbose: argResultVerbose);
    await shell.run(
      'flutter pub run build_runner build --delete-conflicting-outputs',
    );
    log('🧮　Parsing generated files...', color: 33);
    generateFile = File(gPath);
    targetFile = File(tPath);
    if (!targetFile.existsSync()) {
      await targetFile.create(recursive: true);
    }
    log('🧪　Making model factories...', color: 33);
    final List<String> lines = await generateFile.readAsLines();
    await makeModel(mPath, factoriesName, lines);
    log(
      '🧾　Factories are generated at '
      '${targetFile.path.replaceAll(path.current, '')}.',
      color: 32,
    );
  }

  Future<void> makeModel(
    String generateFilePath,
    String factoriesName,
    List<String> lines,
  ) async {
    String modelContent = "part of '${generateFilePath.split('/').last}';\n\n";
    modelContent += 'final Map<Type, DataFactory> $factoriesName = '
        '<Type, DataFactory>{\n';
    modelContent += '  EmptyDataModel: EmptyDataModel.fromJson,\n';
    for (int i = 0; i < lines.length; i++) {
      final String line = lines[i];
      if (line.contains(_constKey) && line.contains(_prefixKey)) {
        final String className =
            line.split(' ')[0].replaceFirst(_prefixKeyFreezed, '');
        modelContent += '  $className: $className.fromJson,\n';
      }
    }
    modelContent += '};\n';
    await targetFile.writeAsString(modelContent);
  }

////////////////////////////////////////////////////////////////////////////////
////////////////////////////// Builder arguments ///////////////////////////////
////////////////////////////////////////////////////////////////////////////////

  late final File generateFile;
  late final File targetFile;

  late final String mPath = validArgResults['model'] as String;
  late final String gPath = validArgResults['generated'] as String;
  late final String tPath = validArgResults['data'] as String;
  late final String factoriesName = validArgResults['name'] as String;

////////////////////////////////////////////////////////////////////////////////
//////////////////////////// END Builder arguments /////////////////////////////
////////////////////////////////////////////////////////////////////////////////
}

/// The fallback run.
void main(List<String> arguments) => ModelsCommand().runStandalone(arguments);
