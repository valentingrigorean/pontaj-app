import 'package:flutter/material.dart';

/// Breakpoint values for responsive design
class Breakpoints {
  static const double mobile = 600;
  static const double tablet = 900;

  Breakpoints._();
}

/// Screen type based on width
enum ScreenType { mobile, tablet, desktop }

/// Extension on BuildContext for responsive utilities
extension ResponsiveContext on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;

  bool get isMobile => screenWidth < Breakpoints.mobile;
  bool get isTablet =>
      screenWidth >= Breakpoints.mobile && screenWidth < Breakpoints.tablet;
  bool get isDesktop => screenWidth >= Breakpoints.tablet;

  ScreenType get screenType {
    if (isMobile) return .mobile;
    if (isTablet) return .tablet;
    return .desktop;
  }
}

/// Helper class for responsive values
class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;

  const ResponsiveValue({required this.mobile, this.tablet, this.desktop});

  T resolve(BuildContext context) {
    switch (context.screenType) {
      case .desktop:
        return desktop ?? tablet ?? mobile;
      case .tablet:
        return tablet ?? mobile;
      case .mobile:
        return mobile;
    }
  }
}

/// Common responsive spacing values
class ResponsiveSpacing {
  static EdgeInsets pagePadding(BuildContext context) {
    return .all(context.isMobile ? 16 : 24);
  }

  static EdgeInsets cardPadding(BuildContext context) {
    return .all(context.isMobile ? 16 : 20);
  }

  static double gap(BuildContext context) {
    return context.isMobile ? 12 : 16;
  }

  ResponsiveSpacing._();
}

/// Widget that builds different layouts based on screen size
class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    switch (context.screenType) {
      case .desktop:
        return desktop ?? tablet ?? mobile;
      case .tablet:
        return tablet ?? mobile;
      case .mobile:
        return mobile;
    }
  }
}

/// Responsive grid that adapts column count based on screen size
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int mobileColumns;
  final int tabletColumns;
  final int desktopColumns;
  final double spacing;
  final double runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns = 1,
    this.tabletColumns = 2,
    this.desktopColumns = 3,
    this.spacing = 12,
    this.runSpacing = 12,
  });

  @override
  Widget build(BuildContext context) {
    final columns = switch (context.screenType) {
      .desktop => desktopColumns,
      .tablet => tabletColumns,
      .mobile => mobileColumns,
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        final rows = <List<Widget>>[];
        for (var i = 0; i < children.length; i += columns) {
          final end = (i + columns < children.length)
              ? i + columns
              : children.length;
          rows.add(children.sublist(i, end));
        }

        return Column(
          children: rows.asMap().entries.map((entry) {
            final rowIndex = entry.key;
            final rowChildren = entry.value;
            return Padding(
              padding: .only(top: rowIndex > 0 ? runSpacing : 0),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: .stretch,
                  children: rowChildren.asMap().entries.map((childEntry) {
                    final childIndex = childEntry.key;
                    final child = childEntry.value;
                    return Padding(
                      padding: .only(left: childIndex > 0 ? spacing : 0),
                      child: SizedBox(width: itemWidth, child: child),
                    );
                  }).toList(),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

/// Wrapper that centers content with a max width constraint
class ResponsiveCenter extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsets? padding;

  const ResponsiveCenter({
    super.key,
    required this.child,
    this.maxWidth = 600,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: child,
    );

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }

    return Center(child: content);
  }
}
