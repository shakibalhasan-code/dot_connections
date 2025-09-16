import 'package:dot_connections/app/controllers/match_controller.dart';
import 'package:dot_connections/app/core/utils/app_images.dart';
import 'package:dot_connections/app/models/match_model.dart';
import 'package:dot_connections/app/views/screens/parent/match/widgets/match_profile_details.dart';
import 'package:dot_connections/app/views/screens/parent/match/widgets/profile_card_widget.dart' show ProfileCard;
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

// A data model for our match profiles to keep the code clean.

class MatchScreen extends StatelessWidget {
  const MatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MatchController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Match List'),
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: SizedBox(),
            foregroundColor: Colors.black,
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            // Wrap is used to lay out the children in a flexible way.
            // It will automatically wrap to the next line if there's not enough space.
            child: Wrap(
              spacing: 5.0, // Horizontal space between cards
              runSpacing: 5.0, // Vertical space between cards
              children: List.generate(controller.matches.length, (index) {
                return ProfileCard(
                  profile: controller.matches[index],
                  // Pass the function to be called on tap.
                  onTap: () => controller.onCardTapped(index, context),
                );
              }),
            ),
          ),
        );
      },
    );
  }
}


