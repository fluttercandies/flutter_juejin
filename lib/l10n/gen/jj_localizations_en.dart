

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
  String get exceptionRouteNotFound => ' route not found。';

  @override
  String get exceptionRouteUnknown => 'Unknown';

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
  String get actionMore => 'More';

  @override
  String get actionFold => 'Fold';

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
  String durationYears(num many) {
    final String pluralString = intl.Intl.pluralLogic(
      many,
      locale: localeName,
      one: '1 year',
      other: '$many years',
    );

    return '$pluralString ago';
  }

  @override
  String durationMonths(num many) {
    final String pluralString = intl.Intl.pluralLogic(
      many,
      locale: localeName,
      one: '1 month',
      other: '$many months',
    );

    return '$pluralString ago';
  }

  @override
  String durationDays(num many) {
    final String pluralString = intl.Intl.pluralLogic(
      many,
      locale: localeName,
      one: '1 day',
      other: '$many days',
    );

    return '$pluralString ago';
  }

  @override
  String durationHours(num many) {
    final String pluralString = intl.Intl.pluralLogic(
      many,
      locale: localeName,
      one: '1 hour',
      other: '$many hours',
    );

    return '$pluralString ago';
  }

  @override
  String durationMinutes(num many) {
    return intl.Intl.pluralLogic(
      many,
      locale: localeName,
      zero: 'Just now',
      one: '1 minute ago',
      other: '$many minutes ago',
    );
  }
}
