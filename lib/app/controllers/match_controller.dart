import 'package:dot_connections/app/core/utils/app_images.dart';
import 'package:dot_connections/app/models/match_model.dart';
import 'package:dot_connections/app/views/screens/parent/match/widgets/match_profile_details.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MatchController extends GetxController {

  final List<MatchProfile> matches = List.generate(
    6,
    (index) => MatchProfile(
      name: 'Lana',
      age: 26,
      distance: 0.5,
      imageUrl: AppImages.eleanorPena,
    ),
  );

  

  void onCardTapped(int index, BuildContext context) {
    matches[index].isBlurred = !matches[index].isBlurred;
    showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ProfileDialog();
                },
              );
  }


}