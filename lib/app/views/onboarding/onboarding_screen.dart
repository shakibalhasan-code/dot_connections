import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/core/theme/app_theme.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    final RxInt currentPage = 0.obs;

    final pages = [
      OnboardingPage(
        title: 'Welcome to Finder',
        subtitle:
            'Discover meaningful connections through intelligent matching',
        animation: 'assets/raw/welcome.json',
      ),
      OnboardingPage(
        title: 'Smart Matching',
        subtitle:
            'Our AI helps you find people who share your interests and values',
        animation: 'assets/raw/matching.json',
      ),
      OnboardingPage(
        title: 'Express Yourself',
        subtitle:
            'Share your story through photos, voice intros, and interactive polls',
        animation: 'assets/raw/expression.json',
      ),
      OnboardingPage(
        title: 'Start Your Journey',
        subtitle: 'Join our community and find meaningful connections',
        animation: 'assets/raw/journey.json',
        isLast: true,
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(gradient: AppTheme.primaryGradient),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Skip button
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => Get.offNamed('/auth'),
                    child: Text(
                      'Skip',
                      style: TextStyle(color: Colors.white, fontSize: 16.sp),
                    ),
                  ),
                ),

                // Page view
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: pages.length,
                    onPageChanged: (index) => currentPage.value = index,
                    itemBuilder: (context, index) => pages[index],
                  ),
                ),

                // Page indicator
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      pages.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: EdgeInsets.symmetric(horizontal: 4.w),
                        height: 8.h,
                        width: currentPage.value == index ? 24.w : 8.w,
                        decoration: BoxDecoration(
                          color: currentPage.value == index
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32.h),

                // Next/Get Started button
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Obx(
                    () => ElevatedButton(
                      onPressed: () {
                        if (currentPage.value < pages.length - 1) {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          Get.offNamed('/auth');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).primaryColor,
                        minimumSize: Size(double.infinity, 56.h),
                      ),
                      child: Text(
                        currentPage.value == pages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String animation;
  final bool isLast;

  const OnboardingPage({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.animation,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animation, height: 300.h, repeat: !isLast),
          SizedBox(height: 32.h),
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 28.sp,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 16.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
