import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final TextTheme _googleFontRobotoTheme = GoogleFonts.robotoTextTheme();
final OutlinedButtonThemeData _outlinedButtonTheme = OutlinedButtonThemeData(
  style: OutlinedButton.styleFrom(
    side: BorderSide(
      color: Color(0xFF0095F6)
    )
  )
);


class AppThemeData  {
  final ThemeData _lightThemeData = ThemeData(
    colorScheme: ColorScheme.fromSeed(
    seedColor: Color(0xFF0095F6)
  ),
   textTheme: _googleFontRobotoTheme,
   outlinedButtonTheme: _outlinedButtonTheme,
  );


final ThemeData _darkThemeData = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    brightness: Brightness.dark,
    seedColor: Color(0x334155)
  ),
  textTheme: _googleFontRobotoTheme,
  outlinedButtonTheme: _outlinedButtonTheme,
);



light() {
return _lightThemeData;
}

dark() {
return _darkThemeData;
}
}