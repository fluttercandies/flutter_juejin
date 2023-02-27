import 'package:intl/intl.dart' as intl;

import 'jj_localizations.dart';

/// The translations for English (`en`).
class JJLocalizationsEn extends JJLocalizations {
  JJLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Juejin';

  @override
  String get exceptionAuthenticationExpired => 'Authentication has expired, please login manually.';

  @override
  String get exceptionError => 'error';

  @override
  String get exceptionErrorWidget => 'Exception thrown during building this widget...';

  @override
  String get exceptionFailed => 'failed';

  @override
  String get exceptionPoorNetwork => 'Poor network condition, please retry later.';

  @override
  String exceptionRequest(Object message) {
    return 'Request error: (-1 $message)';
  }

  @override
  String exceptionRouteNotFound(String routeName) {
    return '$routeName route not found.';
  }

  @override
  String get exceptionRouteUnknown => 'Unknown';

  @override
  String get notSupported => 'Not supported yet';

  @override
  String get close => 'Close';

  @override
  String get listEmpty => 'It\'s empty here.';

  @override
  String get listLoadingMore => 'Loading more content...';

  @override
  String get listNetworkErrorClickRetry => 'Network exceptions thrown. Click to retry.';

  @override
  String get listNoMoreToLoad => 'Nothing left.';

  @override
  String get listRefreshing => 'Refreshing...';

  @override
  String get listRefreshWaiting => 'Pull down more to refresh';

  @override
  String get listRefreshArmed => 'Release to refresh';

  @override
  String get listRefreshSucceed => 'Refreshed with new contents';

  @override
  String get listRefreshFailed => 'Failed to refresh';

  @override
  String get webViewTitle => 'Web page';

  @override
  String get navHome => 'Home';

  @override
  String get navPins => 'Pins';

  @override
  String get navMe => 'Me';

  @override
  String get actionLike => 'Like';

  @override
  String get actionComment => 'Comment';

  @override
  String get actionReply => 'Reply';

  @override
  String get actionMore => 'More';

  @override
  String get actionFold => 'Fold';

  @override
  String get actionCollect => 'Favorite';

  @override
  String get actionShare => 'Share';

  @override
  String get advertiseAbbr => 'Ad';

  @override
  String articleViews(int num) {
    return '$num views';
  }

  @override
  String get pinLiked => 'and others liked';

  @override
  String pinHotCommentLikes(int num) {
    return '$num likes';
  }

  @override
  String pinTotalCommentCount(int count) {
    return 'Total comments $count';
  }

  @override
  String get userLikes => 'Likes';

  @override
  String get userFavorites => 'Favorites';

  @override
  String get userFollows => 'Follows';

  @override
  String get userComments => 'Comments';

  @override
  String get userFollowing => 'Following';

  @override
  String get userNotFollow => 'Not follow';

  @override
  String get userSignInOrUp => 'Sign in/Sign up';

  @override
  String get arrangement => 'Sort By';

  @override
  String get recommend => 'Hot';

  @override
  String get latest => 'Latest';

  @override
  String get join => 'Join';

  @override
  String get categoryTabFollowing => 'Following';

  @override
  String get categoryTabRecommend => 'Recommend';

  @override
  String get tagAll => 'All';

  @override
  String get sortRecommend => 'Recommend';

  @override
  String get sortLatest => 'Latest';

  @override
  String durationYears(int many) {
    String _temp0 = intl.Intl.pluralLogic(
      many,
      locale: localeName,
      other: '$many years',
      one: '1 year',
    );
    return '$_temp0 ago';
  }

  @override
  String durationMonths(int many) {
    String _temp0 = intl.Intl.pluralLogic(
      many,
      locale: localeName,
      other: '$many months',
      one: '1 month',
    );
    return '$_temp0 ago';
  }

  @override
  String durationDays(int many) {
    String _temp0 = intl.Intl.pluralLogic(
      many,
      locale: localeName,
      other: '$many days',
      one: '1 day',
    );
    return '$_temp0 ago';
  }

  @override
  String durationHours(int many) {
    String _temp0 = intl.Intl.pluralLogic(
      many,
      locale: localeName,
      other: '$many hours',
      one: '1 hour',
    );
    return '$_temp0 ago';
  }

  @override
  String durationMinutes(int many) {
    String _temp0 = intl.Intl.pluralLogic(
      many,
      locale: localeName,
      other: '$many minutes ago',
      one: '1 minute ago',
      zero: 'Just now',
    );
    return '$_temp0';
  }
}
