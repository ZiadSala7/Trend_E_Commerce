/// Breakpoints for responsive layout (mobile vs tablet).
class Breakpoints {
  Breakpoints._();

  /// Width below which the layout is considered mobile.
  static const double tablet = 600;

  static bool isTablet(double width) => width >= tablet;
  static bool isMobile(double width) => width < tablet;
}
