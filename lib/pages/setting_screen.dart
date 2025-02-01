import 'package:dream_app/controller/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final ThemeController _themeController = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          _themeController.isDarkMode.value ? Colors.black : Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  print("object");
                  _themeController.toggleTheme();
                  print(_themeController.isDarkMode);
                },
                child: Text("Setting Screen"),
              ),
              Text(_themeController.isDarkMode.value.toString()),
              Obx(() {
                return Text(
                  "Theme is ${_themeController.isDarkMode.value ? 'Dark' : 'Light'}",
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
