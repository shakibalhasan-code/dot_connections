/// Simple localization service for basic multi-language support
///
/// This service provides a foundation for internationalization that can be
/// easily extended. It includes common strings used throughout the dating app
/// and provides a clean interface for accessing localized content.
///
/// Usage:
/// ```dart
/// Text(LocalizationService.instance.getText('hello'))
/// ```
class LocalizationService {
  static LocalizationService? _instance;
  static LocalizationService get instance =>
      _instance ??= LocalizationService._();

  LocalizationService._();

  String _currentLanguage = 'en';

  String get currentLanguage => _currentLanguage;

  void changeLanguage(String languageCode) {
    if (_supportedLanguages.containsKey(languageCode)) {
      _currentLanguage = languageCode;
    }
  }

  List<String> get supportedLanguages => _supportedLanguages.keys.toList();

  String getLanguageName(String code) => _supportedLanguages[code] ?? 'Unknown';

  static const Map<String, String> _supportedLanguages = {
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'it': 'Italiano',
    'pt': 'Português',
    'ru': 'Русский',
    'ar': 'العربية',
    'zh': '中文',
    'ja': '日本語',
    'ko': '한국어',
    'hi': 'हिन्दी',
  };

  String getText(String key) {
    return _translations[_currentLanguage]?[key] ??
        _translations['en']?[key] ??
        key;
  }

  static const Map<String, Map<String, String>> _translations = {
    'en': {
      // App basics
      'app_name': 'Dot Connections',
      'welcome': 'Welcome',
      'hello': 'Hello',
      'get_started': 'Get Started',
      'next': 'Next',
      'back': 'Back',
      'skip': 'Skip',
      'done': 'Done',
      'cancel': 'Cancel',
      'ok': 'OK',
      'yes': 'Yes',
      'no': 'No',
      'save': 'Save',
      'delete': 'Delete',
      'edit': 'Edit',
      'search': 'Search',
      'loading': 'Loading...',
      'error': 'Error',
      'retry': 'Retry',
      'no_data': 'No data available',

      // Authentication
      'sign_in': 'Sign In',
      'sign_up': 'Sign Up',
      'forgot_password': 'Forgot Password?',
      'email': 'Email',
      'password': 'Password',
      'confirm_password': 'Confirm Password',
      'enter_email': 'Enter your email',
      'enter_password': 'Enter your password',
      'invalid_email': 'Invalid email address',
      'weak_password': 'Password is too weak',
      'password_mismatch': 'Passwords do not match',

      // Dating App Main Features
      'find_people': 'Discover',
      'map': 'Map',
      'chat': 'Chat',
      'matches': 'Matches',
      'profile': 'Profile',
      'swipe_left': 'Pass',
      'swipe_right': 'Like',
      'like': 'Like',
      'pass': 'Pass',
      'super_like': 'Super Like',
      'its_a_match': "It's a Match!",
      'send_message': 'Send Message',
      'type_message': 'Type a message',
      'recording': 'Recording...',
      'audio_recorded': 'Audio recorded - tap send',
      'tap_send': 'Tap to send',
      'online': 'Online',
      'offline': 'Offline',
      'last_seen': 'Last seen',
      'ago': 'ago',
      'miles_away': 'miles away',
      'km_away': 'km away',

      // Profile
      'edit_profile': 'Edit Profile',
      'add_photos': 'Add Photos',
      'about_me': 'About Me',
      'interests': 'Interests',
      'job_title': 'Job Title',
      'education': 'Education',
      'height': 'Height',
      'age': 'Age',
      'location': 'Location',
      'preferences': 'Preferences',
      'looking_for': 'Looking For',
      'age_range': 'Age Range',
      'max_distance': 'Maximum Distance',

      // Settings
      'settings': 'Settings',
      'notifications': 'Notifications',
      'privacy': 'Privacy',
      'security': 'Security',
      'help': 'Help & Support',
      'about': 'About',
      'logout': 'Log Out',
      'delete_account': 'Delete Account',
      'language': 'Language',
      'theme': 'Theme',
      'light_theme': 'Light',
      'dark_theme': 'Dark',
      'system_theme': 'System Default',

      // Notifications
      'new_match': 'New Match!',
      'new_message': 'New Message',
      'someone_liked_you': 'Someone liked you!',
      'mark_as_read': 'Mark as Read',
      'mark_all_as_read': 'Mark All as Read',
      'no_notifications': 'No notifications yet',

      // Errors and Validations
      'connection_error': 'Connection error. Please try again.',
      'server_error': 'Server error. Please try again later.',
      'unknown_error': 'Something went wrong. Please try again.',
      'field_required': 'This field is required',
      'name_required': 'Name is required',
      'email_required': 'Email is required',
      'password_required': 'Password is required',
      'photo_required': 'At least one photo is required',
      'location_required': 'Location access is required',

      // Success Messages
      'profile_updated': 'Profile updated successfully',
      'photo_uploaded': 'Photo uploaded successfully',
      'message_sent': 'Message sent',
      'match_found': 'You have a new match!',
      'settings_saved': 'Settings saved successfully',

      // Accessibility Labels
      'profile_image_button': 'Profile image',
      'like_button': 'Like this person',
      'pass_button': 'Pass on this person',
      'super_like_button': 'Super like this person',
      'back_button': 'Go back',
      'menu_button': 'Open menu',
      'close_button': 'Close',
      'play_button': 'Play audio',
      'pause_button': 'Pause audio',
      'record_button': 'Record voice message',
      'send_button': 'Send message',
      'image_button': 'Send image',

      // Accessibility Descriptions
      'profile_image_hint': 'Double tap to view full profile',
      'like_button_hint': 'Double tap to like this person',
      'pass_button_hint': 'Double tap to pass on this person',
      'super_like_button_hint': 'Double tap to super like this person',
      'recording_hint': 'Currently recording audio message',
      'playing_audio_hint': 'Playing audio message',
      'image_message_hint': 'Image message',
    },

    'es': {
      // App basics
      'app_name': 'Dot Connections',
      'welcome': 'Bienvenido',
      'hello': 'Hola',
      'get_started': 'Comenzar',
      'next': 'Siguiente',
      'back': 'Atrás',
      'skip': 'Saltar',
      'done': 'Hecho',
      'cancel': 'Cancelar',
      'ok': 'OK',
      'yes': 'Sí',
      'no': 'No',
      'save': 'Guardar',
      'delete': 'Eliminar',
      'edit': 'Editar',
      'search': 'Buscar',
      'loading': 'Cargando...',
      'error': 'Error',
      'retry': 'Reintentar',
      'no_data': 'No hay datos disponibles',

      // Authentication
      'sign_in': 'Iniciar Sesión',
      'sign_up': 'Registrarse',
      'forgot_password': '¿Olvidaste tu contraseña?',
      'email': 'Correo electrónico',
      'password': 'Contraseña',
      'confirm_password': 'Confirmar contraseña',
      'enter_email': 'Ingresa tu correo electrónico',
      'enter_password': 'Ingresa tu contraseña',
      'invalid_email': 'Correo electrónico inválido',
      'weak_password': 'La contraseña es muy débil',
      'password_mismatch': 'Las contraseñas no coinciden',

      // Dating App Main Features
      'find_people': 'Descubrir',
      'map': 'Mapa',
      'chat': 'Chat',
      'matches': 'Coincidencias',
      'profile': 'Perfil',
      'swipe_left': 'Pasar',
      'swipe_right': 'Me gusta',
      'like': 'Me gusta',
      'pass': 'Pasar',
      'super_like': 'Super Like',
      'its_a_match': '¡Es una coincidencia!',
      'send_message': 'Enviar mensaje',
      'type_message': 'Escribe un mensaje',
      'recording': 'Grabando...',
      'audio_recorded': 'Audio grabado - toca para enviar',
      'tap_send': 'Toca para enviar',
      'online': 'En línea',
      'offline': 'Desconectado',
      'last_seen': 'Última vez visto',
      'ago': 'hace',
      'miles_away': 'millas de distancia',
      'km_away': 'km de distancia',

      // Add more Spanish translations as needed...
      'profile_image_button': 'Imagen de perfil',
      'like_button': 'Me gusta esta persona',
      'pass_button': 'Pasar de esta persona',
      'super_like_button': 'Super like a esta persona',
      'back_button': 'Volver',
      'menu_button': 'Abrir menú',
      'close_button': 'Cerrar',
      'play_button': 'Reproducir audio',
      'pause_button': 'Pausar audio',
      'record_button': 'Grabar mensaje de voz',
      'send_button': 'Enviar mensaje',
      'image_button': 'Enviar imagen',
    },
  };
}
