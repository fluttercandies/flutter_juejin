// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/material.dart';
@FFArgumentImport()
import 'package:juejin/exports.dart';

import 'home/articles.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: LazyIndexedStack(
              index: _currentIndex,
              children: const <Widget>[
                ArticlesPage(),
                PostsPage(),
                SizedBox.shrink(),
              ],
            ),
          ),
          BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _selectIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: '首页',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_fire_department_outlined),
                activeIcon: Icon(Icons.local_fire_department),
                label: '沸点',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.manage_accounts_outlined),
                activeIcon: Icon(Icons.manage_accounts),
                label: '我',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
