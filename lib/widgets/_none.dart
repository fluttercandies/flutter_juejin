// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:flutter/widgets.dart';

const None none = None();

class None extends Widget {
  const None({super.key});

  @override
  Element createElement() => _NoneElement(this);
}

class _NoneElement extends Element {
  _NoneElement(super.widget);

  @override
  void mount(Element? parent, dynamic newSlot) {
    assert(
      parent is! MultiChildRenderObjectElement,
      'You are using None under a MultiChildRenderObjectElement. '
      'Typically means the None is not needed or is being used improperly. '
      "Make sure it can't be replaced with an inline conditional or "
      'omission of the target widget from a list.',
    );
    super.mount(parent, newSlot);
  }

  @override
  bool get debugDoingBuild => false;

  @override
  void performRebuild() {
    super.performRebuild();
  }
}
