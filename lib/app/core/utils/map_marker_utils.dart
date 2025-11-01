import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:dot_connections/app/core/constants/api_endpoints.dart';

class MapMarkerUtils {
  /// Create a custom marker with user profile picture
  static Future<BitmapDescriptor> createProfileMarker({
    required String? profilePictureUrl,
    required String initials,
    required bool isConnected,
    int size = 120,
  }) async {
    try {
      // Load profile image or create placeholder
      ui.Image? profileImage;

      if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
        // Construct full URL if the profilePictureUrl is a relative path
        String fullUrl = profilePictureUrl;
        if (profilePictureUrl.startsWith('/')) {
          fullUrl = '${ApiEndpoints.rootUrl}$profilePictureUrl';
        }

        try {
          // Add timeout to prevent hanging
          final response = await http
              .get(Uri.parse(fullUrl))
              .timeout(const Duration(seconds: 5));

          if (response.statusCode == 200 && response.bodyBytes.isNotEmpty) {
            final Uint8List imageBytes = response.bodyBytes;
            final ui.Codec codec = await ui.instantiateImageCodec(
              imageBytes,
              targetWidth: size - 20, // Leave space for border
              targetHeight: size - 20,
            );
            final ui.FrameInfo frameInfo = await codec.getNextFrame();
            profileImage = frameInfo.image;
          }
        } catch (e) {
          print('Error loading profile image from $fullUrl: $e');
          // Will use placeholder instead
        }
      }

      // Create the marker with profile image or placeholder
      return await _drawCustomMarker(
        profileImage: profileImage,
        initials: initials,
        isConnected: isConnected,
        size: size,
      );
    } catch (e) {
      print('Error creating profile marker: $e');
      // Return default marker as fallback
      return isConnected
          ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
          : BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    }
  }

  static Future<BitmapDescriptor> _drawCustomMarker({
    ui.Image? profileImage,
    required String initials,
    required bool isConnected,
    required int size,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final double centerX = size / 2;
    final double centerY = size / 2;
    final double radius = (size - 10) / 2;

    // Draw outer border (connection status indicator)
    final Paint borderPaint = Paint()
      ..color = isConnected ? Colors.green : Colors.blue
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, centerY), radius + 5, borderPaint);

    // Draw white inner circle
    final Paint backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(centerX, centerY), radius, backgroundPaint);

    if (profileImage != null) {
      // Draw profile image
      final Rect srcRect = Rect.fromLTWH(
        0,
        0,
        profileImage.width.toDouble(),
        profileImage.height.toDouble(),
      );
      final Rect dstRect = Rect.fromCircle(
        center: Offset(centerX, centerY),
        radius: radius - 3,
      );

      // Create circular clip
      final Path clipPath = Path()
        ..addOval(
          Rect.fromCircle(center: Offset(centerX, centerY), radius: radius - 3),
        );
      canvas.clipPath(clipPath);

      canvas.drawImageRect(profileImage, srcRect, dstRect, Paint());
    } else {
      // Draw placeholder with initials
      final Paint placeholderPaint = Paint()
        ..color = Colors.grey[300]!
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(centerX, centerY), radius - 3, placeholderPaint);

      // Draw initials
      final TextStyle textStyle = TextStyle(
        color: Colors.grey[600],
        fontSize: size * 0.3,
        fontWeight: FontWeight.bold,
      );

      final TextSpan textSpan = TextSpan(text: initials, style: textStyle);

      final TextPainter textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();

      final double textX = centerX - (textPainter.width / 2);
      final double textY = centerY - (textPainter.height / 2);

      textPainter.paint(canvas, Offset(textX, textY));
    }

    // Convert to image
    final ui.Picture picture = pictureRecorder.endRecording();
    final ui.Image image = await picture.toImage(size, size);
    final ByteData? byteData = await image.toByteData(
      format: ui.ImageByteFormat.png,
    );

    if (byteData != null) {
      return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
    } else {
      throw Exception('Failed to convert marker to bytes');
    }
  }

  /// Get initials from user name
  static String getInitials(String name) {
    if (name.isEmpty) return 'U';

    final List<String> nameParts = name.trim().split(' ');
    if (nameParts.length == 1) {
      return nameParts[0][0].toUpperCase();
    } else {
      return (nameParts[0][0] + nameParts[nameParts.length - 1][0])
          .toUpperCase();
    }
  }

  /// Create current location marker
  static Future<BitmapDescriptor> createCurrentLocationMarker({
    int size = 100,
  }) async {
    try {
      final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
      final Canvas canvas = Canvas(pictureRecorder);
      final double centerX = size / 2;
      final double centerY = size / 2;
      final double radius = (size - 10) / 2;

      // Draw outer red circle
      final Paint outerPaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(centerX, centerY), radius, outerPaint);

      // Draw inner white circle
      final Paint innerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(centerX, centerY), radius - 8, innerPaint);

      // Draw center red dot
      final Paint centerPaint = Paint()
        ..color = Colors.red
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(centerX, centerY), radius - 20, centerPaint);

      // Convert to image
      final ui.Picture picture = pictureRecorder.endRecording();
      final ui.Image image = await picture.toImage(size, size);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
      } else {
        throw Exception('Failed to convert current location marker to bytes');
      }
    } catch (e) {
      print('Error creating current location marker: $e');
      return BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    }
  }
}
