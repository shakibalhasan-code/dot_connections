import 'package:dot_connections/app/core/utils/app_bindings.dart';
import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 852),
      builder: (context, child) => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.parent,
        getPages: AppRoutes.pages,
        initialBinding: AppBindings(),
      ),
    );
  }
}
