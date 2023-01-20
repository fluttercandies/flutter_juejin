import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'jj_localizations_en.dart';
import 'jj_localizations_zh.dart';

/// Callers can lookup localized strings with an instance of JJLocalizations
/// returned by `JJLocalizations.of(context)`.
///
/// Applications need to include `JJLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/jj_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: JJLocalizations.localizationsDelegates,
///   supportedLocales: JJLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the JJLocalizations.supportedLocales
/// property.
abstract class JJLocalizations {
  JJLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static JJLocalizations? of(BuildContext context) {
    return Localizations.of<JJLocalizations>(context, JJLocalizations);
  }

  static const LocalizationsDelegate<JJLocalizations> delegate = _JJLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Juejin'**
  String get appTitle;

  /// No description provided for @exceptionAuthenticationExpired.
  ///
  /// In en, this message translates to:
  /// **'Authentication has expired, please login manually.'**
  String get exceptionAuthenticationExpired;

  /// No description provided for @exceptionError.
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get exceptionError;

  /// No description provided for @exceptionErrorWidget.
  ///
  /// In en, this message translates to:
  /// **'Exception thrown during building this widget...'**
  String get exceptionErrorWidget;

  /// No description provided for @exceptionFailed.
  ///
  /// In en, this message translates to:
  /// **'failed'**
  String get exceptionFailed;

  /// No description provided for @exceptionPoorNetwork.
  ///
  /// In en, this message translates to:
  /// **'Poor network condition, please retry later.'**
  String get exceptionPoorNetwork;

  /// No description provided for @exceptionRequest.
  ///
  /// In en, this message translates to:
  /// **'Request error: (-1 {message})'**
  String exceptionRequest(Object message);

  /// No description provided for @exceptionRouteNotFound.
  ///
  /// In en, this message translates to:
  /// **'{routeName} route not found.'**
  String exceptionRouteNotFound(String routeName);

  /// No description provided for @exceptionRouteUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get exceptionRouteUnknown;

  /// No description provided for @notSupported.
  ///
  /// In en, this message translates to:
  /// **'Not supported yet'**
  String get notSupported;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @listEmpty.
  ///
  /// In en, this message translates to:
  /// **'It\'s empty here.'**
  String get listEmpty;

  /// No description provided for @listLoadingMore.
  ///
  /// In en, this message translates to:
  /// **'Loading more content...'**
  String get listLoadingMore;

  /// No description provided for @listNetworkErrorClickRetry.
  ///
  /// In en, this message translates to:
  /// **'Network exceptions thrown. Click to retry.'**
  String get listNetworkErrorClickRetry;

  /// No description provided for @listNoMoreToLoad.
  ///
  /// In en, this message translates to:
  /// **'Nothing left.'**
  String get listNoMoreToLoad;

  /// No description provided for @listRefreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get listRefreshing;

  /// No description provided for @listRefreshWaiting.
  ///
  /// In en, this message translates to:
  /// **'Pull down more to refresh'**
  String get listRefreshWaiting;

  /// No description provided for @listRefreshArmed.
  ///
  /// In en, this message translates to:
  /// **'Release to refresh'**
  String get listRefreshArmed;

  /// No description provided for @listRefreshSucceed.
  ///
  /// In en, this message translates to:
  /// **'Refreshed with new contents'**
  String get listRefreshSucceed;

  /// No description provided for @listRefreshFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to refresh'**
  String get listRefreshFailed;

  /// No description provided for @webViewTitle.
  ///
  /// In en, this message translates to:
  /// **'Web page'**
  String get webViewTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navPins.
  ///
  /// In en, this message translates to:
  /// **'Pins'**
  String get navPins;

  /// No description provided for @navMe.
  ///
  /// In en, this message translates to:
  /// **'Me'**
  String get navMe;

  /// No description provided for @actionLike.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get actionLike;

  /// No description provided for @actionComment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get actionComment;

  /// No description provided for @actionReply.
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get actionReply;

  /// No description provided for @actionMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get actionMore;

  /// No description provided for @actionFold.
  ///
  /// In en, this message translates to:
  /// **'Fold'**
  String get actionFold;

  /// No description provided for @actionCollect.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get actionCollect;

  /// No description provided for @actionShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get actionShare;

  /// No description provided for @advertiseAbbr.
  ///
  /// In en, this message translates to:
  /// **'Ad'**
  String get advertiseAbbr;

  /// No description provided for @articleViews.
  ///
  /// In en, this message translates to:
  /// **'{num} views'**
  String articleViews(int num);

  /// No description provided for @pinLiked.
  ///
  /// In en, this message translates to:
  /// **'and others liked'**
  String get pinLiked;

  /// No description provided for @pinHotCommentLikes.
  ///
  /// In en, this message translates to:
  /// **'{num} likes'**
  String pinHotCommentLikes(int num);

  /// No description provided for @pinTotalCommentCount.
  ///
  /// In en, this message translates to:
  /// **'Total comments {count}'**
  String pinTotalCommentCount(int count);

  /// No description provided for @userLikes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get userLikes;

  /// No description provided for @userFavorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get userFavorites;

  /// No description provided for @userFollows.
  ///
  /// In en, this message translates to:
  /// **'Follows'**
  String get userFollows;

  /// No description provided for @userComments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get userComments;

  /// No description provided for @userFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get userFollowing;

  /// No description provided for @userNotFollow.
  ///
  /// In en, this message translates to:
  /// **'Not follow'**
  String get userNotFollow;

  /// No description provided for @userSignInOrUp.
  ///
  /// In en, this message translates to:
  /// **'Sign in/Sign up'**
  String get userSignInOrUp;

  /// No description provided for @arrangement.
  ///
  /// In en, this message translates to:
  /// **'Sort By'**
  String get arrangement;

  /// No description provided for @recommend.
  ///
  /// In en, this message translates to:
  /// **'Hot'**
  String get recommend;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// No description provided for @join.
  ///
  /// In en, this message translates to:
  /// **'Join'**
  String get join;

  /// No description provided for @categoryTabFollowing.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get categoryTabFollowing;

  /// No description provided for @categoryTabRecommend.
  ///
  /// In en, this message translates to:
  /// **'Recommend'**
  String get categoryTabRecommend;

  /// No description provided for @tagAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get tagAll;

  /// No description provided for @sortRecommend.
  ///
  /// In en, this message translates to:
  /// **'Recommend'**
  String get sortRecommend;

  /// No description provided for @sortLatest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get sortLatest;

  /// No description provided for @durationYears.
  ///
  /// In en, this message translates to:
  /// **'{many, plural, =1{1 year}other{{many} years}} ago'**
  String durationYears(num many);

  /// No description provided for @durationMonths.
  ///
  /// In en, this message translates to:
  /// **'{many, plural, =1{1 month}other{{many} months}} ago'**
  String durationMonths(num many);

  /// No description provided for @durationDays.
  ///
  /// In en, this message translates to:
  /// **'{many, plural, =1{1 day}other{{many} days}} ago'**
  String durationDays(num many);

  /// No description provided for @durationHours.
  ///
  /// In en, this message translates to:
  /// **'{many, plural, =1{1 hour}other{{many} hours}} ago'**
  String durationHours(num many);

  /// No description provided for @durationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{many, plural, =0{Just now}=1{1 minute ago}other{{many} minutes ago}}'**
  String durationMinutes(num many);
}

class _JJLocalizationsDelegate extends LocalizationsDelegate<JJLocalizations> {
  const _JJLocalizationsDelegate();

  @override
  Future<JJLocalizations> load(Locale locale) {
    return SynchronousFuture<JJLocalizations>(lookupJJLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_JJLocalizationsDelegate old) => false;
}

JJLocalizations lookupJJLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return JJLocalizationsEn();
    case 'zh': return JJLocalizationsZh();
  }

  throw FlutterError(
    'JJLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
