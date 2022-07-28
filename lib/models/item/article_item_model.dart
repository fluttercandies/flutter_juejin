// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

part of '../data_model.dart';

@JsonSerializable()
class ArticleItemModel extends DataModel {
  const ArticleItemModel({
    required this.articleId,
    required this.articleInfo,
    required this.authorUserInfo,
    required this.category,
    required this.tags,
    required this.userInteract,
    required this.org,
    required this.reqId,
    required this.status,
    this.authorInteract,
    required this.extra,
  });

  factory ArticleItemModel.fromJson(Map<String, dynamic> json) =>
      _$ArticleItemModelFromJson(json);

  final String articleId;
  final ArticleInfo articleInfo;
  final UserInfoModel authorUserInfo;
  final Category category;
  @JsonKey(defaultValue: [])
  final List<Tag> tags;
  final UserInteract userInteract;
  final UserOrg org;
  final String reqId;
  final ArticleStatus status;
  final Object? authorInteract;
  final ArticleExtra extra;

  @override
  Map<String, dynamic> toJson() => _$ArticleItemModelToJson(this);

  @override
  List<Object?> get props => <Object?>[
        articleId,
        articleInfo,
        authorUserInfo,
        category,
        tags,
        userInteract,
        org,
        reqId,
        status,
        authorInteract,
        extra,
      ];
}

@JsonSerializable()
class ArticleInfo extends DataModel {
  const ArticleInfo({
    required this.articleId,
    required this.userId,
    required this.categoryId,
    required this.tagIds,
    required this.visibleLevel,
    required this.linkUrl,
    required this.coverImage,
    required this.isGfw,
    required this.title,
    required this.briefContent,
    required this.isEnglish,
    required this.isOriginal,
    required this.userIndex,
    required this.originalType,
    required this.originalAuthor,
    required this.content,
    required this.ctime,
    required this.mtime,
    required this.rtime,
    required this.draftId,
    required this.viewCount,
    required this.collectCount,
    required this.diggCount,
    required this.commentCount,
    required this.hotIndex,
    required this.isHot,
    required this.rankIndex,
    required this.status,
    required this.verifyStatus,
    required this.auditStatus,
    required this.markContent,
    required this.displayCount,
  });

  factory ArticleInfo.fromJson(Map<String, dynamic> json) =>
      _$ArticleInfoFromJson(json);

  final String articleId;
  final String userId;
  final String categoryId;
  @JsonKey(defaultValue: [])
  final List<int> tagIds;
  final int visibleLevel;
  final String linkUrl;
  final String coverImage;
  final int isGfw;
  final String title;
  final String briefContent;
  final int isEnglish;
  final int isOriginal;
  final double userIndex;
  final int originalType;
  final String originalAuthor;
  final String content;
  final String ctime;
  final String mtime;
  final String rtime;
  final String draftId;
  final int viewCount;
  final int collectCount;
  final int diggCount;
  final int commentCount;
  final int hotIndex;
  final int isHot;
  final double rankIndex;
  final int status;
  final int verifyStatus;
  final int auditStatus;
  final String markContent;
  final int displayCount;

  DateTime get createTime {
    return ((int.tryParse(ctime) ?? 0) * 1000).toDateTimeInMilliseconds;
  }

  String slicedCoverImage({num width = 330, String extension = 'jpg'}) {
    width -= (width % 3);
    width = width.toInt();
    return coverImage.replaceAll(
      'watermark.image',
      'no-mark:$width:$width:$width:${width ~/ 3 * 2}.$extension',
    );
  }

  @override
  Map<String, dynamic> toJson() => _$ArticleInfoToJson(this);

  @override
  List<Object?> get props => <Object>[
        articleId,
        userId,
        categoryId,
        tagIds,
        visibleLevel,
        linkUrl,
        coverImage,
        isGfw,
        title,
        briefContent,
        isEnglish,
        isOriginal,
        userIndex,
        originalType,
        originalAuthor,
        content,
        ctime,
        mtime,
        rtime,
        draftId,
        viewCount,
        collectCount,
        diggCount,
        commentCount,
        hotIndex,
        isHot,
        rankIndex,
        status,
        verifyStatus,
        auditStatus,
        markContent,
        displayCount,
      ];
}

@JsonSerializable()
class ArticleStatus extends DataModel {
  const ArticleStatus({
    required this.pushStatus,
  });

  factory ArticleStatus.fromJson(Map<String, dynamic> json) =>
      _$ArticleStatusFromJson(json);

  final int pushStatus;

  @override
  Map<String, dynamic> toJson() => _$ArticleStatusToJson(this);

  @override
  List<Object?> get props => <Object>[pushStatus];
}

@JsonSerializable()
class ArticleExtra extends DataModel {
  const ArticleExtra({
    required this.boostType,
  });

  factory ArticleExtra.fromJson(Map<String, dynamic> json) =>
      _$ArticleExtraFromJson(json);

  final String boostType;

  @override
  Map<String, dynamic> toJson() => _$ArticleExtraToJson(this);

  @override
  List<Object?> get props => <Object>[boostType];
}

@JsonSerializable()
class Category extends DataModel {
  const Category({
    required this.categoryId,
    required this.categoryName,
    required this.categoryUrl,
    required this.rank,
    required this.backGround,
    required this.icon,
    required this.ctime,
    required this.mtime,
    required this.showType,
    required this.itemType,
    required this.promoteTagCap,
    required this.promotePriority,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  final String categoryId;
  final String categoryName;
  final String categoryUrl;
  final int rank;
  final String backGround;
  final String icon;
  final int ctime;
  final int mtime;
  final int showType;
  final int itemType;
  final int promoteTagCap;
  final int promotePriority;

  @override
  Map<String, dynamic> toJson() => _$CategoryToJson(this);

  @override
  List<Object?> get props => <Object>[
        categoryId,
        categoryName,
        categoryUrl,
        rank,
        backGround,
        icon,
        ctime,
        mtime,
        showType,
        itemType,
        promoteTagCap,
        promotePriority,
      ];
}

@JsonSerializable()
class Tag extends DataModel {
  const Tag({
    required this.id,
    required this.tagId,
    required this.tagName,
    required this.color,
    required this.icon,
    required this.backGround,
    required this.showNavi,
    required this.ctime,
    required this.mtime,
    required this.idType,
    required this.tagAlias,
    required this.postArticleCount,
    required this.concernUserCount,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  final int id;
  final String tagId;
  final String tagName;
  final String color;
  final String icon;
  final String backGround;
  final int showNavi;
  final int ctime;
  final int mtime;
  final int idType;
  final String tagAlias;
  final int postArticleCount;
  final int concernUserCount;

  @override
  Map<String, dynamic> toJson() => _$TagToJson(this);

  @override
  List<Object?> get props => <Object>[
        id,
        tagId,
        tagName,
        color,
        icon,
        backGround,
        showNavi,
        ctime,
        mtime,
        idType,
        tagAlias,
        postArticleCount,
        concernUserCount,
      ];
}
