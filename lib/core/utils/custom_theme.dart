import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static ThemeData get theme {
    return ThemeData(
        // primaryColor: const Color(0xFF1CB5E0),
        primaryColor: const Color(0xFF1CB5E0),
        scaffoldBackgroundColor: const Color(0xFF171717),
        // scaffoldBackgroundColor: const Color(0xFF2C2C2C),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color.fromARGB(255, 44, 44, 81),
          primary: const Color(0xFF1CB5E0),
        ),

        appBarTheme: AppBarTheme(
            surfaceTintColor: Colors.transparent,

            backgroundColor: const Color(0xFF171717),
            // backgroundColor: const Color(0xFF2C2C2C),
            centerTitle: true,
            titleTextStyle:
                GoogleFonts.aBeeZee(fontSize: 26.sp, color: Colors.white)),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF1CB5E0),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1CB5E0),
          ),
        ),
        textTheme: TextTheme(
          titleLarge: GoogleFonts.bebasNeue(
            textStyle: TextStyle(color: Colors.white, fontSize: 45.sp),
          ),
          // titleMedium:  GoogleFonts.bebasNeue(
          //   textStyle: TextStyle(color: Colors.white, fontSize: 25.sp),
          // ),
          headlineMedium: GoogleFonts.openSans(
            textStyle: TextStyle(color: Colors.white, fontSize: 22.sp),
          ),
          headlineLarge: GoogleFonts.openSans(
            textStyle: TextStyle(color: Colors.white, fontSize: 26.sp),
          ),
          bodyLarge: GoogleFonts.openSans(
            textStyle: TextStyle(color: Colors.white, fontSize: 16.sp),
          ),
          bodyMedium: GoogleFonts.openSans(
            textStyle: TextStyle(color: Colors.white70, fontSize: 14.sp),
          ),
          bodySmall: GoogleFonts.openSans(
            textStyle: TextStyle(color: Colors.white70, fontSize: 12.sp),
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
        }));
  }
}
