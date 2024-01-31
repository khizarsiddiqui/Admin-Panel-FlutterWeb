import 'package:admin_panel/helpers/responsiveness.dart';
import 'package:admin_panel/widgets/large_screen.dart';
import 'package:admin_panel/widgets/side_menu.dart';
import 'package:admin_panel/widgets/small_screen.dart';
import 'package:flutter/material.dart';

import 'widgets/top_nav.dart';

class SiteLayout extends StatelessWidget {
  SiteLayout({super.key});

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        appBar: topNavigationBar(context, scaffoldKey),
        drawer: const Drawer(child: SideMenu()),
        body: const ResponsiveWidget(
          largeScreen: LargeScreen(),
          mediumScreen: LargeScreen(),
          smallScreen: SmallScreen(),
        ));
  }
}
