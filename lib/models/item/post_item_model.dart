// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

part of '../data_model.dart';

@JsonSerializable()
class PostItemModel extends DataModel {
  const PostItemModel({
    required this.msgId,
    required this.msgInfo,
    required this.authorUserInfo,
    required this.topic,
    required this.userInteract,
    required this.org,
    required this.theme,
    this.hotComment,
    required this.diggUser,
  });

  factory PostItemModel.fromJson(Map<String, dynamic> json) =>
      _$PostItemModelFromJson(json);

  final String msgId;
  @JsonKey(name: 'msg_Info')
  final PostInfo msgInfo;
  final UserInfoModel authorUserInfo;
  @JsonKey(readValue: _readTopic)
  final PostTopic? topic;
  final UserInteract userInteract;
  final UserOrg org;
  final PostTheme theme;
  @JsonKey(readValue: _readHotComment)
  final HotComment? hotComment;
  @JsonKey(defaultValue: [])
  final List<UserInfoModel> diggUser;

  static Map<String, dynamic>? _readHotComment(Map map, String key) {
    if (map[key]['comment_info'] != null) {
      return map[key];
    }
    return null;
  }

  static Map<String, dynamic>? _readTopic(Map map, String key) {
    final String? topicId = map[key]['topic_id'];
    if (topicId == null || topicId.isEmpty || topicId == '0') {
      return null;
    }
    return map[key];
  }

  @override
  Map<String, dynamic> toJson() => _$PostItemModelToJson(this);

  @override
  List<Object?> get props => <Object?>[
        msgId,
        msgInfo,
        authorUserInfo,
        topic,
        userInteract,
        org,
        theme,
        hotComment,
        diggUser,
      ];
}

@JsonSerializable()
class PostInfo extends DataModel {
  const PostInfo({
    required this.id,
    required this.msgId,
    required this.userId,
    required this.topicId,
    required this.content,
    required this.picList,
    required this.url,
    required this.urlTitle,
    required this.urlPic,
    required this.verifyStatus,
    required this.status,
    required this.ctime,
    required this.mtime,
    required this.rtime,
    required this.commentCount,
    required this.diggCount,
    required this.hotIndex,
    required this.rankIndex,
    required this.commentScore,
    required this.isAdvertRecommend,
    required this.auditStatus,
    required this.themeId,
  });

  factory PostInfo.fromJson(Map<String, dynamic> json) =>
      _$PostInfoFromJson(json);

  final int id;
  final String msgId;
  final String userId;
  final String topicId;
  final String content;
  @JsonKey(defaultValue: [])
  final List<String> picList;
  final String url;
  final String urlTitle;
  final String urlPic;
  final int verifyStatus;
  final int status;
  final String ctime;
  final String mtime;
  final String rtime;
  final int commentCount;
  final int diggCount;
  final double hotIndex;
  final double rankIndex;
  final int commentScore;
  final bool isAdvertRecommend;
  final int auditStatus;
  final String themeId;

  DateTime get createTime {
    return ((int.tryParse(ctime) ?? 0) * 1000).toDateTimeInMilliseconds;
  }

  @override
  Map<String, dynamic> toJson() => _$PostInfoToJson(this);

  @override
  List<Object?> get props => <Object?>[
        id,
        msgId,
        userId,
        topicId,
        content,
        picList,
        url,
        urlTitle,
        urlPic,
        verifyStatus,
        status,
        ctime,
        mtime,
        rtime,
        commentCount,
        diggCount,
        hotIndex,
        rankIndex,
        commentScore,
        isAdvertRecommend,
        auditStatus,
        themeId,
      ];
}

@JsonSerializable()
class PostTopic extends DataModel {
  const PostTopic({
    required this.topicId,
    required this.title,
    required this.description,
    required this.icon,
    required this.msgCount,
    required this.followerCount,
    required this.attenderCount,
    required this.notice,
    required this.adminIds,
    required this.themeIds,
    required this.categoryId,
    required this.isRec,
    required this.recRank,
  });

  factory PostTopic.fromJson(Map<String, dynamic> json) =>
      _$PostTopicFromJson(json);

  final String topicId;
  final String title;
  final String description;
  final String icon;
  final int msgCount;
  final int followerCount;
  final int attenderCount;
  final String notice;
  @JsonKey(defaultValue: [])
  final List<String> adminIds;
  @JsonKey(defaultValue: [])
  final List<String> themeIds;
  @JsonKey(name: 'cate_id')
  final String categoryId;
  final bool isRec;
  final int recRank;

  @override
  Map<String, dynamic> toJson() => _$PostTopicToJson(this);

  @override
  List<Object?> get props => <Object?>[
        topicId,
        title,
        description,
        icon,
        msgCount,
        followerCount,
        attenderCount,
        notice,
        adminIds,
        themeIds,
        categoryId,
        isRec,
        recRank,
      ];
}

@JsonSerializable()
class PostTheme extends DataModel {
  const PostTheme({
    required this.themeId,
    required this.name,
    required this.cover,
    required this.brief,
    required this.isLottery,
    required this.isRec,
    required this.recRank,
    required this.topicIds,
    required this.hot,
    required this.viewCount,
    required this.userCount,
    required this.status,
    required this.ctime,
    required this.mtime,
    required this.lotteryBeginTime,
    required this.lotteryEndTime,
  });

  factory PostTheme.fromJson(Map<String, dynamic> json) =>
      _$PostThemeFromJson(json);

  final String themeId;
  final String name;
  final String cover;
  final String brief;
  final bool isLottery;
  final bool isRec;
  final int recRank;
  @JsonKey(defaultValue: [])
  final List<String> topicIds;
  final int hot;
  @JsonKey(name: 'view_cnt')
  final int viewCount;
  @JsonKey(name: 'user_cnt')
  final int userCount;
  final int status;
  final int ctime;
  final int mtime;
  final int lotteryBeginTime;
  final int lotteryEndTime;

  @override
  Map<String, dynamic> toJson() => _$PostThemeToJson(this);

  @override
  List<Object?> get props => <Object>[
        themeId,
        name,
        cover,
        brief,
        isLottery,
        isRec,
        recRank,
        topicIds,
        hot,
        viewCount,
        userCount,
        status,
        ctime,
        mtime,
        lotteryBeginTime,
        lotteryEndTime,
      ];
}

@JsonSerializable()
class HotComment extends DataModel {
  const HotComment({
    required this.commentId,
    required this.commentInfo,
    this.userInfo,
    required this.userInteract,
    required this.replyInfos,
    required this.isAuthor,
  });

  factory HotComment.fromJson(Map<String, dynamic> json) =>
      _$HotCommentFromJson(json);

  final String commentId;
  final CommentInfo commentInfo;
  @JsonKey(readValue: _readUserInfo)
  final UserInfoModel? userInfo;
  final UserInteract userInteract;
  @JsonKey(defaultValue: [])
  final List<Object> replyInfos;
  final bool isAuthor;

  static Map<String, dynamic>? _readUserInfo(Map map, String key) {
    final String? id = map[key]['user_id'];
    if (id == null || id.isEmpty || id == '0') {
      return null;
    }
    return map[key];
  }

  @override
  Map<String, dynamic> toJson() => _$HotCommentToJson(this);

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
