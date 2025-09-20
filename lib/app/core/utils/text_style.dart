import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle {
  static TextStyle primaryTextStyle({
    double fontSize = 16,
    FontWeight fontWeight = FontWeight.normal,
    Color? color,
    BuildContext? context,
  }) {
    // If context is provided, use theme colors, otherwise fallback to color parameter or black
    Color textColor = color ?? Colors.black;
    if (context != null && color == null) {
      textColor = Theme.of(context).colorScheme.onSurface;
    }

    return GoogleFonts.montserrat(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: textColor,
    );
  }
}
