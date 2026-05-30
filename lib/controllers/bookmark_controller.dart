import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkController extends GetxController {
  static const String _bookmarkKey = 'bookmarked_surahs';

  var bookmarkedSurahs = <dynamic>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBookmarks();
  }

  Future<void> loadBookmarks() async {
    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final String? bookmarksJson = prefs.getString(_bookmarkKey);
      if (bookmarksJson != null) {
        final List<dynamic> decoded = jsonDecode(bookmarksJson);
        bookmarkedSurahs.assignAll(decoded);
      }
    } catch (e) {
      Get.log('Error loading bookmarks: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> _saveBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(bookmarkedSurahs);
      await prefs.setString(_bookmarkKey, encoded);
    } catch (e) {
      Get.log('Error saving bookmarks: $e');
    }
  }

  bool isBookmarked(int surahNumber) {
    return bookmarkedSurahs.any((surah) => surah['number'] == surahNumber);
  }

  Future<void> toggleBookmark(dynamic surah) async {
    if (surah == null) return;
    final int surahNumber = surah['number'];
    final String englishName = surah['englishName'] ?? '';

    if (isBookmarked(surahNumber)) {
      bookmarkedSurahs.removeWhere((s) => s['number'] == surahNumber);
      Get.snackbar(
        'Bookmark Dihapus',
        'Surah $englishName telah dihapus dari daftar simpanan.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } else {
      final surahMap = Map<String, dynamic>.from(surah);
      bookmarkedSurahs.add(surahMap);
      bookmarkedSurahs.sort((a, b) => (a['number'] as int).compareTo(b['number'] as int));
      
      Get.snackbar(
        'Bookmark Ditambahkan',
        'Surah $englishName telah disimpan.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    }
    await _saveBookmarks();
  }
}
