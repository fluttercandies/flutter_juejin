// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

part of '../data_model.dart';

@JsonSerializable()
class AdvertiseItemModel extends DataModel {
  const AdvertiseItemModel({
    required this.id,
    required this.advertId,
    required this.userId,
    required this.itemId,
    required this.itemType,
    required this.platform,
    required this.layout,
    required this.position,
    required this.advertType,
    required this.stationType,
    required this.authorName,
    required this.authorId,
    required this.title,
    required this.brief,
    required this.url,
    required this.picture,
    required this.avatar,
    required this.startTime,
    required this.endTime,
    required this.ctime,
    required this.mtime,
    required this.saleCount,
    required this.salePrice,
    required this.discountRate,
    required this.diggCount,
    required this.commentCount,
    required this.topic,
    required this.topicId,
    required this.status,
    required this.itemUserInfo,
  });

  factory AdvertiseItemModel.fromJson(Map<String, dynamic> json) =>
      _$AdvertiseItemModelFromJson(json);

  final int id;
  final String advertId;
  final String userId;
  final String itemId;
  final int itemType;
  final int platform;
  final int layout;
  final int position;
  final int advertType;
  final int stationType;
  final String authorName;
  final String authorId;
  final String title;
  final String brief;
  final String url;
  final String picture;
  final String avatar;
  final String startTime;
  final String endTime;
  final String ctime;
  final String mtime;
  final int saleCount;
  final int salePrice;
  final int discountRate;
  final int diggCount;
  final int commentCount;
  final String topic;
  final String topicId;
  final int status;
  final UserInfoModel itemUserInfo;

  String createTimeString(BuildContext context) {
    return DateTime.now()
        .difference((int.parse(ctime) * 1000).toDateTimeInMilliseconds)
        .differenceString(context);
  }

  @override
  Map<String, dynamic> toJson() => _$AdvertiseItemModelToJson(this);

  @override
  List<Object?> get props => <Object>[
        id,
        advertId,
        userId,
        itemId,
        itemType,
        platform,
        layout,
        position,
        advertType,
        stationType,
        authorName,
        authorId,
        title,
        brief,
        url,
        picture,
        avatar,
        startTime,
        endTime,
        ctime,
        mtime,
        saleCount,
        salePrice,
        discountRate,
        diggCount,
        topic,
        topicId,
        status,
        itemUserInfo,
      ];
}
