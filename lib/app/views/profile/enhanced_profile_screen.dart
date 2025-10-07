import 'package:finder/app/models/enhanced_user_models.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:audio_waveforms/audio_waveforms.dart';

class EnhancedProfileScreen extends StatelessWidget {
  final String userId;

  const EnhancedProfileScreen({Key? key, required this.userId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final profileController = Get.find<ProfileController>();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Profile header with stories
          _buildProfileHeader(profileController),

          // Profile content
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Voice intro
                  _buildVoiceIntro(profileController),

                  SizedBox(height: 24.h),

                  // Interactive polls
                  _buildInteractivePolls(profileController),

                  SizedBox(height: 24.h),

                  // Interest tags
                  _buildInterestTags(profileController),

                  SizedBox(height: 24.h),

                  // Story highlights
                  _buildStoryHighlights(profileController),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContentSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileController controller) {
    return SliverAppBar(
      expandedHeight: 320.h,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Profile image
            Positioned.fill(
              child: Image.network('profile_image_url', fit: BoxFit.cover),
            ),

            // Stories overlay
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100.h,
                padding: EdgeInsets.symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  ),
                ),
                child: _buildStoriesRow(controller),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(60.h),
        child: Container(
          color: Theme.of(Get.context!).scaffoldBackgroundColor,
          padding: EdgeInsets.all(16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'John Doe, 28',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'New York City',
                    style: TextStyle(fontSize: 16.sp, color: Colors.grey),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _editProfile(),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () => _openSettings(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoriesRow(ProfileController controller) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      itemCount: controller.stories.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildAddStoryButton();
        }
        final story = controller.stories[index - 1];
        return _buildStoryThumbnail(story);
      },
    );
  }

  Widget _buildAddStoryButton() {
    return GestureDetector(
      onTap: () => _addNewStory(),
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildStoryThumbnail(UserStory story) {
    return GestureDetector(
      onTap: () => _viewStory(story),
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: story.viewedBy.contains(userId) ? Colors.grey : Colors.blue,
            width: 2,
          ),
        ),
        child: ClipOval(
          child: Image.network(story.mediaUrl, fit: BoxFit.cover),
        ),
      ),
    );
  }

  Widget _buildVoiceIntro(ProfileController controller) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Voice Intro',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            if (controller.hasVoiceIntro.value)
              AudioWaveforms(
                size: Size(double.infinity, 50.h),
                recorderController: controller.recorderController,
                enableGesture: true,
                backgroundColor: Colors.grey[200],
                waveStyle: const WaveStyle(
                  showMiddleLine: false,
                  extendWaveform: true,
                  waveColor: Colors.blue,
                ),
              )
            else
              Center(
                child: TextButton.icon(
                  onPressed: () => _recordVoiceIntro(),
                  icon: const Icon(Icons.mic),
                  label: const Text('Add Voice Intro'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInteractivePolls(ProfileController controller) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Quick Polls',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _createNewPoll(),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.polls.length,
              itemBuilder: (context, index) {
                final poll = controller.polls[index];
                return _buildPollItem(poll);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPollItem(Map<String, dynamic> poll) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            poll['question'],
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 8.h),
          ...List.generate(
            poll['options'].length,
            (index) => _buildPollOption(
              poll['options'][index],
              poll['votes'][index],
              poll['totalVotes'],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPollOption(String option, int votes, int totalVotes) {
    final percentage = totalVotes > 0 ? (votes / totalVotes * 100) : 0.0;

    return GestureDetector(
      onTap: () => _votePoll(option),
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        child: Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: Colors.grey[200],
                minHeight: 40.h,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(option),
                  Text('${percentage.toStringAsFixed(1)}%'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestTags(ProfileController controller) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Interests',
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: controller.interests.map((interest) {
                return Chip(
                  label: Text(interest),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  labelStyle: const TextStyle(color: Colors.blue),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryHighlights(ProfileController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Highlights',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 100.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.highlights.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddHighlightButton();
              }
              final highlight = controller.highlights[index - 1];
              return _buildHighlightThumbnail(highlight);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddHighlightButton() {
    return GestureDetector(
      onTap: () => _createNewHighlight(),
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 8.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey, width: 1),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHighlightThumbnail(Map<String, dynamic> highlight) {
    return GestureDetector(
      onTap: () => _viewHighlight(highlight),
      child: Container(
        width: 70.w,
        margin: EdgeInsets.only(right: 8.w),
        child: Column(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey, width: 1),
                image: DecorationImage(
                  image: NetworkImage(highlight['coverUrl']),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              highlight['title'],
              style: TextStyle(fontSize: 12.sp),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  void _showAddContentSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Add Story'),
              onTap: () {
                Get.back();
                _addNewStory();
              },
            ),
            ListTile(
              leading: const Icon(Icons.poll),
              title: const Text('Create Poll'),
              onTap: () {
                Get.back();
                _createNewPoll();
              },
            ),
            ListTile(
              leading: const Icon(Icons.mic),
              title: const Text('Record Voice Intro'),
              onTap: () {
                Get.back();
                _recordVoiceIntro();
              },
            ),
            ListTile(
              leading: const Icon(Icons.bookmark),
              title: const Text('Create Highlight'),
              onTap: () {
                Get.back();
                _createNewHighlight();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editProfile() {
    // Implement edit profile
  }

  void _openSettings() {
    // Implement settings
  }

  void _addNewStory() {
    // Implement add story
  }

  void _viewStory(UserStory story) {
    // Implement view story
  }

  void _recordVoiceIntro() {
    // Implement voice intro recording
  }

  void _createNewPoll() {
    // Implement poll creation
  }

  void _votePoll(String option) {
    // Implement poll voting
  }

  void _createNewHighlight() {
    // Implement highlight creation
  }

  void _viewHighlight(Map<String, dynamic> highlight) {
    // Implement view highlight
  }
}

class ProfileController extends GetxController {
  final recorderController = RecorderController();
  final RxBool hasVoiceIntro = false.obs;
  final RxList<UserStory> stories = <UserStory>[].obs;
  final RxList<Map<String, dynamic>> polls = <Map<String, dynamic>>[].obs;
  final RxList<String> interests = <String>[].obs;
  final RxList<Map<String, dynamic>> highlights = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    // Load profile data from API
  }
}
