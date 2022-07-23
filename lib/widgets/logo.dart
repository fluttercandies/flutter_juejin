// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constants/resources.dart';

const String defaultLogoHeroTag = 'jj-hero-default';

class JJLogo extends StatelessWidget {
  const JJLogo({
    Key? key,
    this.width,
    this.height,
    this.heroTag,
    this.withText = false,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? heroTag;
  final bool withText;

  @override
  Widget build(BuildContext context) {
    final Widget body = SvgPicture.asset(
      withText ? R.ASSETS_BRAND_WITH_TEXT_SVG : R.ASSETS_BRAND_SVG,
      width: width,
      height: height,
    );
    if (heroTag != null) {
      return Hero(tag: heroTag!, child: body);
    }
    return body;
  }
}
