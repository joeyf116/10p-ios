enum AppViewport { mobile, tablet, desktop }

AppViewport viewportForWidth(double width) {
  if (width < 600) {
    return AppViewport.mobile;
  }
  if (width <= 1024) {
    return AppViewport.tablet;
  }
  return AppViewport.desktop;
}
