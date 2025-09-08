import 'package:dot_connections/app/core/utils/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(392.w, 852.h),
      builder: (context, child) =>
          GetMaterialApp(
            initialRoute: AppRoutes.initial,

             
            
            
            ),
    );
  }
}
