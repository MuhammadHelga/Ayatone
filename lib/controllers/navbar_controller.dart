import 'package:get/get.dart';

class NavBarController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    if (selectedIndex.value == index) return;
    selectedIndex.value = index;
  }
}