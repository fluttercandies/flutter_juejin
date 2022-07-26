// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:extended_text/extended_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../constants/styles.dart';

class TopicText extends RegExpSpecialText {
  /// [7118934098294341672#理财经验分享#]
  ///
  /// - Match numeric ID at start.
  /// - Match paired #.
  /// - Match not empty content between pairing #.
  @override
  final RegExp regExp = RegExp(r'(\[(\d+)#)(\S+|(\S([^(#\])]+?)\S))(#\])');

  @override
  InlineSpan finishText(
    int start,
    Match match, {
    TextStyle? textStyle,
    SpecialTextGestureTapCallback? onTap,
  }) {
    final String actualText = toString();
    return SpecialTextSpan(
      text: '#${match.group(3)}#',
      actualText: actualText,
      start: start,
      style: (textStyle ?? const TextStyle()).copyWith(
        color: themeColorLight,
      ),
      recognizer: onTap != null
          ? (TapGestureRecognizer()..onTap = () => onTap(actualText))
          : null,
    );
  }
}

class JJRegExpSpecialTextSpanBuilder extends RegExpSpecialTextSpanBuilder {
  @override
  List<RegExpSpecialText> get regExps {
    return <RegExpSpecialText>[TopicText()];
  }
}
