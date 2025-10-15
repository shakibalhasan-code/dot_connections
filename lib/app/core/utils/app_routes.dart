import 'package:dot_connections/app/core/middleware/auth_middleware.dart';
import 'package:dot_connections/app/views/screens/initial/add_bio_view.dart';
import 'package:dot_connections/app/views/screens/initial/drink_status_view.dart';
import 'package:dot_connections/app/views/screens/initial/education_view.dart';
import 'package:dot_connections/app/views/screens/initial/enable_notifications_view.dart';
import 'package:dot_connections/app/views/screens/initial/how_tall_view.dart';
import 'package:dot_connections/app/views/screens/initial/i_am_a_view.dart';
import 'package:dot_connections/app/views/screens/initial/initial_screen.dart';
import 'package:dot_connections/app/views/screens/auth/otp_view.dart';
import 'package:dot_connections/app/views/screens/initial/job_title_view.dart';
import 'package:dot_connections/app/views/screens/initial/interests_view.dart';
import 'package:dot_connections/app/views/screens/initial/preferences_view.dart';
import 'package:dot_connections/app/views/screens/initial/religious_view.dart';
import 'package:dot_connections/app/views/screens/initial/share_more_view.dart';
import 'package:dot_connections/app/views/screens/initial/smoking_status_view.dart';
import 'package:dot_connections/app/views/screens/initial/welcome_view.dart';
import 'package:dot_connections/app/views/screens/initial/where_live_view.dart';
import 'package:dot_connections/app/views/screens/initial/who_to_date_view.dart';
import 'package:dot_connections/app/views/screens/initial/workplace_view.dart';
import 'package:dot_connections/app/views/screens/initial/whats_dob_view.dart';
import 'package:dot_connections/app/views/screens/initial/whats_email_view.dart';
import 'package:dot_connections/app/views/screens/initial/whats_name_view.dart';
import 'package:dot_connections/app/views/screens/splash/splash_screen.dart';
import 'package:dot_connections/app/views/screens/parent/chat/conversation_screen.dart';
import 'package:dot_connections/app/views/screens/parent/parent_screen.dart';
import 'package:dot_connections/app/views/screens/parent/profile/sub_screens/accounts/account_manage_screen.dart';
import 'package:dot_connections/app/views/screens/parent/profile/sub_screens/accounts/update_full_name_view.dart';
import 'package:dot_connections/app/views/screens/parent/profile/sub_screens/accounts/update_phone_view.dart';
import 'package:dot_connections/app/views/screens/parent/profile/sub_screens/blocked_users/blocked_user_screen.dart';
import 'package:dot_connections/app/views/screens/parent/profile/sub_screens/personal_details/personal_details_screen.dart';
import 'package:dot_connections/app/views/screens/parent/profile/sub_screens/photo_gallery/photo_gallery_screen.dart';
import 'package:dot_connections/app/views/screens/parent/profile/sub_screens/subscription/subscription_screen.dart';
import 'package:dot_connections/app/views/screens/parent/profile/sub_screens/terms_condition_screen.dart';
import 'package:get/get_navigation/get_navigation.dart';

import '../../views/screens/initial/hometown_view.dart';
import '../../views/screens/parent/notification/notification_screen.dart'
    show NotificationScreen;

class AppRoutes {
  static String splash = '/splash';
  static String initial = '/initial';
  static String email = '/email';
  static String otp = '/otp';
  static String name = '/name';
  static String dob = '/dob';
  static String enableNotifications = '/enableNotifications';
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
  static String education = '/education';
  static String religious = '/religious';
  static String drinkStatus = '/drink-status';
  static String smokingStatus = '/smoking-status';
  static String addBio = '/add-bio';
  static String welcome = '/welcome';
  static String parent = '/parent';
  static String signIn = '/signIn';
  static String signUp = '/signUp';
  static String forget = '/forget';
  static String resetPass = '/resetPassword';
  static String conversation = '/conversation';
  static String accountDetails = '/accountDetails';
  static String editFullName = '/editFullName';
  static String updatePhoneView = '/updatePhoneView';
  static String personalDetails = '/personalDetails';
  static String photoGallery = '/photoGallery';
  static String blockedUser = '/blockedUser';
  static String subscription = '/subscription';
  static String termCondition = '/termCondition';
  static String notification = '/notification';

  static final AuthMiddleware authMiddleware = AuthMiddleware();

  static List<GetPage> pages = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: initial, page: () => const InitialScreen()),
    GetPage(name: email, page: () => const WhatsEmailView()),
    GetPage(name: otp, page: () => const OtpView()),

    // User info pages - require authentication
    GetPage(
      name: name,
      page: () => const WhatsNameView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: dob,
      page: () => const WhatsDobView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: enableNotifications,
      page: () => const EnableNotificationsView(),
      middlewares: [authMiddleware],
    ),

    // Profile setup pages - require authentication
    GetPage(
      name: howTall,
      page: () => const HowTallView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: whoToDate,
      page: () => const WhoToDateView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: iAmA,
      page: () => const IAmAView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: whereLive,
      page: () => const WhereLiveView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: shareMore,
      page: () => const ShareMoreView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: passions,
      page: () => const InterestsView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: workplace,
      page: () => const WorkplaceView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: hometown,
      page: () => const HometownView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: jobTitle,
      page: () => const JobTitleView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: preferences,
      page: () => const PreferencesView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: education,
      page: () => const EducationView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: religious,
      page: () => const ReligiousView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: drinkStatus,
      page: () => const DrinkStatusView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: smokingStatus,
      page: () => const SmokingStatusView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: addBio,
      page: () => const AddBioView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: welcome,
      page: () => const WelcomeView(),
      middlewares: [authMiddleware],
    ),

    // Main app pages - require authentication
    GetPage(
      name: parent,
      page: () => const ParentScreen(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: conversation,
      page: () => ConversationScreen(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: accountDetails,
      page: () => const AccountManageScreen(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: editFullName,
      page: () => const UpdateFullNameView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: updatePhoneView,
      page: () => const UpdatePhoneView(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: personalDetails,
      page: () => const PersonalDetailsScreen(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: photoGallery,
      page: () => const PhotoGalleryScreen(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: blockedUser,
      page: () => const BlockedUserScreen(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: subscription,
      page: () => const SubscriptionScreen(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: termCondition,
      page: () => const TermsConditionScreen(),
      middlewares: [authMiddleware],
    ),
    GetPage(
      name: notification,
      page: () => const NotificationScreen(),
      middlewares: [authMiddleware],
    ),
  ];
}
