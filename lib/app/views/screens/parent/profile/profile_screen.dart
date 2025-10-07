import '../../../../controllers/profile_contorller.dart';
import '../../../../controllers/language_controller.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_routes.dart';
import '../../../../core/utils/text_style.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/utils/app_icons.dart';
import 'package:get/get.dart' hide Trans;

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final LanguageController languageController =
        Get.find<LanguageController>();

    return GetBuilder<ProfileContorller>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            leading: const SizedBox(),
            elevation: 0,
            centerTitle: true,
            title: Obx(() {
              // Make title reactive to language changes
              languageController.currentLanguage;
              return Text(
                'profile'.tr(),
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
              );
            }),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 120.r,
                  width: 120.r,
                  child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primaryColor.withOpacity(0.5),
                            width: 4,
                          ),
                        ),
                        child: CircleAvatar(
                          backgroundImage: AssetImage(AppImages.annetteBlack),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: -10,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(50.r),
                          onTap: () => controller.pickImage(),
                          child: Container(
                            height: 40.r,
                            width: 40.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryColor,
                              border: Border.all(width: 2, color: Colors.white),
                            ),
                            child: Center(
                              child: SvgPicture.asset(
                                AppIcons.penIcon,
                                height: 20.r,
                                width: 20.r,
                                colorFilter: const ColorFilter.mode(
                                  Colors.white,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  "Brooklyn Simmons",
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "brooklyn.sim@example.com",
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 40.h),
                ProfileMenu(
                  icon: AppIcons.accountsIcon,
                  text: 'account_settings'.tr(),
                  press: () => Get.toNamed(AppRoutes.accountDetails),
                ),
                ProfileMenu(
                  icon: AppIcons.personalData,
                  text: 'personal_data'.tr(),
                  press: () => Get.toNamed(AppRoutes.personalDetails),
                ),
                ProfileMenu(
                  icon: AppIcons.photoGallery,
                  text: 'photo_gallery'.tr(),
                  press: () => Get.toNamed(AppRoutes.photoGallery),
                ),
                ProfileMenu(
                  icon: AppIcons.blockedIcon,
                  text: 'blocked_users'.tr(),
                  press: () => Get.toNamed(AppRoutes.blockedUser),
                ),
                ProfileMenu(
                  icon: AppIcons.subscriptionIcon,
                  text: 'subscription'.tr(),
                  press: () => Get.toNamed(AppRoutes.subscription),
                ),
                ProfileMenu(
                  icon: AppIcons.infoIcon, // Using an existing icon for now
                  text: 'language'.tr(),
                  press: () => _showLanguageBottomSheet(context),
                ),
                ProfileMenu(
                  icon: AppIcons.termsConditionIcon,
                  text: 'terms_and_conditions'.tr(),
                  press: () => Get.toNamed(AppRoutes.termCondition),
                ),
                ProfileMenu(
                  icon: AppIcons.infoIcon,
                  text: 'about'.tr(),
                  press: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              'language'.tr(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 16.h),
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.5,
                ),
                child: GetBuilder<LanguageController>(
                  builder: (controller) => ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.supportedLanguages.length,
                    itemBuilder: (context, index) {
                      final languageCode = controller.supportedLanguages[index];
                      final languageName = controller.getLanguageName(
                        languageCode,
                      );
                      final languageFlag = controller.getLanguageFlag(
                        languageCode,
                      );
                      final isSelected =
                          languageCode == controller.currentLanguage;

                      return ListTile(
                        leading: Text(
                          languageFlag,
                          style: TextStyle(fontSize: 24.sp),
                        ),
                        title: Text(
                          languageName,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check,
                                color: theme.colorScheme.primary,
                              )
                            : null,
                        onTap: () {
                          _changeLanguage(context, languageCode, languageName);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  /// Change app language and update GetX locale
  void _changeLanguage(
    BuildContext context,
    String languageCode,
    String languageName,
  ) {
    final languageController = Get.find<LanguageController>();

    // Use the language controller to change language
    languageController.changeLanguage(languageCode);

    // Close the bottom sheet
    Navigator.pop(context);
  }
}

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({
    super.key,
    required this.text,
    required this.icon,
    this.press,
  });

  final String text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(foregroundColor: AppColors.primaryColor),
      onPressed: press,
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            colorFilter: ColorFilter.mode(
              AppColors.primaryTransparent,
              BlendMode.srcIn,
            ),
            width: 22.w,
          ),
          SizedBox(width: 20.w),
          Expanded(
            child: Text(
              text,
              style: AppTextStyle.primaryTextStyle(color: AppColors.textColor),
            ),
          ),
          const Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
