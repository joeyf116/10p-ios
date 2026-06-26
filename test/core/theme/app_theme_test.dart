import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tenp_member_ecosystem/core/theme/app_theme.dart';

void main() {
  test('light theme uses brand background color', () {
    expect(AppTheme.light.scaffoldBackgroundColor, const Color(0xFFF5F5F5));
  });

  test('dark theme uses brand black background', () {
    expect(AppTheme.dark.scaffoldBackgroundColor, const Color(0xFF0A0A0A));
  });

  test('brand red is the primary color', () {
    expect(AppTheme.brandRed, const Color(0xFFCC0000));
    expect(AppTheme.dark.colorScheme.primary, const Color(0xFFCC0000));
  });
}
