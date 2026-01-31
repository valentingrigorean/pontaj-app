import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode { light, dark, system }

class ThemeState extends Equatable {
  final AppThemeMode themeMode;
  final Color accentColor;
  final Locale? locale;

  const ThemeState({
    this.themeMode = .system,
    this.accentColor = const Color(0xFF0F8D6E),
    this.locale,
  });

  ThemeMode get effectiveThemeMode {
    switch (themeMode) {
      case .light:
        return ThemeMode.light;
      case .dark:
        return ThemeMode.dark;
      case .system:
        return ThemeMode.system;
    }
  }

  @override
  List<Object?> get props => [themeMode, accentColor, locale];

  ThemeState copyWith({
    AppThemeMode? themeMode,
    Color? accentColor,
    Locale? locale,
    bool clearLocale = false,
  }) =>
      ThemeState(
        themeMode: themeMode ?? this.themeMode,
        accentColor: accentColor ?? this.accentColor,
        locale: clearLocale ? null : (locale ?? this.locale),
      );
}

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const ThemeState());

  static const _themeModeKey = 'themeMode';
  static const _accentColorKey = 'accentColor';
  static const _localeKey = 'locale';

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final themeModeStr = prefs.getString(_themeModeKey);
    final accentColorInt = prefs.getInt(_accentColorKey);
    final localeStr = prefs.getString(_localeKey);

    AppThemeMode themeMode = .system;
    if (themeModeStr == 'light') {
      themeMode = .light;
    } else if (themeModeStr == 'dark') {
      themeMode = .dark;
    }

    final accentColor = accentColorInt != null
        ? Color(accentColorInt)
        : const Color(0xFF0F8D6E);

    Locale? locale;
    if (localeStr != null && localeStr.isNotEmpty) {
      locale = Locale(localeStr);
    }

    emit(ThemeState(themeMode: themeMode, accentColor: accentColor, locale: locale));
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, mode.name);
    emit(state.copyWith(themeMode: mode));
  }

  Future<void> setAccentColor(Color color) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_accentColorKey, color.toARGB32());
    emit(state.copyWith(accentColor: color));
  }

  Future<void> setLocale(Locale? locale) async {
    final prefs = await SharedPreferences.getInstance();
    if (locale == null) {
      await prefs.setString(_localeKey, '');
      emit(state.copyWith(clearLocale: true));
    } else {
      await prefs.setString(_localeKey, locale.languageCode);
      emit(state.copyWith(locale: locale));
    }
  }

  ThemeData getLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: state.accentColor,
        brightness: Brightness.light,
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: state.accentColor, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: state.accentColor,
        brightness: Brightness.dark,
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: state.accentColor, width: 2),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}

class AppColors {
  static const teal = Color(0xFF0F8D6E);
  static const blue = Color(0xFF2196F3);
  static const purple = Color(0xFF9C27B0);
  static const orange = Color(0xFFFF9800);
  static const pink = Color(0xFFE91E63);
  static const green = Color(0xFF4CAF50);
  static const red = Color(0xFFF44336);
  static const indigo = Color(0xFF3F51B5);

  static List<Color> get allColors => [
        teal,
        blue,
        purple,
        orange,
        pink,
        green,
        red,
        indigo,
      ];

  static String getColorName(Color color) {
    if (color == teal) return 'Teal';
    if (color == blue) return 'Blue';
    if (color == purple) return 'Purple';
    if (color == orange) return 'Orange';
    if (color == pink) return 'Pink';
    if (color == green) return 'Green';
    if (color == red) return 'Red';
    if (color == indigo) return 'Indigo';
    return 'Custom';
  }
}
