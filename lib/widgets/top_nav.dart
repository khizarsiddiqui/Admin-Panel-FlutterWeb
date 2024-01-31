import 'package:admin_panel/constants/style.dart';
import 'package:admin_panel/controllers/logged_user_controller.dart';
import 'package:admin_panel/helpers/responsiveness.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_network/image_network.dart';

import 'custom_text.dart';

final LoggedUserController _loggedUserController =
    Get.put(LoggedUserController());

AppBar topNavigationBar(BuildContext context, GlobalKey<ScaffoldState> key) =>
    AppBar(
      leading: !ResponsiveWidget.isSmallScreen(context)
          ? Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Image.asset(
                    "assets/icons/mechanic2.png",
                    width: 28,
                  ),
                ),
              ],
            )
          : IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                key.currentState!.openDrawer();
              }),
      title: Row(
        children: [
          Visibility(
              visible: !ResponsiveWidget.isSmallScreen(context),
              child: const CustomText(
                text: "Admin Panel",
                color: Colors.lightBlueAccent,
                size: 20,
                weight: FontWeight.bold,
              )),
          Expanded(child: Container()),
          const SizedBox(
            width: 24,
          ),
          if (!ResponsiveWidget.isSmallScreen(context))
            Obx(() => CustomText(
                  text: _loggedUserController.loggedUser.name ?? "Admin",
                  color: Colors.lightBlueAccent,
                )),
          const SizedBox(
            width: 16,
          ),
          Container(
            decoration: BoxDecoration(
                color: active.withOpacity(.5),
                borderRadius: BorderRadius.circular(30)),
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.all(2),
                margin: const EdgeInsets.all(2),
                child: Obx(() => CircleAvatar(
                    backgroundColor: light,
                    child: _loggedUserController.loggedUser.imageUrl == null
                        ? Icon(
                            Icons.construction,
                            color: dark,
                          )
                        : ImageNetwork(
                            image: _loggedUserController.loggedUser.imageUrl!,
                            width: 40,
                            height: 40,
                            borderRadius: BorderRadius.circular(70),
                            onLoading: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          )))),
          ),
        ],
      ),
      iconTheme: IconThemeData(color: dark),
      elevation: 0,
      backgroundColor: Colors.transparent,
    );
