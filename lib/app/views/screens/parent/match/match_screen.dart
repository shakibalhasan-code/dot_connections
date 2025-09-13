import 'package:dot_connections/app/core/utils/app_images.dart';
import 'package:dot_connections/app/views/screens/parent/match/widgets/match_profile_details.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:flutter_screenutil/flutter_screenutil.dart';

// A data model for our match profiles to keep the code clean.
class MatchProfile {
  final String name;
  final int age;
  final double distance;
  final String imageUrl;
  bool isBlurred;

  MatchProfile({
    required this.name,
    required this.age,
    required this.distance,
    required this.imageUrl,
    this.isBlurred = true, // Initially, all profiles are blurred.
  });
}

class MatchScreen extends StatefulWidget {
  const MatchScreen({super.key});

  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  // A list to hold our dummy data for the profiles.
  final List<MatchProfile> matches = List.generate(
    6,
    (index) => MatchProfile(
      name: 'Lana',
      age: 26,
      distance: 0.5,
      // Using a placeholder image from the web.
      // Replace with your own image assets if you have them.
      imageUrl: AppImages.eleanorPena,
    ),
  );

  // This function will be called when a card is tapped.
  // It will toggle the blur state for the tapped card.
  void _onCardTapped(int index) {
    setState(() {
      matches[index].isBlurred = !matches[index].isBlurred;
    });
    showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ProfileDialog();
                },
              );
  }

  @override
  Widget build(BuildContext context) {
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
          children: List.generate(matches.length, (index) {
            return ProfileCard(
              profile: matches[index],
              // Pass the function to be called on tap.
              onTap: () => _onCardTapped(index),
            );
          }),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  final MatchProfile profile;
  final VoidCallback onTap;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // GestureDetector detects taps on the card.
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 118.w, // Set a fixed width for the cards
        child: Card(
          clipBehavior: Clip.antiAlias, // Ensures the content is clipped to the rounded corners
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 0,
          child: Stack(
            children: [
              // This is the main content of the card (Image and Text).
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    profile.imageUrl,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${profile.name} ',
                              style:  TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(Icons.female, color: Colors.pink, size: 20),
                            // Text(
                            //   ' (${profile.age})',
                            //   style:  TextStyle(
                            //     fontSize: 16.sp,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, color: Colors.grey, size: 16),
                            Text(
                              ' ${profile.distance} mi.',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // This is the blur effect that is conditionally displayed.
              if (profile.isBlurred)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        color: Colors.black.withOpacity(0.1),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}