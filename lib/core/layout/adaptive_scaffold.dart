import 'package:flutter/material.dart';

import '../constants/breakpoints.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    required this.title,
    required this.body,
    super.key,
  });

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewport = viewportForWidth(constraints.maxWidth);
        const navDestinations = [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined), label: 'Schedule'),
          NavigationDestination(
              icon: Icon(Icons.qr_code_2_outlined), label: 'Check-In'),
          NavigationDestination(
              icon: Icon(Icons.video_collection_outlined), label: 'Library'),
        ];

        if (viewport == AppViewport.mobile) {
          return Scaffold(
            appBar: AppBar(title: Text(title)),
            body: body,
            bottomNavigationBar: NavigationBar(destinations: navDestinations),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Row(
            children: [
              NavigationRail(
                destinations: navDestinations
                    .map((d) => NavigationRailDestination(
                        icon: d.icon, label: Text(d.label)))
                    .toList(),
                selectedIndex: 0,
              ),
              const VerticalDivider(width: 1),
              Expanded(child: body),
            ],
          ),
        );
      },
    );
  }
}
