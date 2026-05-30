import 'package:get/get.dart';

class FilterController extends GetxController {
  var selectedFilter = 'Semua'.obs;

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }
}
