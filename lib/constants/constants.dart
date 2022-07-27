// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'dart:convert';

const int appId = 2606;

const JsonEncoder globalJsonEncoder = JsonEncoder.withIndent('  ');

const String urlScheme = r'http(s?)://';
final RegExp urlRegExp = RegExp(urlScheme);
