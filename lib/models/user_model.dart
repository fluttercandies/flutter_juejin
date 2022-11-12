// Copyright 2022 The FlutterCandies author. All rights reserved.
// Use of this source code is governed by a MIT license that can be found in the
// LICENSE file.

part of 'data_model.dart';

@JsonSerializable()
class UserInfoModel extends DataModel {
  const UserInfoModel({
    required this.userId,
    required this.userName,
    required this.company,
    required this.jobTitle,
    required this.avatarLarge,
    required this.level,
    required this.description,
    required this.followeeCount,
    required this.followerCount,
    required this.postArticleCount,
    required this.diggArticleCount,
    required this.gotDiggCount,
    required this.gotViewCount,
    required this.postShortMsgCount,
    required this.diggShortMsgCount,
    required this.isFollowed,
    required this.favorableAuthor,
    required this.power,
    required this.studyPoint,
    required this.university,
    required this.major,
    required this.studentStatus,
    required this.selectEventCount,
    required this.selectOnlineCourseCount,
    required this.identity,
    required this.isSelectAnnual,
    required this.selectAnnualRank,
    required this.annualListType,
    required this.extraMap,
    required this.isLogout,
    required this.annualInfo,
    required this.accountAmount,
    required this.userGrowthInfo,
    required this.isVip,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) =>
      _$UserInfoModelFromJson(json);

  final String userId;
  final String userName;
  final String company;
  final String jobTitle;
  final String avatarLarge;
  final int level;
  final String description;
  final int followeeCount;
  final int followerCount;
  final int postArticleCount;
  final int diggArticleCount;
  final int gotDiggCount;
  final int gotViewCount;
  @JsonKey(name: 'post_shortmsg_count')
  final int postShortMsgCount;
  @JsonKey(name: 'digg_shortmsg_count')
  final int diggShortMsgCount;
  @JsonKey(name: 'isfollowed')
  final bool isFollowed;
  final int favorableAuthor;
  final int power;
  final int studyPoint;
  final UserUniversity? university;
  final UserMajor? major;
  final int studentStatus;
  final int selectEventCount;
  final int selectOnlineCourseCount;
  final int identity;
  final bool isSelectAnnual;
  final int selectAnnualRank;
  final int annualListType;
  @JsonKey(name: 'extramap')
  final Object? extraMap;
  final int isLogout;
  final List<Object>? annualInfo;
  final int accountAmount;
  final UserGrowthInfo? userGrowthInfo;
  final bool isVip;

  Widget buildCircleAvatar({double? size}) {
    return ClipOval(
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.network(avatarLarge, fit: BoxFit.cover),
      ),
    );
  }

  Widget buildLevelImage({double? width, double height = 12}) {
    final String asset = R.ASSETS_ICON_USER_LV1_WEBP.replaceAll('1', '$level');
    return Image.asset(asset, width: width, height: height, fit: BoxFit.cover);
  }

  Widget buildVipImage({double? size}) {
    if (userGrowthInfo == null) {
      return const SizedBox();
    }
    final String asset = R.ASSETS_ICON_USER_VIP_LV1_WEBP.replaceAll(
      '1',
      '${userGrowthInfo!.vipLevel}',
    );
    return Image.asset(asset, width: size, height: size, fit: BoxFit.cover);
  }

  Widget buildNameAndLevel({double? levelWidth, double levelHeight = 12}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(userName),
        const SizedBox(width: 4),
        if (level > 0) buildLevelImage(width: levelWidth, height: levelHeight),
        if (userGrowthInfo != null && userGrowthInfo!.vipLevel > 0)
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 4),
            child: buildVipImage(size: levelHeight * 1.375),
          ),
      ],
    );
  }

  @override
  Map<String, dynamic> toJson() => _$UserInfoModelToJson(this);

  @override
  List<Object?> get props => <Object?>[
        userId,
        userName,
        company,
        jobTitle,
        avatarLarge,
        level,
        description,
        followeeCount,
        followerCount,
        postArticleCount,
        diggArticleCount,
        gotDiggCount,
        gotViewCount,
        postShortMsgCount,
        diggShortMsgCount,
        isFollowed,
        favorableAuthor,
        power,
        studyPoint,
        university,
        major,
        studentStatus,
        selectEventCount,
        selectOnlineCourseCount,
        identity,
        isSelectAnnual,
        selectAnnualRank,
        annualListType,
        extraMap,
        isLogout,
        annualInfo,
        accountAmount,
        userGrowthInfo,
        isVip,
      ];
}

@JsonSerializable()
class UserUniversity extends DataModel {
  const UserUniversity({
    required this.universityId,
    required this.name,
    required this.logo,
  });

  factory UserUniversity.fromJson(Map<String, dynamic> json) =>
      _$UserUniversityFromJson(json);

  final String universityId;
  final String name;
  final String logo;

  @override
  Map<String, dynamic> toJson() => _$UserUniversityToJson(this);

  @override
  List<Object?> get props => <Object>[universityId, name, logo];
}

@JsonSerializable()
class UserMajor extends DataModel {
  const UserMajor({
    required this.majorId,
    required this.parentId,
    required this.name,
  });

  factory UserMajor.fromJson(Map<String, dynamic> json) =>
      _$UserMajorFromJson(json);

  final String majorId;
  final String parentId;
  final String name;

  @override
  Map<String, dynamic> toJson() => _$UserMajorToJson(this);

  @override
  List<Object?> get props => <Object>[majorId, parentId, name];
}

@JsonSerializable()
class UserGrowthInfo extends DataModel {
  const UserGrowthInfo({
    required this.userId,
    required this.jPower,
    required this.jScore,
    required this.jPowerLevel,
    required this.jScoreLevel,
    required this.jScoreTitle,
    required this.authorAchievementList,
    required this.vipLevel,
    required this.vipTitle,
  });

  factory UserGrowthInfo.fromJson(Map<String, dynamic> json) =>
      _$UserGrowthInfoFromJson(json);

  final int userId;
  @JsonKey(name: 'jpower')
  final int jPower;
  @JsonKey(name: 'jscore')
  final double jScore;
  @JsonKey(name: 'jpower_level')
  final int jPowerLevel;
  @JsonKey(name: 'jscore_level')
  final int jScoreLevel;
  @JsonKey(name: 'jscore_title')
  final String jScoreTitle;
  final List<Object> authorAchievementList;
  final int vipLevel;
  final String vipTitle;

  @override
  Map<String, dynamic> toJson() => _$UserGrowthInfoToJson(this);

  @override
  List<Object?> get props => <Object>[
        userId,
        jPower,
        jScore,
        jPowerLevel,
        jScoreLevel,
        jScoreTitle,
        authorAchievementList,
        vipLevel,
        vipTitle,
      ];
}

@JsonSerializable()
class UserInteract extends DataModel {
  const UserInteract({
    required this.id,
    required this.omitEmpty,
    required this.userId,
    required this.isDigg,
    required this.isFollow,
    required this.isCollect,
  });

  factory UserInteract.fromJson(Map<String, dynamic> json) =>
      _$UserInteractFromJson(json);

  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(name: 'omitempty')
  final int omitEmpty;
  final int userId;
  final bool isDigg;
  final bool isFollow;
  final bool isCollect;

  String followText(BuildContext context) =>
      isFollow ? context.l10n.userFollowing : context.l10n.userNotFollow;

  @override
  Map<String, dynamic> toJson() => _$UserInteractToJson(this);

  @override
  List<Object?> get props => <Object>[
        id,
        omitEmpty,
        userId,
        isDigg,
        isFollow,
        isCollect,
      ];
}

@JsonSerializable()
class UserOrg extends DataModel {
  const UserOrg({
    this.orgInfo,
    this.orgUser,
    required this.isFollowed,
  });

  factory UserOrg.fromJson(Map<String, dynamic> json) =>
      _$UserOrgFromJson(json);

  final Object? orgInfo;
  final Object? orgUser;
  final bool isFollowed;

  @override
  Map<String, dynamic> toJson() => _$UserOrgToJson(this);

  @override
  List<Object?> get props => <Object?>[orgInfo, orgUser, isFollowed];
}

@JsonSerializable()
class UserPassportModel extends DataModel {
  const UserPassportModel({
    this.appId = 0,
    required this.userId,
    this.userIdStr = '',
    this.odinUserType = 0,
    required this.name,
    this.screenName = '',
    this.avatarUrl = '',
    this.userVerified = false,
    this.emailCollected = false,
    this.phoneCollected = false,
    this.verifiedContent = '',
    this.verifiedAgency = '',
    this.isBlocked = 0,
    this.isBlocking = 0,
    this.bgImgUrl = '',
    this.gender = 0,
    this.mediaId = 0,
    this.userAuthInfo = '',
    this.industry = '',
    this.area = '',
    this.canBeFoundByPhone = 0,
    this.mobile = '',
    this.birthday = '',
    this.description = '',
    this.email = '',
    this.newUser = 0,
    required this.sessionKey,
    this.isRecommendAllowed = 0,
    this.recommendHintMessage = '',
    this.connects,
    this.followingsCount = 0,
    this.followersCount = 0,
    this.visitCountRecent = 0,
    this.skipEditProfile = 0,
    this.isManualSetUserInfo = false,
    this.deviceId = 0,
    this.countryCode = 0,
    this.hasPassword = 0,
    this.shareToRepost = 0,
    this.userDecoration = 0,
    this.userPrivacyExtend = 0,
    this.oldUserId = 0,
    this.oldUserIdStr = '',
    this.secUserId = '',
    this.secOldUserId = '',
    this.vcdAccount = 0,
    this.vcdRelation = 0,
    this.canBindVisitorAccount = false,
    this.isVisitorAccount = false,
    this.isOnlyBindIns = false,
    this.userDeviceRecordStatus = 0,
    this.isKidsMode = 0,
    this.isEmployee = false,
    this.passportEnterpriseUserType = 0,
    this.needDeviceCreate = 0,
    this.needTtwidMigration = 0,
    this.userAuthStatus = 0,
    this.userSafeMobile2Fa = '',
    this.safeMobileCountryCode = 0,
    this.liteUserInfoString = '',
    this.liteUserInfoDemotion = 0,
    this.appUserInfo,
  });

  const UserPassportModel.empty()
      : this(
          userId: 0,
          name: '',
          sessionKey: '',
        );

  factory UserPassportModel.fromJson(Map<String, dynamic> json) =>
      _$UserPassportModelFromJson(json);

  bool get isEmpty => userId == 0;

  final int appId;
  final int userId;
  final String userIdStr;
  final int odinUserType;
  final String name;
  final String screenName;
  final String avatarUrl;
  final bool userVerified;
  final bool emailCollected;
  final bool phoneCollected;
  final String verifiedContent;
  final String verifiedAgency;
  final int isBlocked;
  final int isBlocking;
  final String bgImgUrl;
  final int gender;
  final int mediaId;
  final String userAuthInfo;
  final String industry;
  final String area;
  final int canBeFoundByPhone;
  final String mobile;
  final String birthday;
  final String description;
  final String email;
  final int newUser;
  final String sessionKey;
  final int isRecommendAllowed;
  final String recommendHintMessage;
  final List? connects;
  final int followingsCount;
  final int followersCount;
  final int visitCountRecent;
  final int skipEditProfile;
  final bool isManualSetUserInfo;
  final int deviceId;
  final int countryCode;
  final int hasPassword;
  final int shareToRepost;
  final int userDecoration;
  final int userPrivacyExtend;
  final int oldUserId;
  final String oldUserIdStr;
  final String secUserId;
  final String secOldUserId;
  final int vcdAccount;
  final int vcdRelation;
  final bool canBindVisitorAccount;
  final bool isVisitorAccount;
  final bool isOnlyBindIns;
  final int userDeviceRecordStatus;
  final int isKidsMode;
  final bool isEmployee;
  final int passportEnterpriseUserType;
  final int needDeviceCreate;
  final int needTtwidMigration;
  final int userAuthStatus;
  final String userSafeMobile2Fa;
  final int safeMobileCountryCode;
  final String liteUserInfoString;
  final int liteUserInfoDemotion;
  final Json? appUserInfo;

  @override
  List<Object?> get props => <Object?>[
        appId,
        userId,
        userIdStr,
        odinUserType,
        name,
        screenName,
        avatarUrl,
        userVerified,
        emailCollected,
        phoneCollected,
        verifiedContent,
        verifiedAgency,
        isBlocked,
        isBlocking,
        bgImgUrl,
        gender,
        mediaId,
        userAuthInfo,
        industry,
        area,
        canBeFoundByPhone,
        mobile,
        birthday,
        description,
        email,
        newUser,
        sessionKey,
        isRecommendAllowed,
        recommendHintMessage,
        connects,
        followingsCount,
        followersCount,
        visitCountRecent,
        skipEditProfile,
        isManualSetUserInfo,
        deviceId,
        countryCode,
        hasPassword,
        shareToRepost,
        userDecoration,
        userPrivacyExtend,
        oldUserId,
        oldUserIdStr,
        secUserId,
        secOldUserId,
        vcdAccount,
        vcdRelation,
        canBindVisitorAccount,
        isVisitorAccount,
        isOnlyBindIns,
        userDeviceRecordStatus,
        isKidsMode,
        isEmployee,
        passportEnterpriseUserType,
        needDeviceCreate,
        needTtwidMigration,
        userAuthStatus,
        userSafeMobile2Fa,
        safeMobileCountryCode,
        liteUserInfoString,
        liteUserInfoDemotion,
        appUserInfo,
      ];

  @override
  Json toJson() => _$UserPassportModelToJson(this);
}
