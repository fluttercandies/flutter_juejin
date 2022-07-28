// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';
@FFArgumentImport()
import 'package:juejin/exports.dart';

import 'home/articles.dart';
import 'home/mine.dart';
import 'home/posts.dart';

@FFRoute(name: 'home-page')
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  void _selectIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildBody(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeBottom: true,
      child: LazyIndexedStack(
        index: _currentIndex,
        children: const <Widget>[ArticlesPage(), PostsPage(), MinePage()],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _selectIndex,
      items:  <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          activeIcon:const  Icon(Icons.home),
          label: context.l10n.tabHome,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.local_fire_department_outlined),
          activeIcon:const  Icon(Icons.local_fire_department),
          label: context.l10n.tabHot,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.manage_accounts_outlined),
          activeIcon:const  Icon(Icons.manage_accounts),
          label: context.l10n.tabMy,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(child: _buildBody(context)),
          _buildBottomNavigationBar(context),
        ],
      ),
    );
  }
}
