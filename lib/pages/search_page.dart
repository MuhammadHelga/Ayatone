import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import '../controllers/search_page_controller.dart';
import '../widgets/card_surah.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final SearchPageController controller = Get.put(SearchPageController());
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Appcolors.surfaceContainer,
      appBar: AppBar(
        title: Text(
          'Cari Surah',
          style: TextStyle(
            fontFamily: 'NotoSerif',
            fontWeight: FontWeight.bold,
            fontSize: width * 0.06,
            color: Appcolors.onSurface,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Appcolors.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _textController,
                style: TextStyle(
                  fontFamily: 'NotoSerif',
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w600,
                  color: Appcolors.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Cari nama surah atau nomor...',
                  hintStyle: TextStyle(
                    fontFamily: 'NotoSerif',
                    fontSize: width * 0.038,
                    fontWeight: FontWeight.w500,
                    color: Appcolors.secondary.withValues(alpha: 0.6),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: Appcolors.primary,
                    size: width * 0.06,
                  ),
                  suffixIcon: Obx(() {
                    if (controller.searchQuery.value.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: Appcolors.secondary,
                        size: width * 0.05,
                      ),
                      onPressed: () {
                        _textController.clear();
                        controller.performSearch('');
                      },
                    );
                  }),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: width * 0.04,
                  ),
                ),
                onChanged: (value) => controller.performSearch(value),
                onSubmitted: (value) {
                  controller.addHistory(value);
                },
                textInputAction: TextInputAction.search,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(() {
                final isQueryEmpty =
                    controller.searchQuery.value.trim().isEmpty;

                if (isQueryEmpty) {
                  if (controller.searchHistory.isNotEmpty) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pencarian Terbaru',
                              style: TextStyle(
                                fontFamily: 'NotoSerif',
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.04,
                                color: Appcolors.secondary,
                              ),
                            ),
                            TextButton(
                              onPressed: () => controller.clearHistory(),
                              style: TextButton.styleFrom(
                                foregroundColor: Appcolors.primary,
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                'Hapus Semua',
                                style: TextStyle(
                                  fontFamily: 'NotoSerif',
                                  fontWeight: FontWeight.bold,
                                  fontSize: width * 0.035,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Expanded(
                          child: ListView.separated(
                            itemCount: controller.searchHistory.length,
                            separatorBuilder:
                                (context, index) => Divider(
                                  color: Appcolors.dim.withValues(alpha: 0.5),
                                  height: 1,
                                ),
                            itemBuilder: (context, index) {
                              final query = controller.searchHistory[index];
                              return _buildHistoryItem(query, width);
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.all(width * 0.06),
                              decoration: BoxDecoration(
                                color: Appcolors.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.search_rounded,
                                size: width * 0.16,
                                color: Appcolors.primary,
                              ),
                            ),
                            SizedBox(height: width * 0.06),
                            Text(
                              'Cari Surah Al-Qur\'an',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'NotoSerif',
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.045,
                                color: Appcolors.onSurface,
                              ),
                            ),
                            SizedBox(height: width * 0.02),
                            Text(
                              'Temukan surah dengan mengetik nama atau nomor surah.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'NotoSerif',
                                fontWeight: FontWeight.w500,
                                fontSize: width * 0.035,
                                color: Appcolors.secondary.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                if (controller.searchResults.isEmpty) {
                  return Center(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width * 0.05),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Tidak Ditemukan Hasil',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'NotoSerif',
                                fontWeight: FontWeight.bold,
                                fontSize: width * 0.045,
                                color: Appcolors.onSurface,
                              ),
                            ),
                            SizedBox(height: width * 0.02),
                            Text(
                              'Tidak ada surah yang cocok dengan kata kunci "${controller.searchQuery.value}"',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'NotoSerif',
                                fontWeight: FontWeight.w500,
                                fontSize: width * 0.035,
                                color: Appcolors.secondary.withValues(
                                  alpha: 0.8,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hasil Pencarian',
                      style: TextStyle(
                        fontFamily: 'NotoSerif',
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.04,
                        color: Appcolors.secondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.separated(
                        itemCount: controller.searchResults.length,
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final surah = controller.searchResults[index];
                          return Listener(
                            onPointerDown: (_) {
                              controller.addHistory(surah['englishName'] ?? '');
                            },
                            child: CardSurah(
                              number: surah['number'],
                              name: surah['englishName'] ?? '',
                              latinName: surah['name'] ?? '',
                              countAyat: surah['numberOfAyahs'] ?? 0,
                              revelationType:
                                  surah['revelationType'] == 'Meccan'
                                      ? 'Makkiyah'
                                      : 'Madaniyah',
                              audioUrl: '',
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String query, double width) {
    return InkWell(
      onTap: () {
        _textController.text = query;
        controller.performSearch(query);
        controller.addHistory(query);
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: width * 0.03),
        child: Row(
          children: [
            Icon(
              Icons.history_rounded,
              size: width * 0.05,
              color: Appcolors.secondary,
            ),
            SizedBox(width: width * 0.04),
            Expanded(
              child: Text(
                query,
                style: TextStyle(
                  fontFamily: 'NotoSerif',
                  fontSize: width * 0.038,
                  fontWeight: FontWeight.w500,
                  color: Appcolors.onSurface,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.close_rounded,
                size: width * 0.05,
                color: Appcolors.secondary,
              ),
              onPressed: () => controller.removeHistory(query),
              constraints: const BoxConstraints(),
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
