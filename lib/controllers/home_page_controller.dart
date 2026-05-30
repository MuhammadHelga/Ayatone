import 'package:get/get.dart';
import '../services/auth_services.dart';
import 'filter_controller.dart';

class HomePageController extends GetxController {
  final AuthServices _authServices = AuthServices();
  final FilterController _filterController = Get.put(FilterController(), permanent: true);

  var isLoading = false.obs;
  var listSurah = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSurah();
  }

  List<dynamic> get filteredSurah {
    final filter = _filterController.selectedFilter.value;
    if (filter == 'Makkiyah') {
      return listSurah
          .where((surah) => surah['revelationType'] == 'Meccan')
          .toList();
    } else if (filter == 'Madaniyah') {
      return listSurah
          .where((surah) => surah['revelationType'] == 'Medinan')
          .toList();
    }
    return listSurah;
  }

  Future<void> fetchSurah() async {
    try {
      isLoading(true);
      final response = await _authServices.getSurah();
      if (response != null && response['data'] != null) {
        listSurah.assignAll(response['data']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat data surah: $e');
    } finally {
      isLoading(false);
    }
  }
}
