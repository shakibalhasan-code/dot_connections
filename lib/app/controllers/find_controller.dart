import 'package:dot_connections/app/core/helper/widget_helper.dart';
import 'package:dot_connections/app/data/models/user_model.dart';
import 'package:dot_connections/app/data/models/user_profile_model.dart';
import 'package:dot_connections/app/data/repo/match_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';

class FindController extends GetxController {
  final matchRepo = Get.find<MatchRepo>();

  // List of UserProfile models
  var cardList = <UserModel>[].obs; // make it observable

  ///varibales
  RxInt activeProfile = 0.obs;
  RxInt activeProfileImage = 0.obs;

  ///>>>Controllers<<<<<<
  final cardSwipeController = CardSwiperController();
  final pageviewProfileImage = PageController();

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> fetchProfiles() async {
    try {
      final profiles = await matchRepo.fetchMatches();
      cardList.assignAll(profiles);
    } catch (e) {
      debugPrint('Error fetching profiles: $e');
      WidgetHelper.showToast(
        message: 'Error fetching profiles',
        status: Status.failed,
        toastContext: Get.context!,
      );
    } finally {
      Get.back(); // Close loading dialog
    }
    update();
  }

  //// Do the action when card swipe
  void cardSwipe({
    required int currentIndex,
    required int previousIndex,
    required CardSwiperDirection direction,
  }) {
    // Add haptic feedback
    HapticFeedback.lightImpact();

    activeProfile.value = currentIndex;
    update();
    if (direction == CardSwiperDirection.left) {
      ///set the default active image value
      activeProfileImage.value = 0;

      // TODO: ACTION WHEN USER SWIPE PROFILE TO THE LEFT
      WidgetHelper.showToast(
        message: 'swipe left',
        status: Status.success,
        toastContext: Get.context!,
      );
    } else if (direction == CardSwiperDirection.right) {
      ///set the default active image value
      activeProfileImage.value = 0;

      // TODO: ACTION WHEN USER SWIPE PROFILE TO THE right
      WidgetHelper.showToast(
        message: 'swipe right',
        status: Status.warning,
        toastContext: Get.context!,
      );
    }
  }

  //user ingore profile action's logic
  void swipeByActions(CardSwiperDirection direction) async {
    // Add haptic feedback
    HapticFeedback.mediumImpact();

    ///set the default active image value
    activeProfileImage.value = 0;
    debugPrint('>>>>>>>>>>>>ignore button clicked');
    cardSwipeController.swipe(direction);
    update();
  }

  /// change the current image
  void onProfileImageChanged(int index) {
    activeProfileImage.value = index;
    update();
  }

  // void increaseImageIndex() {
  //   if (activeProfileImage.value <
  //       cardList[activeProfile.value].images.length - 1) {
  //     activeProfileImage.value++;
  //     pageviewProfileImage.animateToPage(
  //       activeProfileImage.value,
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeIn,
  //     );
  //     update();
  //   }
  // }

  // void decreaseImageIndex() {
  //   if (activeProfileImage.value > 0) {
  //     activeProfileImage.value--;
  //     pageviewProfileImage.animateToPage(
  //       activeProfileImage.value,
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeIn,
  //     );
  //     update();
  //   }
  // }
}
