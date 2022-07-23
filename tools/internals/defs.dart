// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

class AndroidBuildType {
  const AndroidBuildType({
    required this.name,
    required this.outputPath,
    required this.extension,
  });

  factory AndroidBuildType.apk() {
    return const AndroidBuildType(
      name: 'apk',
      outputPath: 'flutter-apk',
      extension: 'apk',
    );
  }

  factory AndroidBuildType.bundle() {
    return const AndroidBuildType(
      name: 'appbundle',
      outputPath: 'bundle/release',
      extension: 'aab',
    );
  }

  final String name;
  final String outputPath;
  final String? extension;
}
