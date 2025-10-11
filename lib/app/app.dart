import 'package:dot_connections/app/core/utils/app_bindings.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:dot_connections/app/core/theme/app_theme.dart';
import 'package:dot_connections/app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 852),

      // Enable text scaling adaptation
      minTextAdapt: true,

      // Split screen support for tablets
      splitScreenMode: true,

      builder: (context, child) {
        return GetMaterialApp(
          // App configuration
          title: 'Dot Connections',
          debugShowCheckedModeBanner: false,

          // Localization configuration
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'), // Default locale
          fallbackLocale: const Locale('en'),

          // Theme configuration
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,
          // Route configuration
          initialRoute: AppRoutes.initial,
          getPages: AppRoutes.pages,
          // Global bindings
          initialBinding: AppBindings(),

          // Global app settings
          defaultTransition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 300),

          // Error handling
          unknownRoute: GetPage(
            name: '/unknown',
            page: () =>
                const Scaffold(body: Center(child: Text('Page not found'))),
          ),

          // Performance optimizations
          enableLog: false, // Disable in production
          logWriterCallback: (text, {isError = false}) {},
        );
      },
    );
  }
}
