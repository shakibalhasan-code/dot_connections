import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  // Common UI strings
  @override
  String get appName => 'Dot Connections';

  @override
  String get welcome => 'Welcome';

  @override
  String get hello => 'Hello';

  @override
  String get getStarted => 'Get Started';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get skip => 'Skip';

  @override
  String get done => 'Done';

  @override
  String get cancel => 'Cancel';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get search => 'Search';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get noData => 'No data available';

  // Authentication
  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get enterEmail => 'Enter your email';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get invalidEmail => 'Please enter a valid email';

  @override
  String get weakPassword => 'Password is too weak';

  @override
  String get passwordMismatch => 'Passwords do not match';

  // Dating App Specific
  @override
  String get findPeople => 'Find People';

  @override
  String get map => 'Map';

  @override
  String get chat => 'Chat';

  @override
  String get matches => 'Matches';

  @override
  String get profile => 'Profile';

  @override
  String get swipeLeft => 'Swipe left to pass';

  @override
  String get swipeRight => 'Swipe right to like';

  @override
  String get like => 'Like';

  @override
  String get pass => 'Pass';

  @override
  String get superLike => 'Super Like';

  @override
  String get itsAMatch => 'It\'s a Match!';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get typeMessage => 'Type a message...';

  @override
  String get recording => 'Recording...';

  @override
  String get audioRecorded => 'Audio recorded';

  @override
  String get tapSend => 'Tap to send';

  @override
  String get online => 'Online';

  @override
  String get offline => 'Offline';

  @override
  String get lastSeen => 'Last seen';

  @override
  String get ago => 'ago';

  @override
  String get milesAway => 'miles away';

  @override
  String get kmAway => 'km away';

  // Profile
  @override
  String get editProfile => 'Edit Profile';

  @override
  String get addPhotos => 'Add Photos';

  @override
  String get aboutMe => 'About Me';

  @override
  String get interests => 'Interests';

  @override
  String get jobTitle => 'Job Title';

  @override
  String get education => 'Education';

  @override
  String get height => 'Height';

  @override
  String get age => 'Age';

  @override
  String get location => 'Location';

  @override
  String get preferences => 'Preferences';

  @override
  String get lookingFor => 'Looking For';

  @override
  String get ageRange => 'Age Range';

  @override
  String get maxDistance => 'Maximum Distance';

  // Settings
  @override
  String get settings => 'Settings';

  @override
  String get notifications => 'Notifications';

  @override
  String get privacy => 'Privacy';

  @override
  String get security => 'Security';

  @override
  String get help => 'Help';

  @override
  String get about => 'About';

  @override
  String get logout => 'Logout';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  // Notifications
  @override
  String get newMatch => 'You have a new match!';

  @override
  String get newMessage => 'New message received';

  @override
  String get someoneLikedYou => 'Someone liked you';

  @override
  String get markAsRead => 'Mark as Read';

  @override
  String get markAllAsRead => 'Mark All as Read';

  @override
  String get noNotifications => 'No notifications';

  // Errors and validations
  @override
  String get connectionError => 'Connection error. Please check your internet.';

  @override
  String get serverError => 'Server error. Please try again later.';

  @override
  String get unknownError => 'Something went wrong. Please try again.';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get photoRequired => 'Please add at least one photo';

  @override
  String get locationRequired => 'Location access is required';

  // Success messages
  @override
  String get profileUpdated => 'Profile updated successfully';

  @override
  String get photoUploaded => 'Photo uploaded successfully';

  @override
  String get messageSent => 'Message sent';

  @override
  String get matchFound => 'Match found!';

  @override
  String get settingsSaved => 'Settings saved successfully';

  // Accessibility
  @override
  String get profileImageButton => 'Profile image';

  @override
  String get likeButton => 'Like';

  @override
  String get passButton => 'Pass';

  @override
  String get superLikeButton => 'Super like';

  @override
  String get backButton => 'Go back';

  @override
  String get menuButton => 'Menu';

  @override
  String get closeButton => 'Close';

  @override
  String get playButton => 'Play';

  @override
  String get pauseButton => 'Pause';

  @override
  String get recordButton => 'Record';

  @override
  String get sendButton => 'Send';

  @override
  String get imageButton => 'Image';

  // Accessibility descriptions
  @override
  String get profileImageHint => 'Tap to view profile image';

  @override
  String get likeButtonHint => 'Double tap to like this person';

  @override
  String get passButtonHint => 'Double tap to pass on this person';

  @override
  String get superLikeButtonHint => 'Double tap to super like this person';

  @override
  String get recordingHint => 'Recording audio message';

  @override
  String get playingAudioHint => 'Playing audio message';

  @override
  String get imageMessageHint => 'Image message';
}
