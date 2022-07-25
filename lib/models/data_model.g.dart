// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdvertiseItemModel _$AdvertiseItemModelFromJson(Map<String, dynamic> json) =>
    AdvertiseItemModel(
      id: json['id'] as int,
      advertId: json['advert_id'] as String,
      userId: json['user_id'] as String,
      itemId: json['item_id'] as String,
      itemType: json['item_type'] as int,
      platform: json['platform'] as int,
      layout: json['layout'] as int,
      position: json['position'] as int,
      advertType: json['advert_type'] as int,
      stationType: json['station_type'] as int,
      authorName: json['author_name'] as String,
      authorId: json['author_id'] as int,
      title: json['title'] as String,
      brief: json['brief'] as String,
      url: json['url'] as String,
      picture: json['picture'] as String,
      avatar: json['avatar'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      ctime: json['ctime'] as String,
      mtime: json['mtime'] as String,
      saleCount: json['sale_count'] as int,
      salePrice: json['sale_price'] as int,
      discountRate: json['discount_rate'] as int,
      diggCount: json['digg_count'] as int,
      commentCount: json['comment_count'] as int,
      topic: json['topic'] as String,
      topicId: json['topic_id'] as String,
      status: json['status'] as int,
      itemUserInfo: UserInfoModel.fromJson(
          json['item_user_info'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AdvertiseItemModelToJson(AdvertiseItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'advert_id': instance.advertId,
      'user_id': instance.userId,
      'item_id': instance.itemId,
      'item_type': instance.itemType,
      'platform': instance.platform,
      'layout': instance.layout,
      'position': instance.position,
      'advert_type': instance.advertType,
      'station_type': instance.stationType,
      'author_name': instance.authorName,
      'author_id': instance.authorId,
      'title': instance.title,
      'brief': instance.brief,
      'url': instance.url,
      'picture': instance.picture,
      'avatar': instance.avatar,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'ctime': instance.ctime,
      'mtime': instance.mtime,
      'sale_count': instance.saleCount,
      'sale_price': instance.salePrice,
      'discount_rate': instance.discountRate,
      'digg_count': instance.diggCount,
      'comment_count': instance.commentCount,
      'topic': instance.topic,
      'topic_id': instance.topicId,
      'status': instance.status,
      'item_user_info': instance.itemUserInfo.toJson(),
    };

ArticleItemModel _$ArticleItemModelFromJson(Map<String, dynamic> json) =>
    ArticleItemModel(
      articleId: json['article_id'] as String,
      articleInfo:
          ArticleInfo.fromJson(json['article_info'] as Map<String, dynamic>),
      authorUserInfo: UserInfoModel.fromJson(
          json['author_user_info'] as Map<String, dynamic>),
      category: Category.fromJson(json['category'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>)
          .map((e) => Tag.fromJson(e as Map<String, dynamic>))
          .toList(),
      userInteract:
          UserInteract.fromJson(json['user_interact'] as Map<String, dynamic>),
      org: UserOrg.fromJson(json['org'] as Map<String, dynamic>),
      reqId: json['req_id'] as String,
      status: ArticleStatus.fromJson(json['status'] as Map<String, dynamic>),
      authorInteract: json['author_interact'],
      extra: ArticleExtra.fromJson(json['extra'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ArticleItemModelToJson(ArticleItemModel instance) =>
    <String, dynamic>{
      'article_id': instance.articleId,
      'article_info': instance.articleInfo.toJson(),
      'author_user_info': instance.authorUserInfo.toJson(),
      'category': instance.category.toJson(),
      'tags': instance.tags.map((e) => e.toJson()).toList(),
      'user_interact': instance.userInteract.toJson(),
      'org': instance.org.toJson(),
      'req_id': instance.reqId,
      'status': instance.status.toJson(),
      'author_interact': instance.authorInteract,
      'extra': instance.extra.toJson(),
    };

ArticleInfo _$ArticleInfoFromJson(Map<String, dynamic> json) => ArticleInfo(
      articleId: json['article_id'] as String,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String,
      tagIds: (json['tag_ids'] as List<dynamic>).map((e) => e as int).toList(),
      visibleLevel: json['visible_level'] as int,
      linkUrl: json['link_url'] as String,
      coverImage: json['cover_image'] as String,
      isGfw: json['is_gfw'] as int,
      title: json['title'] as String,
      briefContent: json['brief_content'] as String,
      isEnglish: json['is_english'] as int,
      isOriginal: json['is_original'] as int,
      userIndex: (json['user_index'] as num).toDouble(),
      originalType: json['original_type'] as int,
      originalAuthor: json['original_author'] as String,
      content: json['content'] as String,
      ctime: json['ctime'] as String,
      mtime: json['mtime'] as String,
      rtime: json['rtime'] as String,
      draftId: json['draft_id'] as String,
      viewCount: json['view_count'] as int,
      collectCount: json['collect_count'] as int,
      diggCount: json['digg_count'] as int,
      commentCount: json['comment_count'] as int,
      hotIndex: json['hot_index'] as int,
      isHot: json['is_hot'] as int,
      rankIndex: (json['rank_index'] as num).toDouble(),
      status: json['status'] as int,
      verifyStatus: json['verify_status'] as int,
      auditStatus: json['audit_status'] as int,
      markContent: json['mark_content'] as String,
      displayCount: json['display_count'] as int,
    );

Map<String, dynamic> _$ArticleInfoToJson(ArticleInfo instance) =>
    <String, dynamic>{
      'article_id': instance.articleId,
      'user_id': instance.userId,
      'category_id': instance.categoryId,
      'tag_ids': instance.tagIds,
      'visible_level': instance.visibleLevel,
      'link_url': instance.linkUrl,
      'cover_image': instance.coverImage,
      'is_gfw': instance.isGfw,
      'title': instance.title,
      'brief_content': instance.briefContent,
      'is_english': instance.isEnglish,
      'is_original': instance.isOriginal,
      'user_index': instance.userIndex,
      'original_type': instance.originalType,
      'original_author': instance.originalAuthor,
      'content': instance.content,
      'ctime': instance.ctime,
      'mtime': instance.mtime,
      'rtime': instance.rtime,
      'draft_id': instance.draftId,
      'view_count': instance.viewCount,
      'collect_count': instance.collectCount,
      'digg_count': instance.diggCount,
      'comment_count': instance.commentCount,
      'hot_index': instance.hotIndex,
      'is_hot': instance.isHot,
      'rank_index': instance.rankIndex,
      'status': instance.status,
      'verify_status': instance.verifyStatus,
      'audit_status': instance.auditStatus,
      'mark_content': instance.markContent,
      'display_count': instance.displayCount,
    };

ArticleStatus _$ArticleStatusFromJson(Map<String, dynamic> json) =>
    ArticleStatus(
      pushStatus: json['push_status'] as int,
    );

Map<String, dynamic> _$ArticleStatusToJson(ArticleStatus instance) =>
    <String, dynamic>{
      'push_status': instance.pushStatus,
    };

ArticleExtra _$ArticleExtraFromJson(Map<String, dynamic> json) => ArticleExtra(
      boostType: json['boost_type'] as String,
    );

Map<String, dynamic> _$ArticleExtraToJson(ArticleExtra instance) =>
    <String, dynamic>{
      'boost_type': instance.boostType,
    };

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      categoryId: json['category_id'] as String,
      categoryName: json['category_name'] as String,
      categoryUrl: json['category_url'] as String,
      rank: json['rank'] as int,
      backGround: json['back_ground'] as String,
      icon: json['icon'] as String,
      ctime: json['ctime'] as int,
      mtime: json['mtime'] as int,
      showType: json['show_type'] as int,
      itemType: json['item_type'] as int,
      promoteTagCap: json['promote_tag_cap'] as int,
      promotePriority: json['promote_priority'] as int,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'category_id': instance.categoryId,
      'category_name': instance.categoryName,
      'category_url': instance.categoryUrl,
      'rank': instance.rank,
      'back_ground': instance.backGround,
      'icon': instance.icon,
      'ctime': instance.ctime,
      'mtime': instance.mtime,
      'show_type': instance.showType,
      'item_type': instance.itemType,
      'promote_tag_cap': instance.promoteTagCap,
      'promote_priority': instance.promotePriority,
    };

Tag _$TagFromJson(Map<String, dynamic> json) => Tag(
      id: json['id'] as int,
      tagId: json['tag_id'] as String,
      tagName: json['tag_name'] as String,
      color: json['color'] as String,
      icon: json['icon'] as String,
      backGround: json['back_ground'] as String,
      showNavi: json['show_navi'] as int,
      ctime: json['ctime'] as int,
      mtime: json['mtime'] as int,
      idType: json['id_type'] as int,
      tagAlias: json['tag_alias'] as String,
      postArticleCount: json['post_article_count'] as int,
      concernUserCount: json['concern_user_count'] as int,
    );

Map<String, dynamic> _$TagToJson(Tag instance) => <String, dynamic>{
      'id': instance.id,
      'tag_id': instance.tagId,
      'tag_name': instance.tagName,
      'color': instance.color,
      'icon': instance.icon,
      'back_ground': instance.backGround,
      'show_navi': instance.showNavi,
      'ctime': instance.ctime,
      'mtime': instance.mtime,
      'id_type': instance.idType,
      'tag_alias': instance.tagAlias,
      'post_article_count': instance.postArticleCount,
      'concern_user_count': instance.concernUserCount,
    };

CommentItemModel _$CommentItemModelFromJson(Map<String, dynamic> json) =>
    CommentItemModel(
      commentId: json['comment_id'] as String,
      commentInfo:
          CommentInfo.fromJson(json['comment_info'] as Map<String, dynamic>),
      userInfo:
          UserInfoModel.fromJson(json['user_info'] as Map<String, dynamic>),
      userInteract:
          UserInteract.fromJson(json['user_interact'] as Map<String, dynamic>),
      replyInfos: (json['reply_infos'] as List<dynamic>)
          .map((e) => e as Object)
          .toList(),
      isAuthor: json['is_author'] as bool,
    );

Map<String, dynamic> _$CommentItemModelToJson(CommentItemModel instance) =>
    <String, dynamic>{
      'comment_id': instance.commentId,
      'comment_info': instance.commentInfo.toJson(),
      'user_info': instance.userInfo.toJson(),
      'user_interact': instance.userInteract.toJson(),
      'reply_infos': instance.replyInfos,
      'is_author': instance.isAuthor,
    };

CommentInfo _$CommentInfoFromJson(Map<String, dynamic> json) => CommentInfo(
      commentId: json['comment_id'] as String,
      userId: json['user_id'] as String,
      itemId: json['item_id'] as String,
      itemType: json['item_type'] as int,
      commentContent: json['comment_content'] as String,
      commentPics: (json['comment_pics'] as List<dynamic>)
          .map((e) => e as Object)
          .toList(),
      commentStatus: json['comment_status'] as int,
      ctime: json['ctime'] as int,
      commentReplies: (json['commentReplys'] as List<dynamic>)
          .map((e) => e as Object)
          .toList(),
      diggCount: json['digg_count'] as int,
      buryCount: json['bury_count'] as int,
      replyCount: json['reply_count'] as int,
      isDigg: json['is_digg'] as bool,
      isBury: json['is_bury'] as bool,
      level: json['level'] as int,
    );

Map<String, dynamic> _$CommentInfoToJson(CommentInfo instance) =>
    <String, dynamic>{
      'comment_id': instance.commentId,
      'user_id': instance.userId,
      'item_id': instance.itemId,
      'item_type': instance.itemType,
      'comment_content': instance.commentContent,
      'comment_pics': instance.commentPics,
      'comment_status': instance.commentStatus,
      'ctime': instance.ctime,
      'commentReplys': instance.commentReplies,
      'digg_count': instance.diggCount,
      'bury_count': instance.buryCount,
      'reply_count': instance.replyCount,
      'is_digg': instance.isDigg,
      'is_bury': instance.isBury,
      'level': instance.level,
    };

FeedModel _$FeedModelFromJson(Map<String, dynamic> json) => FeedModel(
      itemType: FeedModel._feedItemTypeFromJson(json['item_type'] as int),
      itemInfo: FeedModel._handleItemInfoType(json, 'item_info') as Object,
    );

Map<String, dynamic> _$FeedModelToJson(FeedModel instance) => <String, dynamic>{
      'item_type': FeedModel._feedItemTypeToJson(instance.itemType),
      'item_info': instance.itemInfo,
    };

UserInfoModel _$UserInfoModelFromJson(Map<String, dynamic> json) =>
    UserInfoModel(
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      company: json['company'] as String,
      jobTitle: json['job_title'] as String,
      avatarLarge: json['avatar_large'] as String,
      level: json['level'] as int,
      description: json['description'] as String,
      followeeCount: json['followee_count'] as int,
      followerCount: json['follower_count'] as int,
      postArticleCount: json['post_article_count'] as int,
      diggArticleCount: json['digg_article_count'] as int,
      gotDiggCount: json['got_digg_count'] as int,
      gotViewCount: json['got_view_count'] as int,
      postShortMsgCount: json['post_shortmsg_count'] as int,
      diggShortMsgCount: json['digg_shortmsg_count'] as int,
      isFollowed: json['isfollowed'] as bool,
      favorableAuthor: json['favorable_author'] as int,
      power: json['power'] as int,
      studyPoint: json['study_point'] as int,
      university:
          UserUniversity.fromJson(json['university'] as Map<String, dynamic>),
      major: UserMajor.fromJson(json['major'] as Map<String, dynamic>),
      studentStatus: json['student_status'] as int,
      selectEventCount: json['select_event_count'] as int,
      selectOnlineCourseCount: json['select_online_course_count'] as int,
      identity: json['identity'] as int,
      isSelectAnnual: json['is_select_annual'] as bool,
      selectAnnualRank: json['select_annual_rank'] as int,
      annualListType: json['annual_list_type'] as int,
      extraMap: json['extramap'],
      isLogout: json['is_logout'] as int,
      annualInfo: (json['annual_info'] as List<dynamic>)
          .map((e) => e as Object)
          .toList(),
      accountAmount: json['account_amount'] as int,
      userGrowthInfo: UserGrowthInfo.fromJson(
          json['user_growth_info'] as Map<String, dynamic>),
      isVip: json['is_vip'] as bool,
    );

Map<String, dynamic> _$UserInfoModelToJson(UserInfoModel instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'company': instance.company,
      'job_title': instance.jobTitle,
      'avatar_large': instance.avatarLarge,
      'level': instance.level,
      'description': instance.description,
      'followee_count': instance.followeeCount,
      'follower_count': instance.followerCount,
      'post_article_count': instance.postArticleCount,
      'digg_article_count': instance.diggArticleCount,
      'got_digg_count': instance.gotDiggCount,
      'got_view_count': instance.gotViewCount,
      'postShortmsgCount': instance.postShortMsgCount,
      'diggShortmsgCount': instance.diggShortMsgCount,
      'isfollowed': instance.isFollowed,
      'favorable_author': instance.favorableAuthor,
      'power': instance.power,
      'study_point': instance.studyPoint,
      'university': instance.university.toJson(),
      'major': instance.major.toJson(),
      'student_status': instance.studentStatus,
      'select_event_count': instance.selectEventCount,
      'select_online_course_count': instance.selectOnlineCourseCount,
      'identity': instance.identity,
      'is_select_annual': instance.isSelectAnnual,
      'select_annual_rank': instance.selectAnnualRank,
      'annual_list_type': instance.annualListType,
      'extramap': instance.extraMap,
      'is_logout': instance.isLogout,
      'annual_info': instance.annualInfo,
      'account_amount': instance.accountAmount,
      'user_growth_info': instance.userGrowthInfo.toJson(),
      'is_vip': instance.isVip,
    };

UserUniversity _$UserUniversityFromJson(Map<String, dynamic> json) =>
    UserUniversity(
      universityId: json['university_id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String,
    );

Map<String, dynamic> _$UserUniversityToJson(UserUniversity instance) =>
    <String, dynamic>{
      'university_id': instance.universityId,
      'name': instance.name,
      'logo': instance.logo,
    };

UserMajor _$UserMajorFromJson(Map<String, dynamic> json) => UserMajor(
      majorId: json['major_id'] as String,
      parentId: json['parent_id'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$UserMajorToJson(UserMajor instance) => <String, dynamic>{
      'major_id': instance.majorId,
      'parent_id': instance.parentId,
      'name': instance.name,
    };

UserGrowthInfo _$UserGrowthInfoFromJson(Map<String, dynamic> json) =>
    UserGrowthInfo(
      userId: json['user_id'] as int,
      jPower: json['jpower'] as int,
      jScore: (json['jscore'] as num).toDouble(),
      jPowerLevel: json['jpower_level'] as int,
      jScoreLevel: json['jscore_level'] as int,
      jScoreTitle: json['jscore_title'] as String,
      authorAchievementList: (json['author_achievement_list'] as List<dynamic>)
          .map((e) => e as Object)
          .toList(),
      vipLevel: json['vip_level'] as int,
      vipTitle: json['vip_title'] as String,
    );

Map<String, dynamic> _$UserGrowthInfoToJson(UserGrowthInfo instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'jpower': instance.jPower,
      'jscore': instance.jScore,
      'jpower_level': instance.jPowerLevel,
      'jscore_level': instance.jScoreLevel,
      'jscore_title': instance.jScoreTitle,
      'author_achievement_list': instance.authorAchievementList,
      'vip_level': instance.vipLevel,
      'vip_title': instance.vipTitle,
    };

UserInteract _$UserInteractFromJson(Map<String, dynamic> json) => UserInteract(
      id: json['id'] as int,
      omitEmpty: json['omitempty'] as int,
      userId: json['user_id'] as int,
      isDigg: json['is_digg'] as bool,
      isFollow: json['is_follow'] as bool,
      isCollect: json['is_collect'] as bool,
    );

Map<String, dynamic> _$UserInteractToJson(UserInteract instance) =>
    <String, dynamic>{
      'id': instance.id,
      'omitempty': instance.omitEmpty,
      'user_id': instance.userId,
      'is_digg': instance.isDigg,
      'is_follow': instance.isFollow,
      'is_collect': instance.isCollect,
    };

UserOrg _$UserOrgFromJson(Map<String, dynamic> json) => UserOrg(
      orgInfo: json['org_info'],
      orgUser: json['org_user'],
      isFollowed: json['is_followed'] as bool,
    );

Map<String, dynamic> _$UserOrgToJson(UserOrg instance) => <String, dynamic>{
      'org_info': instance.orgInfo,
      'org_user': instance.orgUser,
      'is_followed': instance.isFollowed,
    };
