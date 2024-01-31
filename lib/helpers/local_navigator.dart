import 'package:admin_panel/constants/controllers.dart';
import 'package:admin_panel/routing/router.dart';
import 'package:admin_panel/routing/routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Navigator localNavigator() => Navigator(
    key: navigationController.navigatorKey,
    initialRoute: overViewPageRoute,
    onGenerateRoute: generateRoute);
