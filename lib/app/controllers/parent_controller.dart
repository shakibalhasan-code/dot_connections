import 'package:dot_connections/app/views/screens/parent/chat/chat_screen.dart';
import 'package:dot_connections/app/views/screens/parent/find/find_screen.dart';
import 'package:dot_connections/app/views/screens/parent/map/map_screen.dart';
import 'package:dot_connections/app/views/screens/parent/match/match_screen.dart';
import 'package:dot_connections/app/views/screens/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ParentController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentIndex = 0.obs;

  final List<Widget> pages = [
    const FindScreen(),
    const MapScreen(),
    const ChatScreen(),
    const MatchScreen(),
    const ProfileScreen(),
  ];

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void onTabTapped(int index) {
    currentIndex.value = index;
    pageController.jumpToPage(index);
  }
}