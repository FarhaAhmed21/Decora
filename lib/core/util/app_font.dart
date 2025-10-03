import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppFont {
  static  TextStyle fontStyle(
    { required FontWeight fontWeight,
    required double fontsize,
    required Color color,}
  ) {
    return GoogleFonts.montserrat(
      fontSize: fontsize,
      fontWeight: fontWeight,
      color: color,
    );
  }
}
