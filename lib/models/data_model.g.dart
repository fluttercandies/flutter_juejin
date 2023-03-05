// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeedModel _$FeedModelFromJson(Map<String, dynamic> json) => FeedModel(
      itemType: FeedModel._feedItemTypeFromJson(json['item_type'] as int),
      itemInfo: FeedModel._handleItemInfoType(json, 'item_info') as Object,
    );

Map<String, dynamic> _$FeedModelToJson(FeedModel instance) => <String, dynamic>{
      'item_type': FeedModel._feedItemTypeToJson(instance.itemType),
      'item_info': instance.itemInfo,
    };

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
      authorId: json['author_id'] as String,
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
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      userInteract:
          UserInteract.fromJson(json['user_interact'] as Map<String, dynamic>),
      org: UserOrg.fromJson(json['org'] as Map<String, dynamic>),
      reqId: json['req_id'] as String,
      status: ArticleStatus.fromJson(json['status'] as Map<String, dynamic>),
      authorInteract: json['author_interact'],
      extra: json['extra'] == null
          ? null
          : ArticleExtra.fromJson(json['extra'] as Map<String, dynamic>),
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
      'extra': instance.extra?.toJson(),
    };

ArticleInfo _$ArticleInfoFromJson(Map<String, dynamic> json) => ArticleInfo(
      articleId: json['article_id'] as String,
      userId: json['user_id'] as String,
      categoryId: json['category_id'] as String,
      tagIds:
          (json['tag_ids'] as List<dynamic>?)?.map((e) => e as int).toList() ??
              [],
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
      boostType: json['boost_type'] as String?,
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
      showType: json['show_type'] as int,
      itemType: json['item_type'] as int,
      promoteTagCap: json['promote_tag_cap'] as int,
      promotePriority: json['promote_priority'] as int,
      ctime: json['ctime'] as int?,
      mtime: json['mtime'] as int?,
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
      replyInfos: (json['reply_infos'] as List<dynamic>?)
              ?.map((e) => ReplyInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      isAuthor: json['is_author'] as bool,
    );

Map<String, dynamic> _$CommentItemModelToJson(CommentItemModel instance) =>
    <String, dynamic>{
      'comment_id': instance.commentId,
      'comment_info': instance.commentInfo.toJson(),
      'user_info': instance.userInfo.toJson(),
      'user_interact': instance.userInteract.toJson(),
      'reply_infos': instance.replyInfos.map((e) => e.toJson()).toList(),
      'is_author': instance.isAuthor,
    };

CommentInfo _$CommentInfoFromJson(Map<String, dynamic> json) => CommentInfo(
      commentId: json['comment_id'] as String,
      userId: json['user_id'] as String,
      itemId: json['item_id'] as String,
      itemType: json['item_type'] as int,
      commentContent: json['comment_content'] as String,
      commentPics: (json['comment_pics'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList() ??
          [],
      commentStatus: json['comment_status'] as int,
      ctime: json['ctime'] as int,
      commentReplies: (json['commentReplys'] as List<dynamic>?)
              ?.map((e) => CommentReply.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
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
      'commentReplys': instance.commentReplies.map((e) => e.toJson()).toList(),
      'digg_count': instance.diggCount,
      'bury_count': instance.buryCount,
      'reply_count': instance.replyCount,
      'is_digg': instance.isDigg,
      'is_bury': instance.isBury,
      'level': instance.level,
    };

CommentReply _$CommentReplyFromJson(Map<String, dynamic> json) => CommentReply(
      replyId: json['reply_id'] as String,
      replyCommentId: json['reply_comment_id'] as String,
      userId: json['user_id'] as String,
      replyToReplyId: json['reply_to_reply_id'] as String,
      replyToUserId: json['reply_to_user_id'] as String,
      itemId: json['item_id'] as String,
      itemType: json['item_type'] as int,
      replyContent: json['reply_content'] as String,
      replyPics: (json['reply_pics'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      replyStatus: json['reply_status'] as int,
      ctime: json['ctime'] as int,
      diggCount: json['digg_count'] as int,
      buryCount: json['burry_count'] as int,
    );

Map<String, dynamic> _$CommentReplyToJson(CommentReply instance) =>
    <String, dynamic>{
      'reply_id': instance.replyId,
      'reply_comment_id': instance.replyCommentId,
      'user_id': instance.userId,
      'reply_to_reply_id': instance.replyToReplyId,
      'reply_to_user_id': instance.replyToUserId,
      'item_id': instance.itemId,
      'item_type': instance.itemType,
      'reply_content': instance.replyContent,
      'reply_pics': instance.replyPics,
      'reply_status': instance.replyStatus,
      'ctime': instance.ctime,
      'digg_count': instance.diggCount,
      'burry_count': instance.buryCount,
    };

ReplyInfo _$ReplyInfoFromJson(Map<String, dynamic> json) => ReplyInfo(
      replyId: json['reply_id'] as int,
      isAuthor: json['is_author'] as bool,
      parentReply: json['parent_reply'] as Object,
      replyInfo:
          CommentReply.fromJson(json['reply_info'] as Map<String, dynamic>),
      userInfo:
          UserInfoModel.fromJson(json['user_info'] as Map<String, dynamic>),
      userInteract: json['user_interact'] as Object,
    );

Map<String, dynamic> _$ReplyInfoToJson(ReplyInfo instance) => <String, dynamic>{
      'reply_id': instance.replyId,
      'is_author': instance.isAuthor,
      'parent_reply': instance.parentReply,
      'reply_info': instance.replyInfo.toJson(),
      'user_info': instance.userInfo.toJson(),
      'user_interact': instance.userInteract,
    };

PinItemModel _$PinItemModelFromJson(Map<String, dynamic> json) => PinItemModel(
      msgId: json['msg_id'] as String,
      msgInfo: PinInfo.fromJson(json['msg_Info'] as Map<String, dynamic>),
      authorUserInfo: UserInfoModel.fromJson(
          json['author_user_info'] as Map<String, dynamic>),
      topic: PinItemModel._readTopic(json, 'topic') == null
          ? null
          : PinTopic.fromJson(
              PinItemModel._readTopic(json, 'topic') as Map<String, dynamic>),
      userInteract:
          UserInteract.fromJson(json['user_interact'] as Map<String, dynamic>),
      org: UserOrg.fromJson(json['org'] as Map<String, dynamic>),
      theme: PinTheme.fromJson(json['theme'] as Map<String, dynamic>),
      hotComment: PinItemModel._readHotComment(json, 'hot_comment') == null
          ? null
          : HotComment.fromJson(
              PinItemModel._readHotComment(json, 'hot_comment')
                  as Map<String, dynamic>),
      diggUser: (json['digg_user'] as List<dynamic>?)
              ?.map((e) => UserInfoModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );

Map<String, dynamic> _$PinItemModelToJson(PinItemModel instance) =>
    <String, dynamic>{
      'msg_id': instance.msgId,
      'msg_Info': instance.msgInfo.toJson(),
      'author_user_info': instance.authorUserInfo.toJson(),
      'topic': instance.topic?.toJson(),
      'user_interact': instance.userInteract.toJson(),
      'org': instance.org.toJson(),
      'theme': instance.theme.toJson(),
      'hot_comment': instance.hotComment?.toJson(),
      'digg_user': instance.diggUser.map((e) => e.toJson()).toList(),
    };

PinInfo _$PinInfoFromJson(Map<String, dynamic> json) => PinInfo(
      id: json['id'] as int,
      msgId: json['msg_id'] as String,
      userId: json['user_id'] as String,
      topicId: json['topic_id'] as String,
      content: json['content'] as String,
      picList: (json['pic_list'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      url: json['url'] as String,
      urlTitle: json['url_title'] as String,
      urlPic: json['url_pic'] as String,
      verifyStatus: json['verify_status'] as int,
      status: json['status'] as int,
      ctime: json['ctime'] as String,
      mtime: json['mtime'] as String,
      rtime: json['rtime'] as String,
      commentCount: json['comment_count'] as int,
      diggCount: json['digg_count'] as int,
      hotIndex: (json['hot_index'] as num).toDouble(),
      rankIndex: (json['rank_index'] as num).toDouble(),
      commentScore: json['comment_score'] as int,
      isAdvertRecommend: json['is_advert_recommend'] as bool,
      auditStatus: json['audit_status'] as int,
      themeId: json['theme_id'] as String,
    );

Map<String, dynamic> _$PinInfoToJson(PinInfo instance) => <String, dynamic>{
      'id': instance.id,
      'msg_id': instance.msgId,
      'user_id': instance.userId,
      'topic_id': instance.topicId,
      'content': instance.content,
      'pic_list': instance.picList,
      'url': instance.url,
      'url_title': instance.urlTitle,
      'url_pic': instance.urlPic,
      'verify_status': instance.verifyStatus,
      'status': instance.status,
      'ctime': instance.ctime,
      'mtime': instance.mtime,
      'rtime': instance.rtime,
      'comment_count': instance.commentCount,
      'digg_count': instance.diggCount,
      'hot_index': instance.hotIndex,
      'rank_index': instance.rankIndex,
      'comment_score': instance.commentScore,
      'is_advert_recommend': instance.isAdvertRecommend,
      'audit_status': instance.auditStatus,
      'theme_id': instance.themeId,
    };

PinTopic _$PinTopicFromJson(Map<String, dynamic> json) => PinTopic(
      topicId: json['topic_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      msgCount: json['msg_count'] as int,
      followerCount: json['follower_count'] as int,
      attenderCount: json['attender_count'] as int,
      notice: json['notice'] as String,
      adminIds: (json['admin_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      themeIds: (json['theme_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      categoryId: json['cate_id'] as String,
      isRec: json['is_rec'] as bool,
      recRank: json['rec_rank'] as int,
    );

Map<String, dynamic> _$PinTopicToJson(PinTopic instance) => <String, dynamic>{
      'topic_id': instance.topicId,
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
      'msg_count': instance.msgCount,
      'follower_count': instance.followerCount,
      'attender_count': instance.attenderCount,
      'notice': instance.notice,
      'admin_ids': instance.adminIds,
      'theme_ids': instance.themeIds,
      'cate_id': instance.categoryId,
      'is_rec': instance.isRec,
      'rec_rank': instance.recRank,
    };

PinTheme _$PinThemeFromJson(Map<String, dynamic> json) => PinTheme(
      themeId: json['theme_id'] as String,
      name: json['name'] as String,
      cover: json['cover'] as String,
      brief: json['brief'] as String,
      isLottery: json['is_lottery'] as bool,
      isRec: json['is_rec'] as bool,
      recRank: json['rec_rank'] as int,
      topicIds: (json['topic_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      hot: json['hot'] as int,
      viewCount: json['view_cnt'] as int,
      userCount: json['user_cnt'] as int,
      status: json['status'] as int,
      ctime: json['ctime'] as int,
      mtime: json['mtime'] as int,
      lotteryBeginTime: json['lottery_begin_time'] as int,
      lotteryEndTime: json['lottery_end_time'] as int,
    );

Map<String, dynamic> _$PinThemeToJson(PinTheme instance) => <String, dynamic>{
      'theme_id': instance.themeId,
      'name': instance.name,
      'cover': instance.cover,
      'brief': instance.brief,
      'is_lottery': instance.isLottery,
      'is_rec': instance.isRec,
      'rec_rank': instance.recRank,
      'topic_ids': instance.topicIds,
      'hot': instance.hot,
      'view_cnt': instance.viewCount,
      'user_cnt': instance.userCount,
      'status': instance.status,
      'ctime': instance.ctime,
      'mtime': instance.mtime,
      'lottery_begin_time': instance.lotteryBeginTime,
      'lottery_end_time': instance.lotteryEndTime,
    };

HotComment _$HotCommentFromJson(Map<String, dynamic> json) => HotComment(
      commentId: json['comment_id'] as String,
      commentInfo:
          CommentInfo.fromJson(json['comment_info'] as Map<String, dynamic>),
      userInfo: HotComment._readUserInfo(json, 'user_info') == null
          ? null
          : UserInfoModel.fromJson(HotComment._readUserInfo(json, 'user_info')
              as Map<String, dynamic>),
      userInteract:
          UserInteract.fromJson(json['user_interact'] as Map<String, dynamic>),
      replyInfos: (json['reply_infos'] as List<dynamic>?)
              ?.map((e) => e as Object)
              .toList() ??
          [],
      isAuthor: json['is_author'] as bool,
    );

Map<String, dynamic> _$HotCommentToJson(HotComment instance) =>
    <String, dynamic>{
      'comment_id': instance.commentId,
      'comment_info': instance.commentInfo.toJson(),
      'user_info': instance.userInfo?.toJson(),
      'user_interact': instance.userInteract.toJson(),
      'reply_infos': instance.replyInfos,
      'is_author': instance.isAuthor,
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
      university: json['university'] == null
          ? null
          : UserUniversity.fromJson(json['university'] as Map<String, dynamic>),
      major: json['major'] == null
          ? null
          : UserMajor.fromJson(json['major'] as Map<String, dynamic>),
      studentStatus: json['student_status'] as int,
      selectEventCount: json['select_event_count'] as int,
      selectOnlineCourseCount: json['select_online_course_count'] as int,
      identity: json['identity'] as int,
      isSelectAnnual: json['is_select_annual'] as bool,
      selectAnnualRank: json['select_annual_rank'] as int,
      annualListType: json['annual_list_type'] as int,
      extraMap: json['extramap'],
      isLogout: json['is_logout'] as int,
      annualInfo: (json['annual_info'] as List<dynamic>?)
          ?.map((e) => e as Object)
          .toList(),
      accountAmount: json['account_amount'] as int,
      userGrowthInfo: json['user_growth_info'] == null
          ? null
          : UserGrowthInfo.fromJson(
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
      'post_shortmsg_count': instance.postShortMsgCount,
      'digg_shortmsg_count': instance.diggShortMsgCount,
      'isfollowed': instance.isFollowed,
      'favorable_author': instance.favorableAuthor,
      'power': instance.power,
      'study_point': instance.studyPoint,
      'university': instance.university?.toJson(),
      'major': instance.major?.toJson(),
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
      'user_growth_info': instance.userGrowthInfo?.toJson(),
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
      id: json['id'] as int? ?? 0,
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

UserPassportModel _$UserPassportModelFromJson(Map<String, dynamic> json) =>
    UserPassportModel(
      appId: json['app_id'] as int? ?? 0,
      userId: json['user_id'] as int,
      userIdStr: json['user_id_str'] as String? ?? '',
      odinUserType: json['odin_user_type'] as int? ?? 0,
      name: json['name'] as String,
      screenName: json['screen_name'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? '',
      userVerified: json['user_verified'] as bool? ?? false,
      emailCollected: json['email_collected'] as bool? ?? false,
      phoneCollected: json['phone_collected'] as bool? ?? false,
      verifiedContent: json['verified_content'] as String? ?? '',
      verifiedAgency: json['verified_agency'] as String? ?? '',
      isBlocked: json['is_blocked'] as int? ?? 0,
      isBlocking: json['is_blocking'] as int? ?? 0,
      bgImgUrl: json['bg_img_url'] as String? ?? '',
      gender: json['gender'] as int? ?? 0,
      mediaId: json['media_id'] as int? ?? 0,
      userAuthInfo: json['user_auth_info'] as String? ?? '',
      industry: json['industry'] as String? ?? '',
      area: json['area'] as String? ?? '',
      canBeFoundByPhone: json['can_be_found_by_phone'] as int? ?? 0,
      mobile: json['mobile'] as String? ?? '',
      birthday: json['birthday'] as String? ?? '',
      description: json['description'] as String? ?? '',
      email: json['email'] as String? ?? '',
      newUser: json['new_user'] as int? ?? 0,
      firstLoginApp: json['first_login_app'] as int? ?? 0,
      sessionKey: json['session_key'] as String,
      isRecommendAllowed: json['is_recommend_allowed'] as int? ?? 0,
      recommendHintMessage: json['recommend_hint_message'] as String? ?? '',
      connects: json['connects'] as List<dynamic>?,
      followingsCount: json['followings_count'] as int? ?? 0,
      followersCount: json['followers_count'] as int? ?? 0,
      visitCountRecent: json['visit_count_recent'] as int? ?? 0,
      skipEditProfile: json['skip_edit_profile'] as int? ?? 0,
      isManualSetUserInfo: json['is_manual_set_user_info'] as bool? ?? false,
      deviceId: json['device_id'] as int? ?? 0,
      countryCode: json['country_code'] as int? ?? 0,
      hasPassword: json['has_password'] as int? ?? 0,
      shareToRepost: json['share_to_repost'] as int? ?? 0,
      userDecoration: json['user_decoration'] as String? ?? '',
      userPrivacyExtend: json['user_privacy_extend'] as int? ?? 0,
      oldUserId: json['old_user_id'] as int? ?? 0,
      oldUserIdStr: json['old_user_id_str'] as String? ?? '',
      secUserId: json['sec_user_id'] as String? ?? '',
      secOldUserId: json['sec_old_user_id'] as String? ?? '',
      vcdAccount: json['vcd_account'] as int? ?? 0,
      vcdRelation: json['vcd_relation'] as int? ?? 0,
      canBindVisitorAccount: json['can_bind_visitor_account'] as bool? ?? false,
      isVisitorAccount: json['is_visitor_account'] as bool? ?? false,
      isOnlyBindIns: json['is_only_bind_ins'] as bool? ?? false,
      userDeviceRecordStatus: json['user_device_record_status'] as int? ?? 0,
      isKidsMode: json['is_kids_mode'] as int? ?? 0,
      isEmployee: json['is_employee'] as bool? ?? false,
      passportEnterpriseUserType:
          json['passport_enterprise_user_type'] as int? ?? 0,
      needDeviceCreate: json['need_device_create'] as int? ?? 0,
      needTtwidMigration: json['need_ttwid_migration'] as int? ?? 0,
      userAuthStatus: json['user_auth_status'] as int? ?? 0,
      userSafeMobile2Fa: json['user_safe_mobile2_fa'] as String? ?? '',
      safeMobileCountryCode: json['safe_mobile_country_code'] as int? ?? 0,
      liteUserInfoString: json['lite_user_info_string'] as String? ?? '',
      liteUserInfoDemotion: json['lite_user_info_demotion'] as int? ?? 0,
      appUserInfo: json['app_user_info'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$UserPassportModelToJson(UserPassportModel instance) =>
    <String, dynamic>{
      'app_id': instance.appId,
      'user_id': instance.userId,
      'user_id_str': instance.userIdStr,
      'odin_user_type': instance.odinUserType,
      'name': instance.name,
      'screen_name': instance.screenName,
      'avatar_url': instance.avatarUrl,
      'user_verified': instance.userVerified,
      'email_collected': instance.emailCollected,
      'phone_collected': instance.phoneCollected,
      'verified_content': instance.verifiedContent,
      'verified_agency': instance.verifiedAgency,
      'is_blocked': instance.isBlocked,
      'is_blocking': instance.isBlocking,
      'bg_img_url': instance.bgImgUrl,
      'gender': instance.gender,
      'media_id': instance.mediaId,
      'user_auth_info': instance.userAuthInfo,
      'industry': instance.industry,
      'area': instance.area,
      'can_be_found_by_phone': instance.canBeFoundByPhone,
      'mobile': instance.mobile,
      'birthday': instance.birthday,
      'description': instance.description,
      'email': instance.email,
      'new_user': instance.newUser,
      'first_login_app': instance.firstLoginApp,
      'session_key': instance.sessionKey,
      'is_recommend_allowed': instance.isRecommendAllowed,
      'recommend_hint_message': instance.recommendHintMessage,
      'connects': instance.connects,
      'followings_count': instance.followingsCount,
      'followers_count': instance.followersCount,
      'visit_count_recent': instance.visitCountRecent,
      'skip_edit_profile': instance.skipEditProfile,
      'is_manual_set_user_info': instance.isManualSetUserInfo,
      'device_id': instance.deviceId,
      'country_code': instance.countryCode,
      'has_password': instance.hasPassword,
      'share_to_repost': instance.shareToRepost,
      'user_decoration': instance.userDecoration,
      'user_privacy_extend': instance.userPrivacyExtend,
      'old_user_id': instance.oldUserId,
      'old_user_id_str': instance.oldUserIdStr,
      'sec_user_id': instance.secUserId,
      'sec_old_user_id': instance.secOldUserId,
      'vcd_account': instance.vcdAccount,
      'vcd_relation': instance.vcdRelation,
      'can_bind_visitor_account': instance.canBindVisitorAccount,
      'is_visitor_account': instance.isVisitorAccount,
      'is_only_bind_ins': instance.isOnlyBindIns,
      'user_device_record_status': instance.userDeviceRecordStatus,
      'is_kids_mode': instance.isKidsMode,
      'is_employee': instance.isEmployee,
      'passport_enterprise_user_type': instance.passportEnterpriseUserType,
      'need_device_create': instance.needDeviceCreate,
      'need_ttwid_migration': instance.needTtwidMigration,
      'user_auth_status': instance.userAuthStatus,
      'user_safe_mobile2_fa': instance.userSafeMobile2Fa,
      'safe_mobile_country_code': instance.safeMobileCountryCode,
      'lite_user_info_string': instance.liteUserInfoString,
      'lite_user_info_demotion': instance.liteUserInfoDemotion,
      'app_user_info': instance.appUserInfo,
    };
