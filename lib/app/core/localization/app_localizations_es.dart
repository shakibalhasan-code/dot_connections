import 'app_localizations.dart';

/// The translations for Spanish (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  // Common UI strings
  @override
  String get appName => 'Conexiones Verdaderas';

  @override
  String get welcome => 'Bienvenido';

  @override
  String get hello => 'Hola';

  @override
  String get getStarted => 'Comenzar';

  @override
  String get next => 'Siguiente';

  @override
  String get back => 'Atrás';

  @override
  String get skip => 'Omitir';

  @override
  String get done => 'Listo';

  @override
  String get cancel => 'Cancelar';

  @override
  String get ok => 'OK';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get search => 'Buscar';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Reintentar';

  @override
  String get noData => 'No hay datos disponibles';

  // Authentication
  @override
  String get signIn => 'Iniciar Sesión';

  @override
  String get signUp => 'Registrarse';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get enterEmail => 'Ingresa tu correo electrónico';

  @override
  String get enterPassword => 'Ingresa tu contraseña';

  @override
  String get invalidEmail => 'Por favor ingresa un correo válido';

  @override
  String get weakPassword => 'La contraseña es muy débil';

  @override
  String get passwordMismatch => 'Las contraseñas no coinciden';

  // Dating App Specific
  @override
  String get findPeople => 'Encontrar Personas';

  @override
  String get map => 'Mapa';

  @override
  String get chat => 'Chat';

  @override
  String get matches => 'Coincidencias';

  @override
  String get profile => 'Perfil';

  @override
  String get swipeLeft => 'Desliza izquierda para pasar';

  @override
  String get swipeRight => 'Desliza derecha para dar me gusta';

  @override
  String get like => 'Me gusta';

  @override
  String get pass => 'Pasar';

  @override
  String get superLike => 'Super Me Gusta';

  @override
  String get itsAMatch => '¡Es una coincidencia!';

  @override
  String get sendMessage => 'Enviar Mensaje';

  @override
  String get typeMessage => 'Escribe un mensaje...';

  @override
  String get recording => 'Grabando...';

  @override
  String get audioRecorded => 'Audio grabado';

  @override
  String get tapSend => 'Toca para enviar';

  @override
  String get online => 'En línea';

  @override
  String get offline => 'Desconectado';

  @override
  String get lastSeen => 'Visto por última vez';

  @override
  String get ago => 'hace';

  @override
  String get milesAway => 'millas de distancia';

  @override
  String get kmAway => 'km de distancia';

  // Profile
  @override
  String get editProfile => 'Editar Perfil';

  @override
  String get addPhotos => 'Agregar Fotos';

  @override
  String get aboutMe => 'Acerca de Mí';

  @override
  String get interests => 'Intereses';

  @override
  String get jobTitle => 'Título del Trabajo';

  @override
  String get education => 'Educación';

  @override
  String get height => 'Altura';

  @override
  String get age => 'Edad';

  @override
  String get location => 'Ubicación';

  @override
  String get preferences => 'Preferencias';

  @override
  String get lookingFor => 'Buscando';

  @override
  String get ageRange => 'Rango de Edad';

  @override
  String get maxDistance => 'Distancia Máxima';

  // Settings
  @override
  String get settings => 'Configuración';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get privacy => 'Privacidad';

  @override
  String get security => 'Seguridad';

  @override
  String get help => 'Ayuda';

  @override
  String get about => 'Acerca de';

  @override
  String get logout => 'Cerrar Sesión';

  @override
  String get deleteAccount => 'Eliminar Cuenta';

  @override
  String get language => 'Idioma';

  @override
  String get theme => 'Tema';

  @override
  String get lightTheme => 'Claro';

  @override
  String get darkTheme => 'Oscuro';

  @override
  String get systemTheme => 'Sistema';

  // Notifications
  @override
  String get newMatch => '¡Tienes una nueva coincidencia!';

  @override
  String get newMessage => 'Nuevo mensaje recibido';

  @override
  String get someoneLikedYou => 'Alguien te dio me gusta';

  @override
  String get markAsRead => 'Marcar como Leído';

  @override
  String get markAllAsRead => 'Marcar Todo como Leído';

  @override
  String get noNotifications => 'Sin notificaciones';

  // Errors and validations
  @override
  String get connectionError => 'Error de conexión. Verifica tu internet.';

  @override
  String get serverError => 'Error del servidor. Inténtalo más tarde.';

  @override
  String get unknownError => 'Algo salió mal. Inténtalo de nuevo.';

  @override
  String get fieldRequired => 'Este campo es requerido';

  @override
  String get nameRequired => 'El nombre es requerido';

  @override
  String get emailRequired => 'El correo es requerido';

  @override
  String get passwordRequired => 'La contraseña es requerida';

  @override
  String get photoRequired => 'Por favor agrega al menos una foto';

  @override
  String get locationRequired => 'Se requiere acceso a la ubicación';

  // Success messages
  @override
  String get profileUpdated => 'Perfil actualizado exitosamente';

  @override
  String get photoUploaded => 'Foto subida exitosamente';

  @override
  String get messageSent => 'Mensaje enviado';

  @override
  String get matchFound => '¡Coincidencia encontrada!';

  @override
  String get settingsSaved => 'Configuración guardada exitosamente';

  // Accessibility
  @override
  String get profileImageButton => 'Imagen de perfil';

  @override
  String get likeButton => 'Me gusta';

  @override
  String get passButton => 'Pasar';

  @override
  String get superLikeButton => 'Super me gusta';

  @override
  String get backButton => 'Regresar';

  @override
  String get menuButton => 'Menú';

  @override
  String get closeButton => 'Cerrar';

  @override
  String get playButton => 'Reproducir';

  @override
  String get pauseButton => 'Pausar';

  @override
  String get recordButton => 'Grabar';

  @override
  String get sendButton => 'Enviar';

  @override
  String get imageButton => 'Imagen';

  // Accessibility descriptions
  @override
  String get profileImageHint => 'Toca para ver imagen de perfil';

  @override
  String get likeButtonHint => 'Doble toque para dar me gusta a esta persona';

  @override
  String get passButtonHint => 'Doble toque para pasar a esta persona';

  @override
  String get superLikeButtonHint => 'Doble toque para super me gusta a esta persona';

  @override
  String get recordingHint => 'Grabando mensaje de audio';

  @override
  String get playingAudioHint => 'Reproduciendo mensaje de audio';

  @override
  String get imageMessageHint => 'Mensaje de imagen';
}