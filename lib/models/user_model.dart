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
  final UserUniversity university;
  final UserMajor major;
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
  final List<Object> annualInfo;
  final int accountAmount;
  final UserGrowthInfo userGrowthInfo;
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
    final String asset = R.ASSETS_ICON_USER_VIP_LV1_WEBP.replaceAll(
      '1',
      '${userGrowthInfo.vipLevel}',
    );
    return Image.asset(asset, width: size, height: size, fit: BoxFit.cover);
  }

  Widget buildNameAndLevel({double? levelWidth, double levelHeight = 12}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(userName),
        const SizedBox(width: 4),
        buildLevelImage(width: levelWidth, height: levelHeight),
        if (userGrowthInfo.vipLevel > 0) Padding(
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
