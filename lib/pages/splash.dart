// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:juejin/exports.dart';

@FFRoute(name: 'splash-page')
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
      ),
    );
    await Future.wait(<Future<void>>[
      DeviceUtil.initDeviceInfo(forceRefresh: true),
      PackageUtil.initInfo(),
      HttpUtil.init(),
      HiveUtil.init(),
    ]);
    await DeviceUtil.setHighestRefreshRate();
    await HttpUtil.fetch(FetchType.get, url: 'https://${Urls.domain}');

    ref.read(tokenProvider.notifier).restore();

    if (mounted) {
      navigator.pushReplacementNamed(Routes.homePage.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: JJLogo(heroTag: defaultLogoHeroTag, width: 90),
      ),
    );
  }
}
