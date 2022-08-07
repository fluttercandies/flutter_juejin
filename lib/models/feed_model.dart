// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

part of 'data_model.dart';

@JsonSerializable()
class FeedModel extends DataModel {
  const FeedModel({
    required this.itemType,
    required this.itemInfo,
  });

  factory FeedModel.fromJson(Map<String, dynamic> json) =>
      _$FeedModelFromJson(json);

  @JsonKey(fromJson: _feedItemTypeFromJson, toJson: _feedItemTypeToJson)
  final FeedItemType itemType;
  @JsonKey(readValue: _handleItemInfoType)
  final Object itemInfo;

  static FeedItemType _feedItemTypeFromJson(int value) {
    return FeedItemType.fromInt(value);
  }

  static int _feedItemTypeToJson(FeedItemType type) => type.type;

  static Object _handleItemInfoType(Map<dynamic, dynamic> json, String key) {
    final FeedItemType itemType = FeedItemType.fromInt(json['item_type']);
    final Json itemInfo = json[key]!;
    switch (itemType) {
      case FeedItemType.article:
        return ArticleItemModel.fromJson(itemInfo);
      case FeedItemType.advertisement:
        return AdvertiseItemModel.fromJson(itemInfo);
      default:
        throw UnsupportedError('Unsupported type $itemType: $itemInfo');
    }
  }

  @override
  Map<String, dynamic> toJson() => _$FeedModelToJson(this);

  @override
  List<Object?> get props => <Object>[itemType, itemInfo];
}

enum FeedItemType {
  article(2),
  pin(4),
  advertisement(14);

  const FeedItemType(this.type);

  factory FeedItemType.fromInt(int value) {
    return values.singleWhere((FeedItemType e) => e.type == value);
  }

  final int type;
}
