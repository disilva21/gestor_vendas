import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class AppTheme {
  late final Color scaffoldBackgroundColor;
  late final Color primaryColor;
  late final Color accentColor;
  late final Color cardColor;
  late final Color cupertinoOverride;
  late final Color text;
  late final Color inputBorder;
  late final Color inputBorderEnabled;
  late final Color inputBorderDisabled;
  late final Color inputLabel;
  late final Color inputHint;
  late final Color butttonEnabled;
  late final Color butttonDisabled;
  late final Color textButttonPrimary;
  late final Color outlinedButttonPrimary;
  late final Color outlinedButttonSide;
  late final Color elevatedButttonPrimary;
  late final Color elevatedButttonOnPrimary;
  late final Brightness brightness;
  late final Color fillColor;

  /* factory AppTheme.dark(BuildContext context) {
    return ThemeDefaultColorDark(context);
  }*/
  factory AppTheme.ligth(BuildContext context) {
    return ThemeDefaultColorLigth(context);
  }

  ThemeData buildThemeData();
}

/*
class ThemeDefaultColorDark implements AppTheme {
  final BuildContext context;
  ThemeDefaultColorDark(this.context) : super();

  @override
  Color get scaffoldBackgroundColor => const Color(0xFF1a1a1a);
  @override
  ThemeData buildThemeData() {
    return buildTheme(context, this);
  }

  @override
  set primaryColor(Color primaryColor) {}

  @override
  set scaffoldBackgroundColor(Color _scaffoldBackgroundCol) {}
}
*/

class ThemeDefaultColorLigth implements AppTheme {
  final BuildContext context;
  ThemeDefaultColorLigth(this.context) : super();

  @override
  Color get scaffoldBackgroundColor => Color.fromARGB(255, 248, 251, 252);
  @override
  Color get primaryColor => Colors.white;
  @override
  Color get accentColor => Colors.black;
  @override
  Color get cardColor => Colors.white;
  @override
  Color get cupertinoOverride => Colors.black;
  @override
  Color get text => const Color.fromARGB(255, 63, 47, 2);
  @override
  Color get inputBorder => Colors.black;
  @override
  Color get inputBorderEnabled => Colors.grey;
  @override
  Color get inputBorderDisabled => Colors.black;
  @override
  Color get inputLabel => Colors.grey;
  @override
  Color get inputHint => const Color.fromARGB(255, 231, 224, 224);
  @override
  Color get butttonEnabled => Colors.black;
  @override
  Color get butttonDisabled => Colors.black;
  @override
  Color get textButttonPrimary => const Color.fromARGB(255, 42, 117, 179);
  @override
  Color get outlinedButttonPrimary => const Color.fromARGB(255, 42, 117, 179);
  @override
  Color get outlinedButttonSide => const Color.fromARGB(255, 42, 117, 179);
  @override
  Color get elevatedButttonPrimary => const Color.fromARGB(255, 42, 117, 179);
  @override
  Color get elevatedButttonOnPrimary => Colors.white;
  @override
  Color get fillColor => Colors.white;

  @override
  Brightness get brightness => Brightness.light;

  @override
  ThemeData buildThemeData() {
    return buildTheme(context, this);
  }

  @override
  set primaryColor(Color primaryColor) {}

  @override
  set accentColor(Color primaryColor) {}
  @override
  set brightness(Brightness brightness) {}
  @override
  set cardColor(Color cardColor) {}
  @override
  set cupertinoOverride(Color cupertinoOverride) {}
  @override
  set text(Color text) {}
  @override
  set inputBorder(Color inputBorder) {}
  @override
  set inputBorderEnabled(Color inputBorderEnabled) {}
  @override
  set inputBorderDisabled(Color inputBorderDisabled) {}
  @override
  set inputLabel(Color inputLabel) {}
  @override
  set inputHint(Color inputHint) {}
  @override
  set butttonEnabled(Color butttonEnabled) {}
  @override
  set butttonDisabled(Color butttonDisabled) {}
  @override
  set textButttonPrimary(Color textButttonPrimary) {}
  @override
  set outlinedButttonPrimary(Color outlinedButttonPrimary) {}
  @override
  set outlinedButttonSide(Color outlinedButttonSide) {}
  @override
  set elevatedButttonPrimary(Color elevatedButttonPrimary) {}
  @override
  set elevatedButttonOnPrimary(Color elevatedButttonOnPrimary) {}
  @override
  set fillColor(Color fillColor) {}

  @override
  set scaffoldBackgroundColor(Color _scaffoldBackgroundCol) {}
}

ThemeData buildTheme(BuildContext context, AppTheme appTheme) {
  const mainFont = 'Graphik';
  final theme = ThemeData(
    // useMaterial3: true,
    fontFamily: mainFont,
    //scaffoldBackgroundColor: appTheme.scaffoldBackgroundColor,
    primaryColor: Colors.white,
    // colorSchemeSeed: const Color.fromARGB(255, 6, 76, 134),
    dialogTheme: DialogTheme.of(context).copyWith(elevation: 1),

    appBarTheme: Theme.of(context).appBarTheme.copyWith(
          elevation: 0,
          //color: const Color.fromARGB(255, 118, 156, 187),
          color: Colors.white,
          iconTheme: IconThemeData(color: appTheme.elevatedButttonPrimary),
          titleTextStyle: const TextStyle(color: Colors.white),
          centerTitle: true,
        ),
    cardColor: Colors.white,
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
    // colorScheme: ColorScheme.fromSwatch(
    //   accentColor: appTheme.accentColor,
    //   brightness: appTheme.brightness,
    // ),
    toggleableActiveColor: appTheme.elevatedButttonPrimary,
    // Altera a cor do marcador de selacao dentro do text input
    textSelectionTheme: const TextSelectionThemeData(cursorColor: Color.fromARGB(255, 63, 47, 2)),
    cupertinoOverrideTheme: CupertinoThemeData(primaryColor: appTheme.cupertinoOverride),
    textTheme: TextTheme(
      bodyText2: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, fontFamily: mainFont, color: appTheme.text),
      bodyText1: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, fontFamily: mainFont, color: appTheme.text),
      button: Theme.of(context).textTheme.button!.copyWith(color: appTheme.text, fontFamily: mainFont),
      caption: TextStyle(color: appTheme.text),
      // Altera a cor da fonte dentro do text input
      subtitle1: const TextStyle(color: Color.fromARGB(255, 63, 47, 2), fontWeight: FontWeight.w500),
      headline1: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w800, fontFamily: mainFont, color: appTheme.text),
      headline2: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600, fontFamily: mainFont, color: appTheme.text),
      headline3: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400, fontFamily: mainFont, color: appTheme.text),
      headline4: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, fontFamily: mainFont, color: appTheme.text),
      headline5: TextStyle(fontSize: 14.0, fontWeight: FontWeight.normal, fontFamily: mainFont, color: appTheme.text),
      headline6: TextStyle(fontSize: 12.0, fontWeight: FontWeight.normal, fontFamily: mainFont, color: appTheme.text),
    ),
    inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
          // errorStyle: const TextStyle(
          //   color: Colors.red,
          //   height: 0,
          // ),
          // contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appTheme.inputBorderDisabled),
          ),
          labelStyle: TextStyle(color: appTheme.inputLabel),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: appTheme.inputBorderEnabled),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.red[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Colors.red[300]!),
            borderRadius: BorderRadius.circular(8),
          ),

          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: appTheme.inputBorderEnabled),
          ),
          hintStyle: TextStyle(color: appTheme.inputHint, fontFamily: mainFont, fontSize: 12.0),
          fillColor: appTheme.fillColor,
          // filled: true,
          //contentPadding: const EdgeInsets.all(10),
        ),
    buttonTheme: Theme.of(context).buttonTheme.copyWith(
          buttonColor: appTheme.butttonEnabled,
          disabledColor: appTheme.butttonDisabled,
          alignedDropdown: false,
          height: 55,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
        ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
          // primary: appTheme.textButttonPrimary,
          ),
    ),
    //scaffoldBackgroundColor: appTheme.scaffoldBackgroundColor,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(backgroundColor: Color.fromARGB(255, 42, 117, 179)),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(320, 50),
        side: const BorderSide(color: Color.fromARGB(255, 42, 117, 179)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        textStyle: const TextStyle(
          color: Color.fromARGB(255, 42, 117, 179),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: appTheme.elevatedButttonPrimary,
        foregroundColor: appTheme.elevatedButttonOnPrimary,
        minimumSize: const Size(320, 55),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        textStyle: TextStyle(
          color: appTheme.text,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    ),
  );

  return theme;
}
