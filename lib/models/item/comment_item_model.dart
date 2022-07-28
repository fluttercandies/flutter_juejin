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
  @JsonKey(defaultValue: [])
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
  @JsonKey(defaultValue: [])
  final List<Object> commentPics;
  final int commentStatus;
  final int ctime;
  @JsonKey(defaultValue: [], name: 'commentReplys')
  final List<CommentReply> commentReplies;
  final int diggCount;
  final int buryCount;
  final int replyCount;
  final bool isDigg;
  final bool isBury;
  final int level;

  String createTimeString(BuildContext context) {
    return DateTime.now()
        .difference((ctime * 1000).toDateTimeInMilliseconds)
        .differenceString(context);
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

@JsonSerializable()
class CommentReply extends DataModel {
  const CommentReply({
    required this.replyId,
    required this.replyCommentId,
    required this.userId,
    required this.replyToReplyId,
    required this.replyToUserId,
    required this.itemId,
    required this.itemType,
    required this.replyContent,
    required this.replyPics,
    required this.replyStatus,
    required this.ctime,
    required this.diggCount,
    required this.buryCount,
  });

  factory CommentReply.fromJson(Map<String, dynamic> json) =>
      _$CommentReplyFromJson(json);

  final String replyId;
  final String replyCommentId;
  final String userId;
  final String replyToReplyId;
  final String replyToUserId;
  final String itemId;
  final int itemType;
  final String replyContent;
  @JsonKey(defaultValue: [])
  final List<String> replyPics;
  final int replyStatus;
  final int ctime;
  final int diggCount;
  @JsonKey(name: 'burry_count')
  final int buryCount;

  @override
  Map<String, dynamic> toJson() => _$CommentReplyToJson(this);

  @override
  List<Object?> get props => <Object>[
        replyId,
        replyCommentId,
        userId,
        replyToReplyId,
        replyToUserId,
        itemId,
        itemType,
        replyContent,
        replyPics,
        replyStatus,
        ctime,
        diggCount,
      ];
}
