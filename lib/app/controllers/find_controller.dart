import 'package:dot_connections/app/core/helper/widget_helper.dart';
import 'package:dot_connections/app/core/services/find_api_serverces.dart'
    show FindApiServices;
import 'package:dot_connections/app/data/models/user_model.dart';
import 'package:dot_connections/app/data/models/user_profile_model.dart';
import 'package:dot_connections/app/data/repo/match_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';

class FindController extends GetxController {
  final matchRepo = Get.put(MatchRepo());

  // List of UserProfile models
  var cardList = <UserModel>[].obs; // make it observable

  ///varibales
  RxInt activeProfile = 0.obs;
  RxInt activeProfileImage = 0.obs;

  ///>>>Controllers<<<<<<
  final cardSwipeController = CardSwiperController();
  final pageviewProfileImage = PageController();

  final _findApiServices = Get.put(FindApiServices());

  @override
  void onInit() async {
    super.onInit();
    await fetchProfiles();
  }

  Future<void> fetchProfiles() async {
    // Show loading dialog
    try {
      // Clear current list
      cardList.clear();

      // Fetch new profiles
      final profiles = await matchRepo.fetchMatches();

      // Check if any valid profiles were returned
      if (profiles.isNotEmpty) {
        // Filter out profiles with missing required data
        final validProfiles = profiles
            .where(
              (profile) => profile.id.isNotEmpty && profile.name.isNotEmpty,
            )
            .toList();

        if (validProfiles.isNotEmpty) {
          cardList.assignAll(validProfiles);
          // Reset active profile index to 0 when new profiles are loaded
          activeProfile.value = 0;
          activeProfileImage.value = 0;
          debugPrint(
            'Successfully loaded ${validProfiles.length} valid profiles',
          );
        } else {
          debugPrint('No valid profiles returned from the API');
          WidgetHelper.showToast(
            message: 'No valid profiles found',
            status: Status.warning,
            toastContext: Get.context!,
          );
        }
      } else {
        debugPrint('No profiles returned from the API');
        WidgetHelper.showToast(
          message: 'No profiles found',
          status: Status.warning,
          toastContext: Get.context!,
        );
      }
    } catch (e) {
      debugPrint('Error fetching profiles: $e');
      WidgetHelper.showToast(
        message: 'Error fetching profiles',
        status: Status.failed,
        toastContext: Get.context!,
      );
    } finally {
      // Make sure loading dialog is closed
      if (Get.isDialogOpen ?? false) {
        Get.back(); // Close loading dialog
      }
    }
    update();
  }

  //// Do the action when card swipe
  void cardSwipe({
    required int currentIndex,
    required int previousIndex,
    required CardSwiperDirection direction,
  }) {
    // Validate indices to prevent out of bounds access
    if (previousIndex < 0 || previousIndex >= cardList.length) {
      debugPrint(
        'Invalid previousIndex: $previousIndex, cardList length: ${cardList.length}',
      );
      return;
    }

    if (currentIndex < 0 || currentIndex > cardList.length) {
      debugPrint(
        'Invalid currentIndex: $currentIndex, cardList length: ${cardList.length}',
      );
      return;
    }

    // Add haptic feedback
    HapticFeedback.lightImpact();

    activeProfile.value = currentIndex;

    ///set the default active image value
    activeProfileImage.value = 0;

    update();

    if (direction == CardSwiperDirection.left) {
      final toUserId = cardList[previousIndex].id;
      final isLiked = false;
      _findApiServices.swipeActions(
        toUserId: toUserId,
        isLiked: isLiked,
        profileName: cardList[previousIndex].name,
      );

      // TODO: ACTION WHEN USER SWIPE PROFILE TO THE LEFT
    } else if (direction == CardSwiperDirection.right) {
      // TODO: ACTION WHEN USER SWIPE PROFILE TO THE right
      final toUserId = cardList[previousIndex].id;
      final isLiked = true;
      _findApiServices.swipeActions(
        toUserId: toUserId,
        isLiked: isLiked,
        profileName: cardList[previousIndex].name,
      );
    }
  }

  //user ignore profile action's logic
  void swipeByActions(CardSwiperDirection direction) {
    // Check if there are cards to swipe
    if (cardList.isEmpty) {
      debugPrint('No cards available to swipe');
      return;
    }

    // Add haptic feedback
    HapticFeedback.mediumImpact();

    ///set the default active image value
    activeProfileImage.value = 0;
    debugPrint('>>>>>>>>>>>>Action button clicked for direction: $direction');

    // Schedule the swipe operation to happen after the current frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cardSwipeController.swipe(direction);
      update();
    });
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
