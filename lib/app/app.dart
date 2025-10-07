import 'core/utils/app_bindings.dart';
import 'core/utils/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'controllers/language_controller.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 852),
      minTextAdapt: true,
      // Split screen support for tablets
      splitScreenMode: true,
      builder: (context, child) {
        // Make the entire GetMaterialApp reactive to language changes
        return GetBuilder<LanguageController>(
          // Use a unique tag to avoid conflicts
          tag: 'main_app',
          init: Get.put(LanguageController()),
          builder: (languageController) {
            return GetMaterialApp(
              // App configuration
              title: 'Dot Connections',
              debugShowCheckedModeBanner: false,

              // Easy Localization configuration - key for proper rebuilding
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,

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
              useInheritedMediaQuery: false,
            );
          },
        );
      },
    );
  }
}
