import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constants.dart';

ThemeData lightTheme() {
  return ThemeData(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: lightAppBarTheme(),
      textTheme: lightTextTheme(),
      inputDecorationTheme: inputDecorationTheme(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      drawerTheme: DrawerThemeData(backgroundColor: Colors.white),
      iconTheme: IconThemeData(
        color: Colors.black,
        size: 20,
      ),
      cardTheme: CardTheme(color: Colors.white),
      listTileTheme: ListTileThemeData(textColor: Colors.black));
}

ThemeData darkTheme() {
  return ThemeData(
      scaffoldBackgroundColor: Colors.black,

      appBarTheme: darkAppBarTheme(),
      textTheme: darkTextTheme(),
      inputDecorationTheme: inputDecorationTheme(),
      visualDensity: VisualDensity.adaptivePlatformDensity,
      drawerTheme: DrawerThemeData(
        backgroundColor: Colors.black,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
        size: 20,
      ),
      cardTheme: CardTheme(color: Colors.grey.shade800),
      listTileTheme: ListTileThemeData(
        textColor: Colors.white,
        iconColor: Colors.white,
      ));
}

InputDecorationTheme inputDecorationTheme() {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: BorderSide(color: kTextColor),
    gapPadding: 10,
  );
  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    contentPadding: EdgeInsets.symmetric(horizontal: 42, vertical: 20),
    enabledBorder: outlineInputBorder,
    focusedBorder: outlineInputBorder,
    border: outlineInputBorder,
  );
}

TextTheme lightTextTheme() {
  return TextTheme(
    titleLarge:   TextStyle(
      color: Colors.black,
    ),
    titleMedium: GoogleFonts.zillaSlab(textStyle: TextStyle(color: Colors.black)),
    titleSmall: GoogleFonts.zillaSlab(textStyle: TextStyle(color: Colors.black)),
    bodyLarge: GoogleFonts.zillaSlab(textStyle: TextStyle(
      color: Colors.black,
    )),
    bodyMedium: GoogleFonts.zillaSlab(textStyle: TextStyle(color: Colors.black)),
    bodySmall: GoogleFonts.zillaSlab(textStyle: TextStyle(color: Colors.black)),
  );
}

TextTheme darkTextTheme() {
  return  TextTheme(
    titleLarge: GoogleFonts.zillaSlab(textStyle: TextStyle(
      color: Colors.white,
    ),),
    titleMedium: GoogleFonts.zillaSlab(textStyle: TextStyle(color: Colors.white),),
    titleSmall: GoogleFonts.zillaSlab(textStyle: TextStyle(color: Colors.white),),
    bodyLarge: GoogleFonts.zillaSlab(textStyle: TextStyle(
      color: Colors.white,
    )),
    bodyMedium: GoogleFonts.zillaSlab(textStyle: TextStyle(color: Colors.white)),
    bodySmall: GoogleFonts.zillaSlab(textStyle: TextStyle(color: Colors.white)),
  );
}

AppBarTheme lightAppBarTheme() {
  return  AppBarTheme(
    color: Colors.white,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.black),
    titleTextStyle: GoogleFonts.zillaSlab(textStyle: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18)),
    systemOverlayStyle: SystemUiOverlayStyle.dark,
  );
}

AppBarTheme darkAppBarTheme() {
  return AppBarTheme(
    color: Colors.black,
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: GoogleFonts.zillaSlab(textStyle: TextStyle(color: Color(0XFF8B8B8B), fontSize: 18)),
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );
}
