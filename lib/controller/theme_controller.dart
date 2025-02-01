import 'package:get/get.dart';

class ThemeController extends GetxController {
  // var isDarkMode = false.obs;

  Rx<bool> isDarkMode = false.obs;

  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    update();
  }
}
