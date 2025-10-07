import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finder/app/models/match_model.dart';

class ProfileCard extends StatelessWidget {
  final MatchProfile profile;
  final VoidCallback onTap;

  const ProfileCard({super.key, required this.profile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // GestureDetector detects taps on the card.
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 118.w, // Set a fixed width for the cards
        child: Card(
          clipBehavior: Clip
              .antiAlias, // Ensures the content is clipped to the rounded corners
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
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Icon(
                              Icons.female,
                              color: Colors.pink,
                              size: 20,
                            ),
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
                            const Icon(
                              Icons.location_on,
                              color: Colors.grey,
                              size: 16,
                            ),
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
                        color: Theme.of(
                          context,
                        ).colorScheme.scrim.withOpacity(0.1),
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
