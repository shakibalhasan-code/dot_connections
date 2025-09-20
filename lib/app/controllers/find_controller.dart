import 'package:dot_connections/app/core/helper/widget_helper.dart';
import 'package:dot_connections/app/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:get/get.dart';

class FindController extends GetxController {
  // List of UserProfile models
  var cardList = <UserProfile>[
    UserProfile(
      images: [
        'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg',
        'https://images.pexels.com/photos/1181690/pexels-photo-1181690.jpeg',
        'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg',
        'https://images.pexels.com/photos/1181690/pexels-photo-1181690.jpeg',
      ],
      name: 'John Neha',
      age: 25,
      interested: ['Online shopping', 'Amateur cook', 'Anime'],
      distance: '0.5 mi. away from you',
    ),
    UserProfile(
      images: [
        'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg',
        'https://images.pexels.com/photos/1181690/pexels-photo-1181690.jpeg',
      ],
      name: 'Neha Johni',
      age: 25,
      interested: ['Online shopping', 'Amateur cook', 'Anime'],
      distance: '0.5 mi. away from you',
    ),
    UserProfile(
      images: [
        'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg',
        'https://images.pexels.com/photos/1181690/pexels-photo-1181690.jpeg',
      ],
      name: 'Rakiba Jogn',
      age: 25,
      interested: ['Online shopping', 'Amateur cook', 'Anime'],
      distance: '0.5 mi. away from you',
    ),
    UserProfile(
      images: [
        'https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg',
        'https://images.pexels.com/photos/1181690/pexels-photo-1181690.jpeg',
      ],
      name: 'Rifa Haque',
      age: 25,
      interested: ['Online shopping', 'Amateur cook', 'Anime'],
      distance: '0.5 mi. away from you',
    ),
  ].obs; // make it observable

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

  //// Do the action when card swipe
  void cardSwipe({
    required int currentIndex,
    required int previousIndex,
    required CardSwiperDirection direction,
  }) {
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
