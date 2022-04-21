// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';

import '../../view/constant/app_colors.dart';

class CustomTheme {
  /// Define the dark theme using [ThemeData]
  static final ThemeData darkTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.darkScaffoldBackgroundColor,
      colorScheme: ColorScheme.dark().copyWith(
        onSecondary: Colors.white,
      ),
     /* textTheme: TextTheme(
        headline1:
            AppFontStyle.headline1.copyWith(color: AppColors.darkHeadline1),
        headline2:
            AppFontStyle.headline2.copyWith(color: AppColors.dividerColor),
        headline3: AppFontStyle.headline3.copyWith(color: AppColors.appAmber),
        headline4:
            AppFontStyle.headline4.copyWith(color: AppColors.darkHeadline4),
        headline5: AppFontStyle.headline5,
        headline6: AppFontStyle.headline6,
        bodyText1: AppFontStyle.bodyText1,
        bodyText2: AppFontStyle.bodyText2,
        subtitle1: AppFontStyle.subtitle1,
        subtitle2: AppFontStyle.subtitle2,
      ),*/
      highlightColor: Color(0xff2A63D4),
     // appBarTheme: FlutterAppBarTheme.darkAppBarTheme,
      cardTheme: CardTheme(
        color: AppColors.darkCardColor,
      ),
      iconTheme: IconThemeData(
        color: AppColors.iconColor,
      ));

  /// Define the light theme styles using [ThemeData]
  static final ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.lightScaffoldBackgroundColor,
    colorScheme: ColorScheme.light().copyWith(
      onSecondary: Colors.black,
    ),
    /*textTheme: TextTheme(
      headline1:
          AppFontStyle.headline1.copyWith(color: AppColors.lightHeadline1),
      headline2: AppFontStyle.headline2.copyWith(color: AppColors.borderColor),
      headline3: AppFontStyle.headline3.copyWith(color: AppColors.shadowRed),
      headline4:
          AppFontStyle.headline4.copyWith(color: AppColors.lightHeadline4),
      headline5: AppFontStyle.headline5,
      headline6: AppFontStyle.headline6,
      bodyText1: AppFontStyle.bodyText1,
      bodyText2: AppFontStyle.bodyText2,
      subtitle1: AppFontStyle.subtitle1,
      subtitle2: AppFontStyle.subtitle2,
    ),*/
    highlightColor: Color(0xff2A63D4),
   // appBarTheme: FlutterAppBarTheme.lightAppBarTheme,
    cardTheme: CardTheme(
      color: AppColors.lightCardColor,
    ),
  );
}

/// Collection off font styles used throughout the app
/*class AppFontStyle {
  static final TextStyle headline1 = GoogleFonts.poppins(textStyle: headline1);
  static final TextStyle headline2 = GoogleFonts.poppins(textStyle: headline2);
  static final TextStyle headline3 = GoogleFonts.poppins(textStyle: headline3);
  static final TextStyle headline4 = GoogleFonts.poppins(textStyle: headline4);
  static final TextStyle headline5 = GoogleFonts.poppins(textStyle: headline5);
  static final TextStyle headline6 = GoogleFonts.poppins(textStyle: headline6);
  static final TextStyle body1 = GoogleFonts.poppins(textStyle: body1);
  static final TextStyle body2 = GoogleFonts.poppins(textStyle: body2);
  static final TextStyle bodyText1 = GoogleFonts.poppins(textStyle: bodyText1);
  static final TextStyle bodyText2 = GoogleFonts.poppins(textStyle: bodyText2);
  static final TextStyle subtitle1 = GoogleFonts.poppins(textStyle: subtitle1);
  static final TextStyle subtitle2 = GoogleFonts.poppins(textStyle: subtitle2);
  static final TextStyle subtitle = GoogleFonts.poppins(textStyle: subtitle);
  static final TextStyle subhead = GoogleFonts.poppins(textStyle: subhead);
}*/

/// Create and customize app specific [AppBar]'s
class FlutterAppBarTheme {
  /// Define the light [AppBar] theme for using in light[Theme]
  static final lightAppBarTheme = AppBarTheme(
    brightness: Brightness.light,
    iconTheme: IconThemeData(
      color: AppColors.lightAppBarTitleTextColor,
    ),
    textTheme: ThemeData.dark().textTheme.copyWith(
          // headline6: GoogleFonts.poppins(
          //   fontWeight: FontWeight.bold,
          //   fontSize: 18.0,
          //   color: AppColors.lightAppBarTitleTextColor,
          // ),
        ),
    color: AppColors.lightAppBarBackgroundColor,
  );

  /// Define the dark app bar [Theme] for using in dark[Theme]
  static final darkAppBarTheme = AppBarTheme(
    brightness: Brightness.dark,
    iconTheme: IconThemeData(
      color: AppColors.darkAppBarTitleTextColor,
    ),
    textTheme: ThemeData.light().textTheme.copyWith(
          // headline6: GoogleFonts.poppins(
          //   fontWeight: FontWeight.bold,
          //   fontSize: 18.0,
          //   color: AppColors.darkAppBarTitleTextColor,
          // ),
        ),
    color: AppColors.darkAppBarBackgroundColor,
  );
}
