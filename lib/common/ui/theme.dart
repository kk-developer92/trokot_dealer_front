import 'package:flutter/material.dart';
import 'package:trokot_dealer_mobile/common/ui/styles.dart' as styles;

final appTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
    useMaterial3: true,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: styles.elevatedButtonStyle,
    ));
