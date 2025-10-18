import 'package:dot_connections/app/app.dart';
import 'package:dot_connections/app/controllers/auth_controller.dart';
import 'package:dot_connections/app/controllers/profile_contorller.dart';
import 'package:dot_connections/app/data/repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';

void main() async {
  // Load environment variables
  await dotenv.load();

  // Initialize Flutter bindings
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies early to ensure they're available
  // even before GetMaterialApp is created
  final authRepo = AuthRepository();
  Get.put(authRepo);

  // Initialize controllers
  final authController = AuthController(authRepository: authRepo);
  Get.put(authController);

  // Add profile controller
  Get.put(ProfileContorller());

  // Run the app
  runApp(const MyApp());
}
