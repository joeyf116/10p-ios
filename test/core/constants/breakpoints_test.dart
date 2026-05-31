import 'package:flutter_test/flutter_test.dart';
import 'package:tenp_member_ecosystem/core/constants/breakpoints.dart';

void main() {
  test('returns mobile for widths under 600', () {
    expect(viewportForWidth(599), AppViewport.mobile);
  });

  test('returns tablet for widths between 600 and 1024', () {
    expect(viewportForWidth(600), AppViewport.tablet);
    expect(viewportForWidth(1024), AppViewport.tablet);
  });

  test('returns desktop for widths over 1024', () {
    expect(viewportForWidth(1025), AppViewport.desktop);
  });
}
