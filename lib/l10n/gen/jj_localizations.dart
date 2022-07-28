
import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'jj_localizations_en.dart';
import 'jj_localizations_zh.dart';

/// Callers can lookup localized strings with an instance of JJLocalizations returned
/// by `JJLocalizations.of(context)`.
///
/// Applications need to include `JJLocalizations.delegate()` in their app's
/// localizationDelegates list, and the locales they support in the app's
/// supportedLocales list. For example:
///
/// ```
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
/// ```
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # rest of dependencies
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

  /// No description provided for @exceptionError.
  ///
  /// In en, this message translates to:
  /// **'error'**
  String get exceptionError;

  /// No description provided for @exceptionFailed.
  ///
  /// In en, this message translates to:
  /// **'failed'**
  String get exceptionFailed;

  /// No description provided for @exceptionErrorWidget.
  ///
  /// In en, this message translates to:
  /// **'Exception thrown during building this widget...'**
  String get exceptionErrorWidget;

  /// No description provided for @exceptionRouteNotFound.
  ///
  /// In en, this message translates to:
  /// **' route not found。'**
  String get exceptionRouteNotFound;

  /// No description provided for @exceptionRouteUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get exceptionRouteUnknown;

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

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @hots.
  ///
  /// In en, this message translates to:
  /// **'Hots'**
  String get hots;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// No description provided for @like.
  ///
  /// In en, this message translates to:
  /// **'Like'**
  String get like;

  /// No description provided for @comment.
  ///
  /// In en, this message translates to:
  /// **'Comment'**
  String get comment;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @unfollow.
  ///
  /// In en, this message translates to:
  /// **'Follow'**
  String get unfollow;

  /// No description provided for @ads.
  ///
  /// In en, this message translates to:
  /// **'Ads'**
  String get ads;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'See more'**
  String get readMore;

  /// No description provided for @hotsLikeCounts.
  ///
  /// In en, this message translates to:
  /// **'people likes'**
  String get hotsLikeCounts;

  /// No description provided for @postLikeCounts.
  ///
  /// In en, this message translates to:
  /// **'and others liked'**
  String get postLikeCounts;

  /// No description provided for @views.
  ///
  /// In en, this message translates to:
  /// **'views'**
  String get views;

  /// No description provided for @years.
  ///
  /// In en, this message translates to:
  /// **'year'**
  String get years;

  /// No description provided for @months.
  ///
  /// In en, this message translates to:
  /// **'month'**
  String get months;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'day'**
  String get days;

  /// No description provided for @hours.
  ///
  /// In en, this message translates to:
  /// **'hour'**
  String get hours;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'minute'**
  String get minutes;

  /// No description provided for @ago.
  ///
  /// In en, this message translates to:
  /// **'ago'**
  String get ago;
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
