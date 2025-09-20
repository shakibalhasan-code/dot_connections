import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

/// Callers can lookup localized strings with Localizations.of<AppLocalizations>(context).
///
/// This class provides the main interface for accessing localized strings
/// throughout the application. It supports multiple languages and provides
/// a fallback mechanism to English if a translation is missing.
///
/// To use this class:
/// ```dart
/// Text(AppLocalizations.of(context)!.hello)
/// ```
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  // Common UI strings
  String get appName;
  String get welcome;
  String get hello;
  String get getStarted;
  String get next;
  String get back;
  String get skip;
  String get done;
  String get cancel;
  String get ok;
  String get yes;
  String get no;
  String get save;
  String get delete;
  String get edit;
  String get search;
  String get loading;
  String get error;
  String get retry;
  String get noData;

  // Authentication
  String get signIn;
  String get signUp;
  String get forgotPassword;
  String get email;
  String get password;
  String get confirmPassword;
  String get enterEmail;
  String get enterPassword;
  String get invalidEmail;
  String get weakPassword;
  String get passwordMismatch;

  // Dating App Specific
  String get findPeople;
  String get map;
  String get chat;
  String get matches;
  String get profile;
  String get swipeLeft;
  String get swipeRight;
  String get like;
  String get pass;
  String get superLike;
  String get itsAMatch;
  String get sendMessage;
  String get typeMessage;
  String get recording;
  String get audioRecorded;
  String get tapSend;
  String get online;
  String get offline;
  String get lastSeen;
  String get ago;
  String get milesAway;
  String get kmAway;

  // Profile
  String get editProfile;
  String get addPhotos;
  String get aboutMe;
  String get interests;
  String get jobTitle;
  String get education;
  String get height;
  String get age;
  String get location;
  String get preferences;
  String get lookingFor;
  String get ageRange;
  String get maxDistance;

  // Settings
  String get settings;
  String get notifications;
  String get privacy;
  String get security;
  String get help;
  String get about;
  String get logout;
  String get deleteAccount;
  String get language;
  String get theme;
  String get lightTheme;
  String get darkTheme;
  String get systemTheme;

  // Notifications
  String get newMatch;
  String get newMessage;
  String get someoneLikedYou;
  String get markAsRead;
  String get markAllAsRead;
  String get noNotifications;

  // Errors and validations
  String get connectionError;
  String get serverError;
  String get unknownError;
  String get fieldRequired;
  String get nameRequired;
  String get emailRequired;
  String get passwordRequired;
  String get photoRequired;
  String get locationRequired;

  // Success messages
  String get profileUpdated;
  String get photoUploaded;
  String get messageSent;
  String get matchFound;
  String get settingsSaved;

  // Accessibility
  String get profileImageButton;
  String get likeButton;
  String get passButton;
  String get superLikeButton;
  String get backButton;
  String get menuButton;
  String get closeButton;
  String get playButton;
  String get pauseButton;
  String get recordButton;
  String get sendButton;
  String get imageButton;

  // Accessibility descriptions
  String get profileImageHint;
  String get likeButtonHint;
  String get passButtonHint;
  String get superLikeButtonHint;
  String get recordingHint;
  String get playingAudioHint;
  String get imageMessageHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue on GitHub with a '
    'reproducible sample app and the gen-l10n configuration that was used.',
  );
}
