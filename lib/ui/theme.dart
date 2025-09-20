import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



// أضف هذه الألوان في ملف theme.dart
const Color bluishClr =Colors.grey;
const Color yellowClr = Color(0xFFFFB746)   ;
const Color pinkClr = Colors.cyan;
const Color white = Colors.white;
const Color primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);

class Themes {
  static final light = ThemeData(
    primaryColor: Colors.blue,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(backgroundColor: Colors.white54),
  );

  static final dark = ThemeData(
    primaryColor: Colors.grey[900],
    brightness: Brightness.dark,
    appBarTheme: AppBarTheme(backgroundColor: Colors.grey[900]),
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.normal
    )
  );
}



TextStyle get headingStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.bold
    )
  );
}


TextStyle get titleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400
    )
  );
}


TextStyle get subTitleStyle {
  return GoogleFonts.lato(
    textStyle: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400
    )
  );
}
