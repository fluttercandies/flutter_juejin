import 'package:intl/intl.dart' as intl;

import 'jj_localizations.dart';

/// The translations for Chinese (`zh`).
class JJLocalizationsZh extends JJLocalizations {
  JJLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '掘金';

  @override
  String get exceptionAuthenticationExpired => '身份已失效，请重新登录';

  @override
  String get exceptionError => '错误';

  @override
  String get exceptionErrorWidget => '构建时遇到未知错误...';

  @override
  String get exceptionFailed => '失败';

  @override
  String get exceptionPoorNetwork => '网络状况差，请稍后重试';

  @override
  String exceptionRequest(Object message) {
    return '请求失败：(-1 $message)';
  }

  @override
  String exceptionRouteNotFound(String routeName) {
    return '$routeName 无效路由。';
  }

  @override
  String get exceptionRouteUnknown => '未知';

  @override
  String get notSupported => '尚未实现';

  @override
  String get close => '关闭';

  @override
  String get listEmpty => '空空如也';

  @override
  String get listLoadingMore => '加载中...';

  @override
  String get listNetworkErrorClickRetry => '网络出错了~点此重试';

  @override
  String get listNoMoreToLoad => '已经到底啦~';

  @override
  String get listRefreshing => '正在刷新...';

  @override
  String get listRefreshWaiting => '下拉更多以刷新';

  @override
  String get listRefreshArmed => '松手以刷新';

  @override
  String get listRefreshSucceed => '刷新成功';

  @override
  String get listRefreshFailed => '刷新失败';

  @override
  String get webViewTitle => '网页链接';

  @override
  String get navHome => '首页';

  @override
  String get navPins => '沸点';

  @override
  String get navMe => '我';

  @override
  String get actionLike => '赞';

  @override
  String get actionComment => '评论';

  @override
  String get actionReply => '回复';

  @override
  String get actionMore => '展开';

  @override
  String get actionFold => '收起';

  @override
  String get actionCollect => '收藏';

  @override
  String get actionShare => '分享';

  @override
  String get advertiseAbbr => '广告';

  @override
  String articleViews(int num) {
    return '阅读 $num';
  }

  @override
  String get pinLiked => '等人赞过';

  @override
  String pinHotCommentLikes(int num) {
    return '$num人赞';
  }

  @override
  String pinTotalCommentCount(int count) {
    return '全部评论 $count';
  }

  @override
  String get userLikes => '点赞';

  @override
  String get userFavorites => '收藏';

  @override
  String get userFollows => '关注';

  @override
  String get userComments => '评论';

  @override
  String get userFollowing => '已关注';

  @override
  String get userNotFollow => '未关注';

  @override
  String get userSignInOrUp => '登录/注册';

  @override
  String get arrangement => '排序';

  @override
  String get recommend => '热门';

  @override
  String get latest => '最新';

  @override
  String get join => '加入';

  @override
  String get categoryTabFollowing => '关注';

  @override
  String get categoryTabRecommend => '推荐';

  @override
  String get tagAll => '全部';

  @override
  String get sortRecommend => '推荐';

  @override
  String get sortLatest => '最新';

  @override
  String get loginTitle => '登录';

  @override
  String get loginSlogan => '登录体验更多精彩';

  @override
  String get hintUsername => '手机号/邮箱';

  @override
  String get hintPassword => '密码';

  @override
  String get buttonSignIn => '登录';

  @override
  String get linkSignUp => '注册新用户';

  @override
  String get linkRetrieve => '找回密码';

  @override
  String get loginSuccess => '登录成功';

  @override
  String get needUsername => '请填写用户名';

  @override
  String get incorectUsername => '请填写手机号码或者邮箱';

  @override
  String get needPassword => '请填写密码';

  @override
  String durationYears(int many) {
    String _temp0 = intl.Intl.pluralLogic(
      many,
      locale: localeName,
      other: '$many年前',
    );
    return '$_temp0';
  }

  @override
  String durationMonths(int many) {
    String _temp0 = intl.Intl.pluralLogic(
      many,
      locale: localeName,
      other: '$many月前',
    );
    return '$_temp0';
  }

  @override
  String durationDays(int many) {
    String _temp0 = intl.Intl.pluralLogic(
      many,
      locale: localeName,
      other: '$many天前',
    );
    return '$_temp0';
  }

  @override
  String durationHours(int many) {
    String _temp0 = intl.Intl.pluralLogic(
      many,
      locale: localeName,
      other: '$many小时前',
    );
    return '$_temp0';
  }

  @override
  String durationMinutes(int many) {
    String _temp0 = intl.Intl.pluralLogic(
      many,
      locale: localeName,
      other: '$many分钟前',
      zero: '刚刚',
    );
    return '$_temp0';
  }
}
