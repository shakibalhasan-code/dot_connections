import 'package:dot_connections/app/views/screens/initial/enable_notifications_view.dart';
import 'package:dot_connections/app/views/screens/initial/how_tall_view.dart';
import 'package:dot_connections/app/views/screens/initial/i_am_a_view.dart';
import 'package:dot_connections/app/views/screens/initial/initial_screen.dart';
import 'package:dot_connections/app/views/screens/initial/otp_view.dart';
import 'package:dot_connections/app/views/screens/initial/job_title_view.dart';
import 'package:dot_connections/app/views/screens/initial/passions_view.dart';
import 'package:dot_connections/app/views/screens/initial/preferences_view.dart';
import 'package:dot_connections/app/views/screens/initial/share_more_view.dart';
import 'package:dot_connections/app/views/screens/initial/where_live_view.dart';
import 'package:dot_connections/app/views/screens/initial/who_to_date_view.dart';
import 'package:dot_connections/app/views/screens/initial/workplace_view.dart';
import 'package:dot_connections/app/views/screens/initial/whats_dob_view.dart';
import 'package:dot_connections/app/views/screens/initial/whats_email_view.dart';
import 'package:dot_connections/app/views/screens/initial/whats_name_view.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../views/screens/initial/hometown_view.dart';

class AppRoutes {
  static String initial = '/initial';
  static String email = '/email';
  static String otp = '/otp';
  static String name = '/name';
  static String dob = '/dob';
  static String notifications = '/notifications';
  static String howTall = '/how-tall';
  static String whoToDate = '/who-to-date';
  static String iAmA = '/i-am-a';
  static String whereLive = '/where-live';
  static String shareMore = '/share-more';
  static String passions = '/passions';
  static String workplace = '/workplace';
  static String hometown = '/hometown';
  static String jobTitle = '/job-title';
  static String preferences = '/preferences';
  static String signIn = '/signIn';
  static String signUp = '/signUp';
  static String forget = '/forget';
  static String resetPass = '/resetPassword';

  static List<GetPage> pages = [
    GetPage(name: initial, page: () => const InitialScreen()),
    GetPage(name: email, page: () => const WhatsEmailView()),
    GetPage(name: otp, page: () => const OtpView()),
    GetPage(name: name, page: () => const WhatsNameView()),
    GetPage(name: dob, page: () => const WhatsDobView()),
    GetPage(name: notifications, page: () => const EnableNotificationsView()),
    GetPage(name: howTall, page: () => const HowTallView()),
    GetPage(name: whoToDate, page: () => const WhoToDateView()),
    GetPage(name: iAmA, page: () => const IAmAView()),
    GetPage(name: whereLive, page: () => const WhereLiveView()),
    GetPage(name: shareMore, page: () => const ShareMoreView()),
    GetPage(name: passions, page: () => const PassionsView()),
    GetPage(name: workplace, page: () => const WorkplaceView()),
    GetPage(name: hometown, page: () => const HometownView()),
    GetPage(name: jobTitle, page: () => const JobTitleView()),
    GetPage(name: preferences, page: () => const PreferencesView()),
  ];
}
