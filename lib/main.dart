import 'dart:ui';

import 'package:admin_panel/constants/style.dart';
import 'package:admin_panel/controllers/menu_controller.dart' as menu_controller;
import 'package:admin_panel/controllers/navigation_controller.dart';
import 'package:admin_panel/env/env.dart';
import 'package:admin_panel/layout.dart';
import 'package:admin_panel/pages/404/error_page.dart';
import 'package:admin_panel/pages/authentication/authentication.dart';
import 'package:admin_panel/routing/routes.dart';
import 'package:firebase_core/firebase_core.dart';
// ignore: unused_import
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: Env.apiKey,
          appId: Env.appId,
          messagingSenderId: Env.messagingSenderId,
          projectId: Env.projectId,
          authDomain: Env.authDomain,
          storageBucket: Env.storageBucket));
  Get.put(menu_controller.MenuController());
  Get.put(NavigationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      initialRoute: authenticationPageRoute,
      unknownRoute:
          GetPage(name: '/not-found', page: () => const PageNotFound()),
      defaultTransition: Transition.leftToRightWithFade,
      getPages: [
        GetPage(name: rootRoute, page: () => SiteLayout()),
        GetPage(
            name: authenticationPageRoute,
            page: () => const AuthenticationPage()),
      ],
      debugShowCheckedModeBanner: false,
      title: "Admin Panel",
      theme: ThemeData(
        scaffoldBackgroundColor: light,
        textTheme: GoogleFonts.mulishTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Colors.black,
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          },
        ),
        primarySwatch: Colors.indigo,
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
