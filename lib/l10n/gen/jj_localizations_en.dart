


import 'jj_localizations.dart';

/// The translations for English (`en`).
class JJLocalizationsEn extends JJLocalizations {
  JJLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Juejin';

  @override
  String get exceptionError => 'error';

  @override
  String get exceptionFailed => 'failed';

  @override
  String get exceptionErrorWidget => 'Exception thrown during building this widget...';

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
}
