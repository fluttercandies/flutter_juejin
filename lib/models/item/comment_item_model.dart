// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

part of '../data_model.dart';

@JsonSerializable()
class CommentItemModel extends DataModel {
  const CommentItemModel({
    required this.commentId,
    required this.commentInfo,
    required this.userInfo,
    required this.userInteract,
    required this.replyInfos,
    required this.isAuthor,
  });

  factory CommentItemModel.fromJson(Map<String, dynamic> json) =>
      _$CommentItemModelFromJson(json);

  final String commentId;
  final CommentInfo commentInfo;
  final UserInfoModel userInfo;
  final UserInteract userInteract;
  final List<Object> replyInfos;
  final bool isAuthor;

  @override
  Map<String, dynamic> toJson() => _$CommentItemModelToJson(this);

  @override
  List<Object?> get props => <Object?>[
        commentId,
        commentInfo,
        userInfo,
        userInteract,
        replyInfos,
        isAuthor,
      ];
}

@JsonSerializable()
class CommentInfo extends DataModel {
  const CommentInfo({
    required this.commentId,
    required this.userId,
    required this.itemId,
    required this.itemType,
    required this.commentContent,
    required this.commentPics,
    required this.commentStatus,
    required this.ctime,
    required this.commentReplies,
    required this.diggCount,
    required this.buryCount,
    required this.replyCount,
    required this.isDigg,
    required this.isBury,
    required this.level,
  });

  factory CommentInfo.fromJson(Map<String, dynamic> json) =>
      _$CommentInfoFromJson(json);

  final String commentId;
  final String userId;
  final String itemId;
  final int itemType;
  final String commentContent;
  final List<Object> commentPics;
  final int commentStatus;
  final int ctime;
  @JsonKey(name: 'commentReplys')
  final List<Object> commentReplies;
  final int diggCount;
  final int buryCount;
  final int replyCount;
  final bool isDigg;
  final bool isBury;
  final int level;

  String get createTime {
    return DateTime.now()
        .difference((ctime * 1000).toDateTimeInMilliseconds)
        .differenceString;
  }

  @override
  Map<String, dynamic> toJson() => _$CommentInfoToJson(this);

  @override
  List<Object?> get props => <Object?>[
        commentId,
        userId,
        itemId,
        itemType,
        commentContent,
        commentPics,
        commentStatus,
        ctime,
        commentReplies,
        diggCount,
        buryCount,
        replyCount,
        isDigg,
        isBury,
        level,
      ];
}
