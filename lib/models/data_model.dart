// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import '../constants/constants.dart';
import '../extensions/duration_extension.dart';
import '../extensions/num_extension.dart';
import '../utils/log_util.dart';

part 'data_model.d.dart';

part 'data_model.g.dart';

part 'item/advertise_item_model.dart';

part 'item/article_item_model.dart';

part 'item/comment_item_model.dart';

part 'feed_model.dart';

part 'user_model.dart';

typedef Json = Map<String, dynamic>;
typedef JsonList = List<Json>;
typedef QueryMap = Map<String, String>;

abstract class DataModel extends Equatable {
  const DataModel();

  Json toJson();

  @override
  String toString() => globalJsonEncoder.convert(toJson());
}

typedef DataFactory<T extends DataModel> = T Function(Json json);

T makeModel<T extends DataModel>(Json json) {
  if (!dataModelFactories.containsKey(T)) {
    LogUtil.e(
      "You're inflating an unregistered type: $T\n"
      "Please check if it's registered in `dataModelFactories`.",
      tag: '🏭 DataModel',
    );
    throw ModelNotRegisteredError<T>();
  }
  try {
    return dataModelFactories[T]!(json) as T;
  } catch (e, s) {
    LogUtil.e(
      'Error when making model with $T type: $e\n'
      '${json.containsKey('id') ? 'Model contains id: ${json['id']}\n' : ''}'
      'The raw data which make this error is: '
      '${globalJsonEncoder.convert(json)}',
      stackTrace: s,
      tag: '🏭 DataModel',
    );
    throw ModelMakeError<T>(json, e);
  }
}

class EmptyDataModel extends DataModel {
  const EmptyDataModel();

  factory EmptyDataModel.fromJson(dynamic _) => const EmptyDataModel();

  @override
  Json toJson() => const <String, dynamic>{};

  @override
  List<Object?> get props => <Object?>[null];
}

class ModelError extends TypeError {}

class ModelMakeError<T extends DataModel> extends ModelError {
  ModelMakeError(this.json, this.error);

  final Json json;
  final Object error;
}

class ModelNotRegisteredError<T extends DataModel> extends ModelError {
  ModelNotRegisteredError();

  @override
  String toString() {
    return "You're inflating an unregistered type: $T\n"
        "Please check if it's registered in `dataModelFactories`.";
  }
}
