// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';

import '../constants/themes.dart';
import '../extensions/build_context_extension.dart';
import '../utils/log_util.dart';
import 'logo.dart';

class JJErrorWidget extends StatelessWidget {
  const JJErrorWidget._(this.details);

  final FlutterErrorDetails details;

  static void takeOver() {
    ErrorWidget.builder = (FlutterErrorDetails d) {
      LogUtil.e(
        'Error has been delivered to the ErrorWidget: ${d.exception}',
        stackTrace: d.stack,
      );
      return JJErrorWidget._(d);
    };
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(13),
          color: Color.lerp(
            Theme.of(context).canvasColor,
            themeColorLight,
            0.1,
          ),
        ),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const FractionallySizedBox(widthFactor: 0.25, child: JJLogo()),
              const SizedBox(height: 20),
              Text(
                context.l10n.exceptionErrorWidget,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              Text(
                details.exception.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                details.stack.toString(),
                style: const TextStyle(fontSize: 13),
                maxLines: 10,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
