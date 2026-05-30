import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page_controller.dart';

class SearchPageController extends GetxController {
  static const String _historyKey = 'search_history_key';

  final HomePageController _homeController = Get.find<HomePageController>();

  var searchQuery = ''.obs;
  var searchHistory = <String>[].obs;
  var searchResults = <dynamic>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? history = prefs.getStringList(_historyKey);
      if (history != null) {
        searchHistory.assignAll(history);
      }
    } catch (e) {
      Get.log('Error loading search history: $e');
    }
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(_historyKey, searchHistory);
    } catch (e) {
      Get.log('Error saving search history: $e');
    }
  }

  void performSearch(String query) {
    searchQuery.value = query;
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    final cleanQuery = query.toLowerCase().trim();

    final results =
        _homeController.listSurah.where((surah) {
          final String englishName =
              (surah['englishName'] ?? '').toString().toLowerCase();
          final String arabicName = (surah['name'] ?? '').toString();
          final String number = (surah['number'] ?? '').toString();
          final String englishTranslation =
              (surah['englishNameTranslation'] ?? '').toString().toLowerCase();

          return englishName.contains(cleanQuery) ||
              arabicName.contains(cleanQuery) ||
              number == cleanQuery ||
              englishTranslation.contains(cleanQuery);
        }).toList();

    searchResults.assignAll(results);
  }

  Future<void> addHistory(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return;

    // Remove if already exists to move it to the top (newest first)
    searchHistory.removeWhere(
      (item) => item.toLowerCase() == cleanQuery.toLowerCase(),
    );

    // Add to the front of the list
    searchHistory.insert(0, cleanQuery);

    // Keep maximum 6 items
    if (searchHistory.length > 6) {
      searchHistory.removeRange(6, searchHistory.length);
    }

    await _saveHistory();
  }

  Future<void> removeHistory(String query) async {
    searchHistory.remove(query);
    await _saveHistory();
  }

  Future<void> clearHistory() async {
    searchHistory.clear();
    await _saveHistory();
  }
}
