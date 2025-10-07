import 'dart:math';

import 'package:finder/app/core/utils/app_images.dart';
import 'package:finder/app/models/notification_model.dart'
    show NotificationModel;
import 'package:finder/app/models/user_model.dart';

/// MockDataService provides realistic demo data for the dating app
///
/// This service generates consistent, realistic data that showcases
/// all app features effectively. It's designed to be easily replaceable
/// with real API services when implementing backend integration.
///
/// Features:
/// - Realistic user profiles with photos
/// - Diverse demographic representation
/// - Consistent relationship data (matches, messages, etc.)
/// - Configurable data generation
/// - Easy API service replacement
///
/// Usage:
/// ```dart
/// final users = MockDataService.getUsers();
/// final currentUser = MockDataService.getCurrentUser();
/// final matches = MockDataService.getMatches();
/// ```
class MockDataService {
  /// Private constructor to prevent instantiation
  MockDataService._();

  /// Random number generator for consistent data
  static final Random _random = Random(
    42,
  ); // Fixed seed for consistent demo data

  /// Demo user photos (in a real app, these would be from a CDN or API)
  static final List<String> _malePhotos = [
    AppImages.annetteBlack, // Placeholder - replace with actual male photos
    AppImages.eleanorPena, // Placeholder - replace with actual male photos
  ];

  static final List<String> _femalePhotos = [
    AppImages.annetteBlack,
    AppImages.eleanorPena,
  ];

  /// Sample first names
  static const List<String> _maleNames = [
    'James',
    'Michael',
    'David',
    'William',
    'Richard',
    'Joseph',
    'Thomas',
    'Christopher',
    'Charles',
    'Daniel',
    'Matthew',
    'Anthony',
    'Mark',
    'Donald',
    'Steven',
    'Paul',
    'Andrew',
    'Joshua',
    'Kenneth',
    'Kevin',
    'Brian',
    'George',
    'Timothy',
    'Ronald',
    'Jason',
    'Edward',
    'Jeffrey',
    'Ryan',
    'Jacob',
    'Gary',
    'Nicholas',
    'Eric',
    'Jonathan',
    'Stephen',
    'Larry',
    'Justin',
    'Scott',
    'Brandon',
    'Benjamin',
    'Samuel',
  ];

  static const List<String> _femaleNames = [
    'Mary',
    'Patricia',
    'Jennifer',
    'Linda',
    'Elizabeth',
    'Barbara',
    'Susan',
    'Jessica',
    'Sarah',
    'Karen',
    'Nancy',
    'Lisa',
    'Betty',
    'Helen',
    'Sandra',
    'Donna',
    'Carol',
    'Ruth',
    'Sharon',
    'Michelle',
    'Laura',
    'Sarah',
    'Kimberly',
    'Deborah',
    'Dorothy',
    'Lisa',
    'Nancy',
    'Karen',
    'Betty',
    'Helen',
    'Sandra',
    'Donna',
    'Carol',
    'Ruth',
    'Sharon',
    'Michelle',
    'Laura',
    'Emily',
    'Kimberly',
    'Deborah',
  ];

  /// Sample professions
  static const List<String> _professions = [
    'Software Engineer',
    'Marketing Manager',
    'Teacher',
    'Nurse',
    'Accountant',
    'Lawyer',
    'Designer',
    'Consultant',
    'Sales Manager',
    'Project Manager',
    'Data Analyst',
    'Product Manager',
    'Writer',
    'Photographer',
    'Chef',
    'Real Estate Agent',
    'Financial Advisor',
    'Therapist',
    'Engineer',
    'Doctor',
    'Artist',
    'Entrepreneur',
    'Student',
    'Researcher',
    'Architect',
  ];

  /// Sample education levels
  static const List<String> _educationLevels = [
    'High School',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'PhD',
    'Associate Degree',
    'Trade School',
    'Some College',
  ];

  /// Sample cities
  static const List<String> _cities = [
    'New York',
    'Los Angeles',
    'Chicago',
    'Houston',
    'Phoenix',
    'Philadelphia',
    'San Antonio',
    'San Diego',
    'Dallas',
    'San Jose',
    'Austin',
    'Jacksonville',
    'Fort Worth',
    'Columbus',
    'Charlotte',
    'San Francisco',
    'Indianapolis',
    'Seattle',
    'Denver',
    'Washington DC',
  ];

  /// Sample interests
  static const List<String> _interests = [
    'Travel',
    'Photography',
    'Cooking',
    'Hiking',
    'Reading',
    'Music',
    'Movies',
    'Fitness',
    'Yoga',
    'Dancing',
    'Art',
    'Gaming',
    'Sports',
    'Wine Tasting',
    'Coffee',
    'Technology',
    'Fashion',
    'Animals',
    'Volunteering',
    'Learning Languages',
    'Writing',
    'Meditation',
    'Running',
    'Cycling',
    'Swimming',
    'Camping',
  ];

  /// Sample bio templates
  static const List<String> _bioTemplates = [
    'Love exploring new places and trying different cuisines. Looking for someone to share adventures with! 🌟',
    'Passionate about fitness and healthy living. Coffee addict and dog lover. Let\'s grab a coffee? ☕',
    'Creative professional who loves art and music. Always up for a good conversation and new experiences.',
    'Outdoor enthusiast who enjoys hiking and camping. Netflix binge-watcher when it rains. 🏕️',
    'Foodie who loves cooking and trying new restaurants. Travel enthusiast with a bucket list! ✈️',
    'Bookworm by day, dancer by night. Love learning about different cultures and languages.',
    'Tech enthusiast who enjoys photography and exploring the city. Looking for genuine connections.',
    'Yoga instructor and meditation practitioner. Believe in mindful living and positive energy. 🧘‍♀️',
    'Entrepreneur with a passion for helping others. Love deep conversations over wine. 🍷',
    'Marine biologist who loves the ocean and marine life. Adventure seeker and nature lover. 🌊',
  ];

  /// Current user ID (for demo purposes)
  static const String currentUserId = 'current_user_123';

  /// Gets the current user profile
  static UserModel getCurrentUser() {
    return UserModel(
      id: currentUserId,
      name: 'Brooklyn Simmons',
      email: 'brooklyn.sim@example.com',
      age: 28,
      dateOfBirth: DateTime(1995, 5, 15),
      gender: 'Female',
      bio:
          'Creative professional who loves art and music. Always up for good conversation and new experiences. Travel enthusiast with a bucket list! ✈️',
      profession: 'UX Designer',
      education: 'Bachelor\'s Degree',
      hometown: 'Portland',
      currentCity: 'San Francisco',
      heightInCm: 168,
      bodyType: 'Athletic',
      ethnicity: 'Mixed',
      religion: 'Spiritual',
      drinkingStatus: 'Socially',
      smokingStatus: 'Never',
      interests: ['Travel', 'Photography', 'Art', 'Music', 'Hiking', 'Coffee'],
      languages: ['English', 'Spanish'],
      photoUrls: [AppImages.annetteBlack, AppImages.eleanorPena],
      profilePhotoUrl: AppImages.annetteBlack,
      latitude: 37.7749,
      longitude: -122.4194,
      locationName: 'San Francisco, CA',
      minAgePreference: 25,
      maxAgePreference: 35,
      maxDistanceKm: 50,
      genderPreferences: ['Male'],
      isOnline: true,
      lastActiveAt: DateTime.now(),
      isPremium: true,
      isVerified: true,
      likes: 156,
      matches: 23,
      profileViews: 89,
      isActive: true,
      isBlocked: false,
      createdAt: DateTime.now().subtract(const Duration(days: 180)),
      updatedAt: DateTime.now(),
    );
  }

  /// Generates a list of demo users
  static List<UserModel> getUsers({int count = 50}) {
    final users = <UserModel>[];

    for (int i = 0; i < count; i++) {
      users.add(_generateRandomUser(i));
    }

    return users;
  }

  /// Gets potential matches for the current user
  static List<UserModel> getMatches({int count = 20}) {
    final allUsers = getUsers(count: 100);
    final currentUser = getCurrentUser();

    // Filter users that match current user's preferences
    final potentialMatches = allUsers.where((user) {
      return user.id != currentUser.id && user.matchesPreferences(currentUser);
    }).toList();

    // Shuffle and return limited count
    potentialMatches.shuffle(_random);
    return potentialMatches.take(count).toList();
  }

  /// Gets users who have matched with the current user
  static List<UserModel> getConnectedMatches({int count = 10}) {
    final matches = getMatches(count: 30);
    matches.shuffle(_random);

    // Mark some as mutual matches
    return matches
        .take(count)
        .map(
          (user) => user.copyWith(
            // In a real app, this would be determined by backend logic
            lastActiveAt: DateTime.now().subtract(
              Duration(
                minutes: _random.nextInt(1440), // Last 24 hours
              ),
            ),
          ),
        )
        .toList();
  }

  /// Gets chat conversations for the current user
  static List<Map<String, dynamic>> getChatConversations() {
    final matches = getConnectedMatches(count: 8);

    return matches.map((user) {
      return {
        'user': user,
        'lastMessage': _generateRandomMessage(),
        'lastMessageTime': DateTime.now().subtract(
          Duration(
            hours: _random.nextInt(72), // Last 3 days
          ),
        ),
        'unreadCount': _random.nextInt(5),
        'isOnline': _random.nextBool(),
      };
    }).toList();
  }

  /// Gets comprehensive notification data
  static List<NotificationModel> getNotifications({int count = 15}) {
    final notifications = <NotificationModel>[];
    final users = getUsers(count: 20);
    users.shuffle(_random);

    final notificationTypes = [
      {
        'type': 'match',
        'title': 'New Match!',
        'message': 'You have a new match with {name}. Start chatting now!',
      },
      {
        'type': 'message',
        'title': 'New Message',
        'message': '{name} sent you a message.',
      },
      {
        'type': 'like',
        'title': 'Someone liked you!',
        'message': 'You received a new like from {name}.',
      },
      {
        'type': 'visit',
        'title': 'Profile Visit',
        'message': '{name} visited your profile.',
      },
      {
        'type': 'super_like',
        'title': 'Super Like!',
        'message': '{name} super liked you! They really want to connect.',
      },
    ];

    for (int i = 0; i < count; i++) {
      final notifType =
          notificationTypes[_random.nextInt(notificationTypes.length)];
      final user = users[_random.nextInt(users.length)];
      final isRecent = i < count * 0.3; // 30% recent notifications are unread

      notifications.add(
        NotificationModel(
          id: 'notif_$i',
          title: notifType['title']!,
          message: notifType['message']!.replaceAll('{name}', user.name),
          time: _formatTimeAgo(
            DateTime.now().subtract(
              Duration(
                hours: _random.nextInt(72) + (i * 2), // Distributed over time
              ),
            ),
          ),
          isRead: !isRecent || _random.nextBool(),
          type: notifType['type'],
          imageUrl: user.profilePhotoUrl,
          actionUrl: '/profile/${user.id}',
        ),
      );
    }

    // Sort by most recent first
    notifications.sort((a, b) => b.time.compareTo(a.time));

    return notifications;
  }

  /// Generates a random user
  static UserModel _generateRandomUser(int index) {
    final gender = _random.nextBool() ? 'Male' : 'Female';
    final names = gender == 'Male' ? _maleNames : _femaleNames;
    final photos = gender == 'Male' ? _malePhotos : _femalePhotos;
    final name = names[_random.nextInt(names.length)];
    final age = 18 + _random.nextInt(32); // Ages 18-50
    final city = _cities[_random.nextInt(_cities.length)];

    // Generate random interests (3-7 interests per user)
    final userInterests = <String>[];
    final interestCount = 3 + _random.nextInt(5);
    final shuffledInterests = [..._interests];
    shuffledInterests.shuffle(_random);
    userInterests.addAll(shuffledInterests.take(interestCount));

    return UserModel(
      id: 'user_$index',
      name: name,
      email: '${name.toLowerCase()}@example.com',
      age: age,
      dateOfBirth: DateTime.now().subtract(Duration(days: age * 365)),
      gender: gender,
      bio: _bioTemplates[_random.nextInt(_bioTemplates.length)],
      profession: _professions[_random.nextInt(_professions.length)],
      education: _educationLevels[_random.nextInt(_educationLevels.length)],
      hometown: _cities[_random.nextInt(_cities.length)],
      currentCity: city,
      heightInCm: gender == 'Male'
          ? 165 +
                _random.nextInt(25) // 165-190cm for males
          : 155 + _random.nextInt(20), // 155-175cm for females
      bodyType: ['Slim', 'Athletic', 'Average', 'Curvy'][_random.nextInt(4)],
      ethnicity: [
        'Asian',
        'Black',
        'Latino',
        'White',
        'Mixed',
        'Other',
      ][_random.nextInt(6)],
      religion: [
        'Christian',
        'Muslim',
        'Jewish',
        'Hindu',
        'Buddhist',
        'Spiritual',
        'Atheist',
        'Other',
      ][_random.nextInt(8)],
      drinkingStatus: [
        'Never',
        'Rarely',
        'Socially',
        'Regularly',
      ][_random.nextInt(4)],
      smokingStatus: [
        'Never',
        'Rarely',
        'Socially',
        'Regularly',
      ][_random.nextInt(4)],
      interests: userInterests,
      languages:
          [
                'English',
                'Spanish',
                'French',
                'German',
                'Italian',
              ][_random.nextInt(3) + 1] ==
              1
          ? ['English']
          : [
              'English',
              ['Spanish', 'French', 'German', 'Italian'][_random.nextInt(4)],
            ],
      photoUrls: [photos[_random.nextInt(photos.length)]],
      profilePhotoUrl: photos[_random.nextInt(photos.length)],
      latitude: 40.7128 + (_random.nextDouble() - 0.5) * 10, // Around NYC area
      longitude: -74.0060 + (_random.nextDouble() - 0.5) * 10,
      locationName:
          '$city, ${['NY', 'CA', 'TX', 'FL', 'IL'][_random.nextInt(5)]}',
      minAgePreference: age - 5 - _random.nextInt(5),
      maxAgePreference: age + 5 + _random.nextInt(5),
      maxDistanceKm: [25, 50, 75, 100][_random.nextInt(4)],
      genderPreferences: gender == 'Male' ? ['Female'] : ['Male'],
      isOnline: _random.nextDouble() < 0.3, // 30% online
      lastActiveAt: DateTime.now().subtract(
        Duration(
          minutes: _random.nextInt(10080), // Within last week
        ),
      ),
      isPremium: _random.nextDouble() < 0.2, // 20% premium
      isVerified: _random.nextDouble() < 0.4, // 40% verified
      likes: _random.nextInt(500),
      matches: _random.nextInt(100),
      profileViews: _random.nextInt(1000),
      isActive: true,
      isBlocked: false,
      createdAt: DateTime.now().subtract(
        Duration(
          days: _random.nextInt(365), // Account created within last year
        ),
      ),
      updatedAt: DateTime.now().subtract(
        Duration(
          hours: _random.nextInt(72), // Updated within last 3 days
        ),
      ),
    );
  }

  /// Generates a random message
  static String _generateRandomMessage() {
    final messages = [
      'Hey! How\'s your day going?',
      'I love your photos! Where was that taken?',
      'Thanks for the match! 😊',
      'Do you want to grab coffee sometime?',
      'I saw you like hiking too! Any favorite trails?',
      'Your profile is really interesting!',
      'What do you do for fun on weekends?',
      'I love your taste in music!',
      'Are you free this weekend?',
      'That restaurant looks amazing! Is it good?',
    ];

    return messages[_random.nextInt(messages.length)];
  }

  /// Formats time ago string
  static String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  /// Simulates API delay for realistic experience
  static Future<T> _simulateApiDelay<T>(T data) async {
    await Future.delayed(
      Duration(
        milliseconds: 500 + _random.nextInt(1000), // 0.5-1.5 second delay
      ),
    );
    return data;
  }

  /// Async methods that simulate API calls

  /// Simulates fetching user profile
  static Future<UserModel> fetchUserProfile(String userId) async {
    if (userId == currentUserId) {
      return _simulateApiDelay(getCurrentUser());
    }

    final users = getUsers(count: 100);
    final user = users.firstWhere(
      (u) => u.id == userId,
      orElse: () => _generateRandomUser(999),
    );

    return _simulateApiDelay(user);
  }

  /// Simulates fetching potential matches
  static Future<List<UserModel>> fetchMatches({
    int page = 1,
    int limit = 10,
  }) async {
    final allMatches = getMatches(count: 50);
    final startIndex = (page - 1) * limit;
    final endIndex = (startIndex + limit).clamp(0, allMatches.length);

    if (startIndex >= allMatches.length) {
      return _simulateApiDelay(<UserModel>[]);
    }

    return _simulateApiDelay(allMatches.sublist(startIndex, endIndex));
  }

  /// Simulates fetching chat conversations
  static Future<List<Map<String, dynamic>>> fetchChatConversations() async {
    return _simulateApiDelay(getChatConversations());
  }

  /// Simulates fetching notifications
  static Future<List<NotificationModel>> fetchNotifications({
    int page = 1,
    int limit = 10,
  }) async {
    final allNotifications = getNotifications(count: 50);
    final startIndex = (page - 1) * limit;
    final endIndex = (startIndex + limit).clamp(0, allNotifications.length);

    if (startIndex >= allNotifications.length) {
      return _simulateApiDelay(<NotificationModel>[]);
    }

    return _simulateApiDelay(allNotifications.sublist(startIndex, endIndex));
  }

  /// Simulates liking a user
  static Future<bool> likeUser(String userId) async {
    // Simulate like action with random match probability
    await _simulateApiDelay(true);
    return _random.nextDouble() < 0.3; // 30% chance of match
  }

  /// Simulates passing on a user
  static Future<void> passUser(String userId) async {
    await _simulateApiDelay(null);
  }

  /// Simulates sending a message
  static Future<void> sendMessage(String recipientId, String message) async {
    await _simulateApiDelay(null);
  }
}
