import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tenp_member_ecosystem/core/theme/app_theme.dart';

void main() {
  test('light theme uses approved neutral background and text colors', () {
    expect(AppTheme.light.scaffoldBackgroundColor, const Color(0xFFF8F9FA));
    expect(AppTheme.light.textTheme.bodyLarge?.color, const Color(0xFF212529));
  });

  test('dark theme uses approved neutral background and text colors', () {
    expect(AppTheme.dark.scaffoldBackgroundColor, const Color(0xFF121212));
    expect(AppTheme.dark.textTheme.bodyLarge?.color, const Color(0xFFF8F9FA));
  });
}
